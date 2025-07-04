import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:nikke_einkk/model/battle/battle_entity.dart';
import 'package:nikke_einkk/model/battle/battle_event.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/user_data.dart';

class BattleSimulation {
  static const burstMeterCap = 1000000; // 9000 = 0.9%

  final bool useGlobal;
  NikkeDatabaseV2 get db => useGlobal ? global : cn;

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
  set burstMeter(int value) => _burstMeter = value.clamp(0, burstMeterCap);
  int burstStage = 0;
  int reEnterBurstCd = 0;
  int burstStageDuration = 0;

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
    burstStageDuration = 0;

    for (int index = 0; index < battleNikkes.length; index += 1) {
      battleNikkes[index]?.init(this, index + 1);
    }
    if (battleNikkes[currentNikke - 1] == null) {
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
  }

  void simulate() {
    if (nonnullNikkes.isEmpty) return;

    timeline.clear();
    burstMeter = 0;
    burstStage = 0;
    reEnterBurstCd = 0;
    burstStageDuration = 0;
    currentNikke = min(nonnullNikkes.length, currentNikke);
    for (int index = 0; index < nonnullNikkes.length; index += 1) {
      nonnullNikkes[index].init(this, index + 1);
    }
    for (int index = 0; index < raptures.length; index += 1) {
      raptures[index].init(this, index + 11);
    }

    currentFrame = maxFrames + 1;
    // BattleStart
    for (final nikke in nonnullNikkes) {
      nikke.broadcast(BattleStartEvent.battleStartEvent, this);
    }

    for (currentFrame = maxFrames; currentFrame > 0; currentFrame -= 1) {
      for (final entity in [...nonnullNikkes, ...raptures]) {
        entity.normalAction(this);
      }

      if (playerOptions.forceFillBurst && burstStage == 0) {
        registerEvent(currentFrame, ChangeBurstStepEvent(this, -1, 1, -1));
        burstStage = 1;
      }

      reEnterBurstCd = max(0, reEnterBurstCd - 1);
      burstStageDuration = max(0, burstStageDuration - 1);
      if (burstStage > 1 && burstStageDuration == 0) {
        if (burstStage == 4) {
          registerEvent(currentFrame, ExitFullBurstEvent.exitFullBurstEvent);
        }
        burstStage = 0;
      }

      // broadcast all events registered for this frame
      for (int index = 0; index < (timeline[currentFrame]?.length ?? 0); index += 1) {
        final event = timeline[currentFrame]![index];

        if (event is BurstGenerationEvent) {
          event.currentMeter = burstMeter;
          if (burstStage == 0) {
            burstMeter += event.burst;

            if (burstMeter == burstMeterCap) {
              registerEvent(currentFrame, ChangeBurstStepEvent(this, -1, 1, -1));
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
          burstStageDuration = BattleUtils.timeDataToFrame(event.duration, fps);
          burstStageDuration = max(0, burstStageDuration);
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
    }
  }

  BattleNikke? getNikkeOnPosition(int position) {
    return nonnullNikkes.firstWhereOrNull((nikke) => nikke.uniqueId == position);
  }

  BattleRapture? getRaptureByUniqueId(int uniqueId) {
    return raptures.firstWhereOrNull((rapture) => rapture.uniqueId == uniqueId);
  }

  BattleEntity? getEntityByUniqueId(int uniqueId) {
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
