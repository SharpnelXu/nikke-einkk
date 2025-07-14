import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:nikke_einkk/model/battle/battle_entity.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';
import 'package:nikke_einkk/model/battle/events/battle_start_event.dart';
import 'package:nikke_einkk/model/battle/events/burst_gen_event.dart';
import 'package:nikke_einkk/model/battle/events/change_burst_step_event.dart';
import 'package:nikke_einkk/model/battle/events/exit_full_burst_event.dart';
import 'package:nikke_einkk/model/battle/events/nikke_damage_event.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/user_data.dart';

class BattleSimulation {
  final bool useGlobal;
  NikkeDatabase get db => useGlobal ? global : cn;

  PlayerOptions playerOptions;

  List<BattleNikke?> battleNikkes = [];
  List<BattleNikke> get nonnullNikkes => battleNikkes.nonNulls.toList();
  List<BattleRapture> raptures = [];
  // timeline
  SplayTreeMap<int, List<BattleEvent>> timeline = SplayTreeMap((a, b) => b.compareTo(a));
  late int currentFrame;
  int get nextFrame => currentFrame - 1;

  // maybe configurable in the future or put into a global option class
  int fps = 60;
  int maxSeconds = 180;
  int get maxFrames => fps * maxSeconds;

  int _burstMeter = 0;
  int get burstMeter => _burstMeter;
  set burstMeter(int value) => _burstMeter = value.clamp(0, constData.burstMeterCap);
  int burstStage = 0;
  int reEnterBurstCd = 0;
  int burstStageFramesLeft = 0;
  int fullBurstDuration = 0;

  // player actions, maybe move to a dedicated object to represent current frame
  bool autoAttack = true;
  bool autoBurst = true;
  bool useCover = false;
  int currentNikke = 3;

  BattleSimulation({
    required this.playerOptions,
    required List<NikkeOptions?> nikkeOptions,
    required List<BattleRaptureOptions> raptureOptions,
    this.useGlobal = true,
  }) {
    battleNikkes.addAll(
      nikkeOptions.map((option) {
        final characterData = db.characterResourceGardeTable[option?.nikkeResourceId]?[option?.coreLevel];
        final weaponData = db.characterShotTable[characterData?.shotId];
        return option == null || characterData == null || weaponData == null
            ? null
            : BattleNikke(playerOptions: playerOptions, option: option, useGlobal: useGlobal);
      }),
    );
    raptures.addAll(raptureOptions.map((option) => BattleRapture(option)));
  }

  void init() {
    timeline.clear();
    burstMeter = 0;
    burstStage = 0;
    reEnterBurstCd = 0;
    burstStageFramesLeft = 0;
    fullBurstDuration = 0;

    for (int index = 0; index < battleNikkes.length; index += 1) {
      battleNikkes[index]?.init(this, index + 1);
    }
    if (currentNikke >= battleNikkes.length || battleNikkes[currentNikke - 1] == null) {
      currentNikke = nonnullNikkes.first.uniqueId;
    }

    for (int index = 0; index < raptures.length; index += 1) {
      raptures[index].init(this, index + 11);
    }

    currentFrame = maxFrames + 1;
    // BattleStart
    for (final nikke in nonnullNikkes) {
      nikke.broadcast(BattleStartEvent.battleStartEvent, this);
    }
    currentFrame = maxFrames;
  }

  void proceedOneFrame() {
    if (currentFrame <= 0) {
      return;
    }

    for (final entity in [...nonnullNikkes, ...raptures]) {
      entity.normalAction(this);
    }

    if (playerOptions.forceFillBurst && burstStage == 0) {
      registerEvent(currentFrame, ChangeBurstStepEvent(-1, 0, 1, -1));
      burstStage = 1;
    }

    reEnterBurstCd = max(0, reEnterBurstCd - 1);
    burstStageFramesLeft = max(0, burstStageFramesLeft - 1);
    if (burstStage > 1 && burstStageFramesLeft == 0) {
      if (burstStage == 4) {
        registerEvent(currentFrame, ExitFullBurstEvent.exitFullBurstEvent);
      }
      burstStage = 0;
    }

    // broadcast all events registered for this frame
    for (int index = 0; index < (timeline[currentFrame]?.length ?? 0); index += 1) {
      final event = timeline[currentFrame]![index];

      if (event is BurstGenerationEvent) {
        if (burstStage == 0) {
          burstMeter += event.burst;

          if (burstMeter == constData.burstMeterCap) {
            registerEvent(currentFrame, ChangeBurstStepEvent(-1, 0, 1, -1));
            burstStage = 1;
            burstMeter = 0;
          }
        }
      }

      if (event is ChangeBurstStepEvent) {
        if (event.nextStage > event.currentStage) {
          reEnterBurstCd = 0;
        }
        burstStage = event.nextStage;
        burstStageFramesLeft = timeDataToFrame(event.duration, fps);
        burstStageFramesLeft = max(0, burstStageFramesLeft);
        if (event.nextStage == 4) {
          fullBurstDuration = burstStageFramesLeft;
        }
      }

      for (final nikke in nonnullNikkes) {
        nikke.broadcast(event, this);
      }

      for (final rapture in raptures) {
        rapture.broadcast(event, this);
      }
    }

    for (final entity in [...nonnullNikkes, ...raptures]) {
      entity.endCurrentFrame(this);
    }

    currentFrame -= 1;
  }

  void simulate() {
    if (nonnullNikkes.isEmpty) return;

    init();

    while (currentFrame > 0) {
      proceedOneFrame();
    }
  }

  BattleNikke? getNikkeOnPosition(int position) {
    return nonnullNikkes.firstWhereOrNull((nikke) => nikke.uniqueId == position);
  }

  BattleRapture? getRaptureByUniqueId(int uniqueId) {
    return raptures.firstWhereOrNull((rapture) => rapture.uniqueId == uniqueId);
  }

  String? getEntityName(int uniqueId) {
    for (final nikke in nonnullNikkes) {
      if (nikke.uniqueId == uniqueId) {
        return '${nikke.name} (P$uniqueId)';
      } else if (nikke.cover.uniqueId == uniqueId) {
        return '${nikke.name}\'s Cover';
      }
    }

    return raptures.firstWhereOrNull((rapture) => rapture.uniqueId == uniqueId)?.name;
  }

  BattleEntity? getEntityById(int uniqueId) {
    for (final nikke in nonnullNikkes) {
      if (nikke.uniqueId == uniqueId) {
        return nikke;
      } else if (nikke.cover.uniqueId == uniqueId) {
        return nikke.cover;
      }
    }

    return raptures.firstWhereOrNull((rapture) => rapture.uniqueId == uniqueId);
  }

  Map<int, int> getDamageMap() {
    final Map<int, int> totalDamage = {};
    for (final events in timeline.values) {
      for (final event in events) {
        if (event is NikkeDamageEvent) {
          totalDamage.putIfAbsent(event.attackerUniqueId, () => 0);
          totalDamage[event.attackerUniqueId] =
              totalDamage[event.attackerUniqueId]! + event.damageParameter.calculateExpectedDamage();
        }
      }
    }
    return totalDamage;
  }

  void registerEvent(int frame, BattleEvent event) {
    if (frame <= 0) return;

    timeline.putIfAbsent(frame, () => <BattleEvent>[]);
    timeline[frame]!.add(event);
  }
}
