import 'package:nikke_einkk/model/common.dart';

class BattlePlayerOptions {
  int personalRecycleLevel;
  Map<Corporation, int> corpRecycleLevels;
  Map<NikkeClass, int> classRecycleLevels;

  BattlePlayerOptions({
    this.personalRecycleLevel = 0,
    this.corpRecycleLevels = const {},
    this.classRecycleLevels = const {},
  });
}
