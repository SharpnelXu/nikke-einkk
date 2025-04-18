import 'package:collection/collection.dart';
import 'package:nikke_einkk/model/common.dart';

class BattleEquipmentData {
  // equipment stat formula: baseStat * (100% + 10% * (level (0~5) + sameCorpFactor (3)))
  // t10 does not have corp label
  EquipmentItemData equipData;
  Corporation corporation;
  int level;
  // List<EquipLine> equipLines;

  BattleEquipmentData({required this.equipData, this.corporation = Corporation.none, this.level = 0});

  int getStat(StatType statType, Corporation ownerCorp) {
    final equipStat = equipData.stat.firstWhereOrNull((stat) => stat.statType == statType);
    if (equipStat == null) return 0;

    final sameCorpFactor = ownerCorp == corporation ? 3 : 0;
    return equipStat.statValue * (10 + level + sameCorpFactor) ~/ 10;
  }
}
