import 'dart:math';

import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/equipment.dart';
import 'package:nikke_einkk/model/items.dart';
import 'package:nikke_einkk/model/rollsim/strategy.dart';

class PositionFirstStrategy extends RollStrategy {
  PositionFirstStrategy._();

  @override
  RollResult execute(NikkeDatabase db, List<EquipmentLineModel> equips, List<EquipLineExpectation> targets) {
    final random = Random();
    int stoneCount = 0;
    int rollCount = 0;

    // every equip should have
    final majorRequiredTypes = targets.where((expectation) => expectation.lineCount == 4);
    // some should have
    final minorRequiredTypes = targets.where((expectation) => expectation.lineCount > 0 && expectation.lineCount < 4);
    // none should have
    final unwantedTypes = targets.where((expectation) => expectation.lineCount == 0);

    final targetMap = {for (var target in targets) target.type: target};

    // 1: roll for position first on all equips
    // - first determine which equip should be rolled first, roll, then repeat?
    // equip line status: unwanted line / other / wanted line
    // so 3 x 3 x 3 = 27 combinations for each equip
    // New idea: assign score to each line based on wanted or not & position

    for (final equip in equips) {
      bool shouldRollForPosition(EquipLine line) {
        return !checkTarget(db, equips, targets) &&
            !checkEquipPosition(equip, targets) &&
            !isMustLock(line, targetMap, db) &&
            !targetMap.containsKey(line.type);
      }

      // roll for position 3 first
      bool shouldRollPos3 = shouldRollForPosition(equip.equipLine3);
      while (shouldRollPos3) {
        if (!equip.equipLine1.locked && isMustLock(equip.equipLine1, targetMap, db)) {
          stoneCount += equip.lock(1, false);
        }
        if (!equip.equipLine2.locked && isMustLock(equip.equipLine2, targetMap, db)) {
          stoneCount += equip.lock(2, false);
        }

        stoneCount += equip.roll(random);
        rollCount += 1;
        shouldRollPos3 = shouldRollForPosition(equip.equipLine3);
      }

      bool shouldRollPos2 = shouldRollForPosition(equip.equipLine2);
      while (shouldRollPos2) {
        if (!equip.equipLine1.locked && isMustLock(equip.equipLine1, targetMap, db)) {
          stoneCount += equip.lock(1, false);
        }

        if (!equip.equipLine3.locked) {
          stoneCount += equip.lock(3, false);
        }
        stoneCount += equip.roll(random);
        rollCount += 1;
        shouldRollPos2 = shouldRollForPosition(equip.equipLine2);
      }

      bool shouldRollPos1 = shouldRollForPosition(equip.equipLine1);
      while (shouldRollPos1) {
        if (!equip.equipLine2.locked) {
          stoneCount += equip.lock(2, false);
        }
        if (!equip.equipLine3.locked) {
          stoneCount += equip.lock(3, false);
        }
        stoneCount += equip.roll(random);
        rollCount += 1;
        shouldRollPos1 = shouldRollForPosition(equip.equipLine1);
      }
    }

    return RollResult([for (final equip in equips) ...equip.equipLines], rollCount, stoneCount);

    // 2: roll for value starting from the lowest value equip
  }

  static bool isMustLock(EquipLine line, Map<EquipLineType, EquipLineExpectation> targets, NikkeDatabase db) {
    // bug: this should still check all equips to see if the required line count is met
    final targetVal = targets[line.type]?.lockThreshold;
    if (targetVal == null) return false;
    final currentVal = line.getValue(db);
    return currentVal.abs() >= targetVal.abs();
  }

  static bool checkEquipPosition(EquipmentLineModel equip, List<EquipLineExpectation> targets) {
    final requiredLineTypes = targets.where((expectation) => expectation.lineCount == 4); // at most 3
    final desiredLineTypes = targets.where((expectation) => expectation.lineCount > 0 && expectation.lineCount < 4);
    final nonRequiredLineTypes = targets.where((expectation) => expectation.lineCount == 0);
    final requiredCount =
        equip.equipLines.where((line) => requiredLineTypes.any((expectation) => expectation.type == line.type)).length;
    // bug: this should still check all equips to see if the required line count is met
    final desiredCount =
        equip.equipLines.where((line) => desiredLineTypes.any((expectation) => expectation.type == line.type)).length;
    final nonRequiredCount =
        equip.equipLines
            .where((line) => nonRequiredLineTypes.any((expectation) => expectation.type == line.type))
            .length;
    return requiredCount >= requiredLineTypes.length && nonRequiredCount == 0;
  }

  static bool checkTarget(NikkeDatabase db, List<EquipmentLineModel> equips, List<EquipLineExpectation> targets) {
    final valueMap = <EquipLineType, int>{};
    final countMap = <EquipLineType, int>{};
    for (final equip in equips) {
      for (final line in equip.equipLines) {
        final lineVal = line.getValue(db);
        valueMap.update(line.type, (value) => value + lineVal, ifAbsent: () => lineVal);
        countMap.update(line.type, (value) => value + 1, ifAbsent: () => 1);
      }
    }

    for (final expectation in targets) {
      final count = countMap[expectation.type] ?? 0;
      if (count < expectation.lineCount || expectation.lineCount == 0) {
        return false;
      }

      final value = valueMap[expectation.type];
      final targetVal = expectation.minValue;
      if (targetVal != null && (value == null || value.abs() < targetVal.abs())) {
        return false;
      }
    }
    return true;
  }
}

class SingleEquipPositionFirstStrategy extends SingleEquipRollStrategy {
  static final instance = SingleEquipPositionFirstStrategy._();

  SingleEquipPositionFirstStrategy._();

  @override
  RollResult execute(NikkeDatabase db, EquipmentLineModel equip, List<EquipLineExpectation> targets) {
    final random = Random();
    int stoneCount = 0;
    int rollCount = 0;

    final targetMap = {for (var target in targets.where((t) => t.lineCount > 0)) target.type: target};

    bool shouldRollForPosition(EquipLine line) {
      return !checkTarget(db, equip, targets) &&
          !checkEquipPosition(equip, targets) &&
          !isMustLock(line, targetMap) &&
          !targetMap.containsKey(line.type);
    }

    // roll for position 3 first
    bool shouldRollPos3 = shouldRollForPosition(equip.equipLine3);
    while (shouldRollPos3) {
      if (!equip.equipLine1.locked && isMustLock(equip.equipLine1, targetMap)) {
        stoneCount += equip.lock(1, false);
      }
      if (!equip.equipLine2.locked && isMustLock(equip.equipLine2, targetMap)) {
        stoneCount += equip.lock(2, false);
      }

      stoneCount += equip.roll(random);
      rollCount += 1;
      shouldRollPos3 = shouldRollForPosition(equip.equipLine3);
    }

    bool shouldRollPos2 = shouldRollForPosition(equip.equipLine2);
    while (shouldRollPos2) {
      if (!equip.equipLine1.locked && isMustLock(equip.equipLine1, targetMap)) {
        stoneCount += equip.lock(1, false);
      }

      if (!equip.equipLine3.locked) {
        stoneCount += equip.lock(3, false);
      }
      stoneCount += equip.roll(random);
      rollCount += 1;
      shouldRollPos2 = shouldRollForPosition(equip.equipLine2);
    }

    bool shouldRollPos1 = shouldRollForPosition(equip.equipLine1);
    while (shouldRollPos1) {
      if (!equip.equipLine2.locked) {
        stoneCount += equip.lock(2, false);
      }
      if (!equip.equipLine3.locked) {
        stoneCount += equip.lock(3, false);
      }
      stoneCount += equip.roll(random);
      rollCount += 1;
      shouldRollPos1 = shouldRollForPosition(equip.equipLine1);
    }

    for (int slotNum = 1; slotNum <= 3; slotNum++) {
      final equipLine = equip.equipLines[slotNum - 1];
      if (equipLine.locked && !isMustLock(equipLine, targetMap)) {
        equip.unlock(slotNum);
      }
    }

    // 2: roll for value based on expectation order
    for (final expectation in targets) {
      final targetVal = expectation.minValue;
      if (expectation.lineCount == 0 || targetVal == null) continue;

      bool shouldRollForValue() {
        final currentVal = equip.equipLines.firstWhere((line) => line.type == expectation.type).getValue(db);
        return currentVal.abs() < targetVal.abs();
      }

      bool shouldRoll = shouldRollForValue();

      while (shouldRoll) {
        for (int slotNum = 1; slotNum <= 3; slotNum++) {
          final equipLine = equip.equipLines[slotNum - 1];
          if (!equipLine.locked && isMustLock(equipLine, targetMap)) {
            stoneCount += equip.lock(slotNum, false);
          }
        }

        stoneCount += equip.rollLevel(random);
        rollCount += 1;
        shouldRoll = shouldRollForValue();
      }
    }

    return RollResult([...equip.equipLines], rollCount, stoneCount);
  }

  static bool isMustLock(EquipLine line, Map<EquipLineType, EquipLineExpectation> targets) {
    final targetLv = targets[line.type]?.lockThreshold;
    if (targetLv == null) return false;
    return line.level >= targetLv;
  }

  static bool checkEquipPosition(EquipmentLineModel equip, List<EquipLineExpectation> targets) {
    final requiredLineTypes = targets.where((expectation) => expectation.lineCount > 0);
    final nonRequiredLineTypes = targets.where((expectation) => expectation.lineCount == 0);
    final requiredCount =
        equip.equipLines.where((line) => requiredLineTypes.any((expectation) => expectation.type == line.type)).length;
    final nonRequiredCount =
        equip.equipLines
            .where((line) => nonRequiredLineTypes.any((expectation) => expectation.type == line.type))
            .length;
    return requiredCount >= requiredLineTypes.length && nonRequiredCount == 0;
  }

  static bool checkTarget(NikkeDatabase db, EquipmentLineModel equip, List<EquipLineExpectation> targets) {
    final valueMap = <EquipLineType, int>{};
    final countMap = <EquipLineType, int>{};
    for (final line in equip.equipLines) {
      if (line.type == EquipLineType.none) {
        continue;
      }
      final lineVal = line.getValue(db);
      valueMap.update(line.type, (value) => value + lineVal, ifAbsent: () => lineVal);
      countMap.update(line.type, (value) => value + 1, ifAbsent: () => 1);
    }

    for (final expectation in targets) {
      final count = countMap[expectation.type] ?? 0;
      if (count < expectation.lineCount || expectation.lineCount == 0) {
        return false;
      }

      final value = valueMap[expectation.type];
      final targetVal = expectation.minValue;
      if (targetVal != null && (value == null || value.abs() < targetVal.abs())) {
        return false;
      }
    }
    return true;
  }
}
