import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:nikke_einkk/model/battle/battle_event.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/common.dart';

class BattlePlayerOptions {
  int personalRecycleLevel;
  Map<Corporation, int> corpRecycleLevels;
  Map<NikkeClass, int> classRecycleLevels;
  // cube levels

  BattlePlayerOptions({
    this.personalRecycleLevel = 0,
    this.corpRecycleLevels = const {},
    this.classRecycleLevels = const {},
  });

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
  BattlePlayerOptions playerOptions;

  List<BattleNikke> nikkes = [];
  List<BattleRapture> raptures = [];
  // timeline
  SplayTreeMap<int, List<BattleEvent>> timeline = SplayTreeMap((a, b) => b.compareTo(a));
  late int currentFrame;

  // maybe configurable in the future or put into a global option class
  int fps = 60;
  int maxSeconds = 180;
  int get maxFrames => fps * maxSeconds;

  // player actions, maybe move to a dedicated object to represent current frame
  bool autoAttack = true;
  bool autoBurst = true;
  bool useCover = false;
  bool fullBurst = false;
  int currentNikke = 3;

  BattleSimulation({required this.playerOptions, required List<BattleNikkeOptions?> nikkeOptions}) {
    nikkes.addAll(nikkeOptions.nonNulls.map((option) => BattleNikke(simulation: this, option: option)));
  }

  void simulate() {
    if (nikkes.isEmpty) return;

    timeline.clear();
    currentNikke = min(nikkes.length, currentNikke);
    for (int index = 0; index < nikkes.length; index += 1) {
      nikkes[index].init(index + 1);
    }

    for (currentFrame = maxFrames; currentFrame > 0; currentFrame -= 1) {
      for (final nikke in nikkes) {
        nikke.normalAction();
      }

      // broadcast all events registered for this frame
      for (final event in timeline[currentFrame] ?? []) {
        for (final nikke in nikkes) {
          nikke.broadcast(event, this);
        }
      }
    }
  }

  BattleNikke? getNikkeOnPosition(int position) {
    return nikkes.firstWhereOrNull((nikke) => nikke.position == position);
  }

  Map<int, int> getDamageMap() {
    final Map<int, int> totalDamage = {};
    for (final events in timeline.values) {
      for (final event in events) {
        if (event is NikkeDamageEvent) {
          totalDamage.putIfAbsent(event.attackerPosition, () => 0);
          totalDamage[event.attackerPosition] =
              totalDamage[event.attackerPosition]! + event.damageParameter.calculateExpectedDamage();
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
