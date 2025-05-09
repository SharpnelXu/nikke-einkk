import 'package:collection/collection.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/items.dart';

class BattleEquipment {
  // equipment stat formula: baseStat * (100% + 10% * (level (0~5) + sameCorpFactor (3)))
  // t10 does not have corp label
  EquipmentItemData equipData;
  Corporation _corporation;
  Corporation get corporation => _corporation;
  set corporation(Corporation newCorp) {
    if (rarity.canHaveCorp) corporation = newCorp;
  }

  int _level;
  int get level => _level;
  set level(int newLevel) {
    validateLevel(newLevel);

    _level = newLevel;
  }

  // List<EquipLine> equipLines;

  EquipRarity get rarity => equipData.itemRarity;

  BattleEquipment({required this.equipData, Corporation corporation = Corporation.none, int level = 0})
    : _level = level,
      _corporation = corporation {
    validateLevel(level);
    if (!rarity.canHaveCorp) _corporation = Corporation.none;
  }

  void validateLevel(int newLevel) {
    if (newLevel < 0 || newLevel > rarity.maxLevel) {
      throw ArgumentError('New Level: $newLevel, max level: ${rarity.maxLevel}');
    }
  }

  num getStat(StatType statType, Corporation ownerCorp) {
    final equipStat = equipData.stat.firstWhereOrNull((stat) => stat.statType == statType);
    if (equipStat == null) return 0;

    final sameCorpFactor = rarity.canHaveCorp && corporation != Corporation.none && ownerCorp == corporation ? 3 : 0;
    return equipStat.statValue * (1 + (level + sameCorpFactor) * 0.1);
  }
}
