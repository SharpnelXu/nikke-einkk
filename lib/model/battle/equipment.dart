import 'package:collection/collection.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/function.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';

class BattleEquipment {
  // equipment stat formula: baseStat * (100% + 10% * (level (0~5) + sameCorpFactor (3)))
  // t10 does not have corp label
  final EquipType type;
  final NikkeClass equipClass;
  final EquipRarity rarity;
  EquipmentItemData get equipData => gameData.groupedEquipTable[type]![equipClass]![rarity]!;
  Corporation _corporation = Corporation.none;
  Corporation get corporation => _corporation;
  set corporation(Corporation newCorp) {
    if (rarity.canHaveCorp) corporation = newCorp;
  }

  int _level = 0;
  int get level => _level;
  set level(int newLevel) {
    validateLevel(newLevel);

    _level = newLevel;
  }

  List<EquipLine> equipLines = [];

  BattleEquipment({
    required this.type,
    required this.equipClass,
    required this.rarity,
    Corporation corporation = Corporation.none,
    int level = 0,
    List<EquipLine> equipLines = const [],
  }) : _level = level,
       _corporation = corporation {
    if (equipLines.length > 3) {
      throw ArgumentError('Too many lines: ${equipLines.length}');
    }

    this.equipLines.addAll(equipLines);
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

  void applyEquipLines(BattleSimulation simulation, BattleNikke owner) {
    if (rarity != EquipRarity.t10) return;

    for (final equipLine in equipLines) {
      if (equipLine.type == EquipLineType.none) continue;

      final stateEffectData = gameData.stateEffectTable[equipLine.getStateEffectId()]!;
      owner.functions.addAll(
        stateEffectData.functions
            .where((data) => data.function != 0)
            .map((data) => BattleFunction(gameData.functionTable[data.function]!)),
      );
    }
  }
}
