import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nikke_einkk/model/battle/battle_entity.dart';
import 'package:nikke_einkk/model/battle/battle_event.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';

part '../../generated/model/battle/battle_simulator.g.dart';

@JsonSerializable()
class BattlePlayerOptions {
  int personalRecycleLevel;
  Map<Corporation, int> corpRecycleLevels = {};
  Map<NikkeClass, int> classRecycleLevels = {};
  bool forceFillBurst = false;

  BattlePlayerOptions({
    this.personalRecycleLevel = 0,
    Map<Corporation, int> corpRecycleLevels = const {},
    Map<NikkeClass, int> classRecycleLevels = const {},
    this.forceFillBurst = false,
  }) {
    this.corpRecycleLevels.addAll(corpRecycleLevels);
    this.classRecycleLevels.addAll(classRecycleLevels);
  }

  BattlePlayerOptions copy() {
    return BattlePlayerOptions(
      personalRecycleLevel: personalRecycleLevel,
      corpRecycleLevels: corpRecycleLevels,
      classRecycleLevels: classRecycleLevels,
      forceFillBurst: forceFillBurst,
    );
  }

  factory BattlePlayerOptions.fromJson(Map<String, dynamic> json) => _$BattlePlayerOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$BattlePlayerOptionsToJson(this);

  int getRecycleHp(NikkeClass nikkeClass) {
    return personalRecycleLevel * RecycleStat.personal.hp +
        RecycleStat.nikkeClass.hp * (classRecycleLevels[nikkeClass] ?? 0);
  }

  int getRecycleAttack(Corporation corporation) {
    return RecycleStat.corporation.atk * (corpRecycleLevels[corporation] ?? 0);
  }

  int getRecycleDefence(NikkeClass nikkeClass, Corporation corporation) {
    return RecycleStat.nikkeClass.def * (classRecycleLevels[nikkeClass] ?? 0) +
        RecycleStat.corporation.def * (corpRecycleLevels[corporation] ?? 0);
  }
}

class BattleSimulation {
  static const burstMeterCap = 1000000; // 9000 = 0.9%

  BattlePlayerOptions playerOptions;

  List<BattleNikke> nikkes = [];
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
    required List<BattleNikkeOptions?> nikkeOptions,
    required List<BattleRaptureOptions> raptureOptions,
  }) {
    nikkes.addAll(nikkeOptions.nonNulls.map((option) => BattleNikke(playerOptions: playerOptions, option: option)));
    raptures.addAll(raptureOptions.map((option) => BattleRapture(option)));
  }

  void simulate() {
    if (nikkes.isEmpty) return;

    timeline.clear();
    burstMeter = 0;
    burstStage = 0;
    reEnterBurstCd = 0;
    burstStageDuration = 0;
    currentNikke = min(nikkes.length, currentNikke);
    for (int index = 0; index < nikkes.length; index += 1) {
      nikkes[index].init(this, index + 1);
    }
    for (int index = 0; index < raptures.length; index += 1) {
      raptures[index].init(this, index + 11);
    }

    currentFrame = maxFrames + 1;
    // BattleStart
    for (final nikke in nikkes) {
      nikke.broadcast(BattleStartEvent.battleStartEvent, this);
    }

    for (currentFrame = maxFrames; currentFrame > 0; currentFrame -= 1) {
      for (final entity in [...nikkes, ...raptures]) {
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

        for (final nikke in nikkes) {
          nikke.broadcast(event, this);
        }

        for (final rapture in raptures) {
          rapture.broadcast(event, this);
        }
      }

      for (final entity in [...nikkes, ...raptures]) {
        entity.endCurrentFrame(this);
      }
    }
  }

  BattleNikke? getNikkeOnPosition(int position) {
    return nikkes.firstWhereOrNull((nikke) => nikke.uniqueId == position);
  }

  BattleRapture? getRaptureByUniqueId(int uniqueId) {
    return raptures.firstWhereOrNull((rapture) => rapture.uniqueId == uniqueId);
  }

  BattleEntity? getEntityByUniqueId(int uniqueId) {
    for (final nikke in nikkes) {
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
