import 'package:flutter_test/flutter_test.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/equipment.dart';
import 'package:nikke_einkk/model/items.dart';
import 'package:nikke_einkk/model/rollsim/position_first_strategy.dart';
import 'package:nikke_einkk/model/rollsim/strategy.dart';

import '../../test_helper.dart';

void main() {
  TestHelper.loadData();

  group('Single Equip Utility method tests', () {
    test('isMustLock', () {
      final targets = [
        EquipLineExpectation(type: EquipLineType.statAtk, lineCount: 1, minValue: 4000, lockThreshold: 15),
        EquipLineExpectation(type: EquipLineType.statChargeTime, lineCount: 1, minValue: -1000, lockThreshold: 15),
      ];
      final targetMap = {for (var target in targets) target.type: target};

      expect(SingleEquipPositionFirstStrategy.isMustLock(EquipLine(EquipLineType.statAtk, 15), targetMap), true);
      expect(SingleEquipPositionFirstStrategy.isMustLock(EquipLine(EquipLineType.statAtk, 14), targetMap), false);
      expect(SingleEquipPositionFirstStrategy.isMustLock(EquipLine(EquipLineType.statDef, 15), targetMap), false);
      expect(SingleEquipPositionFirstStrategy.isMustLock(EquipLine(EquipLineType.statChargeTime, 15), targetMap), true);
      expect(
        SingleEquipPositionFirstStrategy.isMustLock(EquipLine(EquipLineType.statChargeTime, 14), targetMap),
        false,
      );
    });

    group('checkEquipPosition', () {
      test('3 type requirements', () {
        final targets = [
          EquipLineExpectation(type: EquipLineType.statAtk, lineCount: 1, minValue: null, lockThreshold: null),
          EquipLineExpectation(
            type: EquipLineType.increaseElementalDamage,
            lineCount: 1,
            minValue: null,
            lockThreshold: null,
          ),
          EquipLineExpectation(type: EquipLineType.statChargeTime, lineCount: 1, minValue: null, lockThreshold: null),
        ];

        final equip1 = EquipmentLineModel.from([
          EquipLine(EquipLineType.statAtk, 15),
          EquipLine(EquipLineType.statDef, 10),
          EquipLine(EquipLineType.statChargeTime, 12),
        ]);
        expect(SingleEquipPositionFirstStrategy.checkEquipPosition(equip1, targets), false);

        final equip2 = EquipmentLineModel.from([
          EquipLine(EquipLineType.increaseElementalDamage, 15),
          EquipLine(EquipLineType.statAtk, 10),
          EquipLine(EquipLineType.statChargeTime, 12),
        ]);
        expect(SingleEquipPositionFirstStrategy.checkEquipPosition(equip2, targets), true);
      });

      test('2 type requirements', () {
        final targets = [
          EquipLineExpectation(type: EquipLineType.statAtk, lineCount: 1, minValue: null, lockThreshold: null),
          EquipLineExpectation(
            type: EquipLineType.increaseElementalDamage,
            lineCount: 1,
            minValue: null,
            lockThreshold: null,
          ),
        ];

        final equip1 = EquipmentLineModel.from([
          EquipLine(EquipLineType.statAtk, 15),
          EquipLine(EquipLineType.statDef, 10),
          EquipLine(EquipLineType.increaseElementalDamage, 12),
        ]);
        expect(SingleEquipPositionFirstStrategy.checkEquipPosition(equip1, targets), true);

        final equip2 = EquipmentLineModel.from([
          EquipLine(EquipLineType.increaseElementalDamage, 15),
          EquipLine(EquipLineType.statAtk, 10),
          EquipLine(EquipLineType.statChargeTime, 12),
        ]);
        expect(SingleEquipPositionFirstStrategy.checkEquipPosition(equip2, targets), true);

        final equip3 = EquipmentLineModel.from([
          EquipLine(EquipLineType.increaseElementalDamage, 15),
          EquipLine.none(),
          EquipLine(EquipLineType.statAtk, 12),
        ]);
        expect(SingleEquipPositionFirstStrategy.checkEquipPosition(equip3, targets), true);

        final equip4 = EquipmentLineModel.from([
          EquipLine(EquipLineType.increaseElementalDamage, 15),
          EquipLine.none(),
          EquipLine(EquipLineType.statDef, 12),
        ]);
        expect(SingleEquipPositionFirstStrategy.checkEquipPosition(equip4, targets), false);
      });

      test('with 0 lineCount', () {
        final targets = [
          EquipLineExpectation(type: EquipLineType.statAtk, lineCount: 1, minValue: null, lockThreshold: null),
          EquipLineExpectation(
            type: EquipLineType.increaseElementalDamage,
            lineCount: 1,
            minValue: null,
            lockThreshold: null,
          ),
          EquipLineExpectation(type: EquipLineType.statAmmo, lineCount: 0, minValue: null, lockThreshold: null),
        ];

        final equip1 = EquipmentLineModel.from([
          EquipLine(EquipLineType.statAtk, 15),
          EquipLine(EquipLineType.statDef, 10),
          EquipLine(EquipLineType.increaseElementalDamage, 12),
        ]);
        expect(SingleEquipPositionFirstStrategy.checkEquipPosition(equip1, targets), true);

        final equip2 = EquipmentLineModel.from([
          EquipLine(EquipLineType.increaseElementalDamage, 15),
          EquipLine(EquipLineType.statAtk, 10),
          EquipLine(EquipLineType.statAmmo, 12),
        ]);
        expect(SingleEquipPositionFirstStrategy.checkEquipPosition(equip2, targets), false);
      });
    });

    group('checkTarget', () {
      test('2 type requirements - success', () {
        final targets = [
          EquipLineExpectation(type: EquipLineType.statAtk, lineCount: 1, minValue: 1000, lockThreshold: null),
          EquipLineExpectation(type: EquipLineType.statChargeTime, lineCount: 1, minValue: -609, lockThreshold: null),
        ];

        final equip = EquipmentLineModel.from([
          EquipLine(EquipLineType.statAtk, 10),
          EquipLine(EquipLineType.statDef, 10),
          EquipLine(EquipLineType.statChargeTime, 15),
        ]);

        expect(SingleEquipPositionFirstStrategy.checkTarget(global, equip, targets), true);
      });

      test('2 type requirements - value failure', () {
        final targets = [
          EquipLineExpectation(type: EquipLineType.statAtk, lineCount: 1, minValue: 1000, lockThreshold: null),
          EquipLineExpectation(type: EquipLineType.statChargeTime, lineCount: 1, minValue: -609, lockThreshold: null),
        ];

        final equip = EquipmentLineModel.from([
          EquipLine(EquipLineType.statAtk, 10),
          EquipLine(EquipLineType.statDef, 10),
          EquipLine(EquipLineType.statChargeTime, 14),
        ]);

        expect(SingleEquipPositionFirstStrategy.checkTarget(global, equip, targets), false);
      });

      test('2 type requirements - count failure', () {
        final targets = [
          EquipLineExpectation(type: EquipLineType.statAtk, lineCount: 0, minValue: null, lockThreshold: null),
          EquipLineExpectation(type: EquipLineType.statChargeTime, lineCount: 1, minValue: -609, lockThreshold: null),
        ];

        final equip1 = EquipmentLineModel.from([
          EquipLine(EquipLineType.statAtk, 10),
          EquipLine(EquipLineType.statDef, 10),
          EquipLine(EquipLineType.statChargeTime, 15),
        ]);
        expect(SingleEquipPositionFirstStrategy.checkTarget(global, equip1, targets), false);

        final equip2 = EquipmentLineModel.from([
          EquipLine(EquipLineType.statAmmo, 10),
          EquipLine(EquipLineType.statDef, 10),
          EquipLine(EquipLineType.statChargeTime, 15),
        ]);
        expect(SingleEquipPositionFirstStrategy.checkTarget(global, equip2, targets), false);
      });
    });
  });
}
