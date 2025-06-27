import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/function.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';

part '../../generated/model/battle/equipment.g.dart';

@JsonSerializable()
class BattleEquipmentOption {
  // equipment stat formula: baseStat * (100% + 10% * (level (0~5) + sameCorpFactor (3)))
  // t10 does not have corp label
  EquipType type;
  NikkeClass equipClass;
  EquipRarity rarity;
  EquipmentData get equipData => dbLegacy.groupedEquipTable[type]![equipClass]![rarity]!;

  Corporation corporation = Corporation.none;
  int level = 0;

  List<EquipLine> equipLines = [];

  BattleEquipmentOption({
    required this.type,
    required this.equipClass,
    required this.rarity,
    this.corporation = Corporation.none,
    this.level = 0,
    List<EquipLine> equipLines = const [],
  }) {
    if (rarity == EquipRarity.t10) {
      if (equipLines.length > 3) {
        throw ArgumentError('Too many lines: ${equipLines.length}');
      }
      this.equipLines.addAll(equipLines.map((equipLine) => equipLine.copy()));
      while (this.equipLines.length < 3) {
        this.equipLines.add(EquipLine.none());
      }
    }
    level = level.clamp(0, rarity.maxLevel);
    if (!rarity.canHaveCorp) corporation = Corporation.none;
  }

  factory BattleEquipmentOption.fromJson(Map<String, dynamic> json) => _$BattleEquipmentOptionFromJson(json);

  Map<String, dynamic> toJson() => _$BattleEquipmentOptionToJson(this);

  int getStat(StatType statType, [Corporation? ownerCorp]) {
    final equipStat = equipData.stat.firstWhereOrNull((stat) => stat.statType == statType);
    if (equipStat == null) return 0;

    final sameCorp = rarity.canHaveCorp && corporation != Corporation.none && ownerCorp == corporation;
    final levelStat = (level * 0.1 * equipStat.statValue).roundHalfToEven();
    final corpStat = (sameCorp ? 0.3 * equipStat.statValue : 0).roundHalfToEven();

    final result = equipStat.statValue + levelStat + corpStat;

    return result;
  }

  num getLevelStat(StatType statType) {
    final equipStat = equipData.stat.firstWhereOrNull((stat) => stat.statType == statType);
    if (equipStat == null) return 0;

    return level * 0.1 * equipStat.statValue;
  }

  void applyEquipLines(BattleSimulation simulation, BattleNikke wearer) {
    if (rarity != EquipRarity.t10) return;

    for (final equipLine in equipLines) {
      if (equipLine.type == EquipLineType.none) continue;

      final stateEffectData = dbLegacy.stateEffectTable[equipLine.getStateEffectId()]!;
      wearer.functions.addAll(
        stateEffectData.functions
            .where((data) => data.function != 0)
            .map((data) => BattleFunction(dbLegacy.functionTable[data.function]!, wearer.uniqueId)),
      );
    }
  }

  BattleEquipmentOption copy() {
    return BattleEquipmentOption(
      type: type,
      equipClass: equipClass,
      rarity: rarity,
      corporation: corporation,
      level: level,
      equipLines: equipLines.map((equipLine) => equipLine.copy()).toList(),
    );
  }
}
