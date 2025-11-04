import 'dart:math';
import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/function.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';
import 'package:nikke_einkk/model/skills.dart';

part '../generated/model/equipment.g.dart';

@JsonSerializable()
class EquipmentOption {
  // equipment stat formula: baseStat * (100% + 10% * (level (0~5) + sameCorpFactor (3)))
  // t10 does not have corp label
  EquipType type;
  NikkeClass equipClass;
  EquipRarity rarity;

  Corporation corporation = Corporation.none;
  int level = 0;

  List<EquipLine> equipLines = [];

  EquipmentOption({
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

  factory EquipmentOption.fromJson(Map<String, dynamic> json) => _$EquipmentOptionFromJson(json);

  Map<String, dynamic> toJson() => _$EquipmentOptionToJson(this);

  int getEquipStat(StatType statType, NikkeDatabase db, [Corporation? ownerCorp]) {
    final equipData = db.groupedEquipTable[type]?[equipClass]?[rarity];
    final equipStat = equipData?.stat.firstWhereOrNull((stat) => stat.statType == statType);
    if (equipStat == null) return 0;

    final sameCorp = rarity.canHaveCorp && corporation != Corporation.none && ownerCorp == corporation;
    final levelStat = (level * 0.1 * equipStat.statValue).roundHalfToEven();
    final corpStat = (sameCorp ? 0.3 * equipStat.statValue : 0).roundHalfToEven();

    final result = equipStat.statValue + levelStat + corpStat;

    return result;
  }

  num getLevelStat(StatType statType, NikkeDatabase db) {
    final equipData = db.groupedEquipTable[type]?[equipClass]?[rarity];
    final equipStat = equipData?.stat.firstWhereOrNull((stat) => stat.statType == statType);
    if (equipStat == null) return 0;

    return level * 0.1 * equipStat.statValue;
  }

  void applyEquipLines(BattleSimulation simulation, BattleNikke wearer) {
    if (rarity != EquipRarity.t10) return;

    for (final equipLine in equipLines) {
      if (equipLine.type == EquipLineType.none) continue;

      final stateEffectData = simulation.db.stateEffectTable[equipLine.getStateEffectId()];
      if (stateEffectData == null) {
        logger.w('Invalid Equip Line: ${equipLine.getStateEffectId()}');
      } else {
        for (final funcId in stateEffectData.allValidFuncIds) {
          final func = simulation.db.functionTable[funcId];
          if (func == null) {
            logger.w('Invalid Equip Line Func: $funcId');
          } else {
            wearer.functions.add(BattleFunction(func, wearer.uniqueId, Source.equip));
          }
        }
      }
    }
  }

  EquipmentOption copy() {
    return EquipmentOption(
      type: type,
      equipClass: equipClass,
      rarity: rarity,
      corporation: corporation,
      level: level,
      equipLines: equipLines.map((equipLine) => equipLine.copy()).toList(),
    );
  }
}

class EquipmentLineModel {
  // Constants from Data class for EquipmentLineModel
  static const int slotTwoRollPercentage = 50;
  static const int slotThreeRollPercentage = 30;

  EquipLine equipLine1 = EquipLine.none();
  EquipLine equipLine2 = EquipLine.none();
  EquipLine equipLine3 = EquipLine.none();
  List<EquipLine> get equipLines => [equipLine1, equipLine2, equipLine3];

  EquipmentLineModel(this.equipLine1, this.equipLine2, this.equipLine3);

  /// Constructor that generates random equip lines
  EquipmentLineModel.random(Random random) {
    equipLine1 = EquipLine(EquipLineType.statAtk, 11);

    if (random.nextInt(100) < slotTwoRollPercentage) {
      equipLine2 = EquipLine(EquipLineType.statDef, 11);
    } else {
      equipLine2 = EquipLine.none();
    }

    if (random.nextInt(100) < slotThreeRollPercentage) {
      equipLine3 = EquipLine(EquipLineType.statCritical, 11);
    } else {
      equipLine3 = EquipLine.none();
    }
  }

  /// Constructor from a list of equip lines
  EquipmentLineModel.from(List<EquipLine> lines) {
    if (lines.length != 3) {
      throw ArgumentError('Exactly 3 lines needed');
    }

    equipLine1 = lines[0].copy();
    equipLine2 = lines[1].copy();
    equipLine3 = lines[2].copy();
  }

  /// Validates that there are no duplicate line types
  void check() {
    final Set<EquipLineType> types = {};

    if (equipLine1.type != EquipLineType.none) {
      types.add(equipLine1.type);
    }

    if (equipLine2.type != EquipLineType.none) {
      if (types.contains(equipLine2.type)) {
        throw StateError('Duplicated line');
      }
      types.add(equipLine2.type);
    }

    if (equipLine3.type != EquipLineType.none) {
      if (types.contains(equipLine3.type)) {
        throw StateError('Duplicated line');
      }
      types.add(equipLine3.type);
    }
  }

  /// Rolls all unlocked equip lines and returns the number of slots that were not rolled
  int roll(Random random) {
    int rollCount = 0;

    // Roll line 1
    if (!equipLine1.locked) {
      equipLine1.roll(
        random,
        excludedTypes: [
          if (equipLine2.type != EquipLineType.none && equipLine2.locked) equipLine2.type,
          if (equipLine3.type != EquipLineType.none && equipLine3.locked) equipLine3.type,
        ],
      );
      rollCount += 1;
    }

    // Roll line 2
    if (!equipLine2.locked) {
      if (random.nextInt(100) < slotTwoRollPercentage) {
        equipLine2.roll(
          random,
          excludedTypes: [
            equipLine1.type,
            if (equipLine3.type != EquipLineType.none && equipLine3.locked) equipLine3.type,
          ],
        );
        rollCount += 1;
      } else {
        equipLine2.type = EquipLineType.none;
      }
    }

    if (!equipLine3.locked) {
      if (random.nextInt(100) < slotThreeRollPercentage) {
        equipLine3.roll(
          random,
          excludedTypes: [equipLine1.type, if (equipLine2.type != EquipLineType.none) equipLine2.type],
        );
        rollCount += 1;
      } else {
        equipLine3.type = EquipLineType.none;
      }
    }

    check();
    return rollCount == 0 ? 0 : 4 - rollCount;
  }

  /// Rolls the levels of all unlocked equip lines and returns the number of rocks used
  int rollLevel(Random random) {
    int rollCount = 0;

    for (final equipLine in equipLines) {
      if (equipLine.locked) {
        if (equipLine.lockStatus == LockStatus.lockedWithKey) {
          equipLine.lockStatus = LockStatus.notLocked;
        }
        continue;
      }

      rollCount += 1;
      if (equipLine.type != EquipLineType.none) {
        equipLine.rollLevel(random);
      }
    }

    return rollCount == 0 ? 0 : 4 - rollCount;
  }

  /// Locks a specific slot with optional key
  /// Returns number of rocks used
  int lock(int slotNum, bool withKey) {
    _checkSlotNum(slotNum);

    final equipLine = getSlot(slotNum);
    if (equipLine.locked || equipLine.type == EquipLineType.none) {
      throw ArgumentError('Slot cannot be locked. Type: ${equipLine.type}');
    }

    if (withKey) {
      equipLine.lockStatus = LockStatus.lockedWithKey;
    } else {
      equipLine.lockStatus = LockStatus.lockedWithRock;
    }

    final lockedCount = equipLines.where((line) => line.type != EquipLineType.none && line.locked).length;
    return lockedCount + 1;
  }

  /// Unlocks a specific slot
  void unlock(int slotNum) {
    _checkSlotNum(slotNum);

    final equipLine = getSlot(slotNum);
    if (equipLine.type == EquipLineType.none || !equipLine.locked) {
      throw ArgumentError('Slot cannot be unlocked. Type: ${equipLine.type}');
    }

    equipLine.lockStatus = LockStatus.notLocked;
  }

  /// Checks if the equipment has all the target types
  bool checkTypes(List<EquipLine> targets) {
    if (targets.isEmpty) {
      return true;
    }
    if (targets.length > 3) {
      throw ArgumentError('Too many targets');
    }

    for (final target in targets) {
      bool hasTarget = false;
      for (final equipLine in equipLines) {
        if (target.type == equipLine.type) {
          hasTarget = true;
          break;
        }
      }
      if (!hasTarget) {
        return false;
      }
    }
    return true;
  }

  /// Checks if the equipment meets all the target types and levels
  bool checkTargets(List<EquipLine> targets) {
    if (targets.isEmpty) {
      return true;
    }
    if (targets.length > 3) {
      throw ArgumentError('Too many targets');
    }

    for (final target in targets) {
      bool hasTarget = false;
      for (final equipLine in equipLines) {
        if (target.type == equipLine.type && target.level <= equipLine.level) {
          hasTarget = true;
          break;
        }
      }
      if (!hasTarget) {
        return false;
      }
    }
    return true;
  }

  /// Gets the equip line at the specified slot (1-3)
  EquipLine getSlot(int slotNum) {
    _checkSlotNum(slotNum);
    if (slotNum == 1) {
      return equipLine1;
    } else if (slotNum == 2) {
      return equipLine2;
    } else {
      return equipLine3;
    }
  }

  /// Validates that the slot number is between 1-3
  void _checkSlotNum(int slotNum) {
    if (slotNum <= 0 || slotNum > 3) {
      throw ArgumentError('SlotNum not acceptable: $slotNum');
    }
  }

  @override
  String toString() {
    return equipLines.toString();
  }
}
