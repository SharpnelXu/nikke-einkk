import 'dart:collection';
import 'dart:math';

import 'package:nikke_einkk/model/battle/battle_event.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
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

class BattleSimulationData {
  BattlePlayerOptions playerOptions;

  List<BattleNikkeData> nikkes = [];
  // boss data, or rapture data?
  // timeline
  SplayTreeMap<int, BattleEvent> timeline = SplayTreeMap();

  // maybe configurable in the future or put into a global option class
  int fps = 60;
  int maxSeconds = 180;
  int get maxFrames => fps * maxSeconds;

  // player actions
  bool autoAttack = true;
  bool autoBurst = true;
  bool useCover = false;
  int currentNikke = 3;

  BattleSimulationData({required this.playerOptions, required List<BattleNikkeOptions?> nikkeOptions});

  void simulate() {
    if (nikkes.isEmpty) return;

    currentNikke = min(nikkes.length, currentNikke);
    for (int index = 0; index < nikkes.length; index += 1) {
      nikkes[index].position = index + 1;
    }

    for (int frame = maxFrames; frame >= 0; frame -= 1) {
      for (final nikke in nikkes) {
        if (!useCover) {
          nikke.attack(this);
        }
      }
    }
  }

  // for display
  int frameToMilliSecond(int frame) {
    return (frame * 1000 / fps).round();
  }
}
