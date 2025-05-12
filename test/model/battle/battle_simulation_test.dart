import 'package:flutter_test/flutter_test.dart';
import 'package:nikke_einkk/model/battle/battle_event.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/equipment.dart';
import 'package:nikke_einkk/model/battle/favorite_item.dart';
import 'package:nikke_einkk/model/battle/harmony_cube.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';

import '../../test_helper.dart';

void main() async {
  await TestHelper.loadData();

  group('Nikke Simulation Test', () {
    final BattlePlayerOptions playerOptions = BattlePlayerOptions(
      personalRecycleLevel: 420,
      corpRecycleLevels: {
        Corporation.pilgrim: 405,
        Corporation.missilis: 196,
        Corporation.abnormal: 155,
        Corporation.tetra: 224,
        Corporation.elysion: 197,
      },
      classRecycleLevels: {NikkeClass.attacker: 210, NikkeClass.supporter: 193, NikkeClass.defender: 184},
    );
    final BattleNikkeOptions scarletOption = BattleNikkeOptions(
      nikkeResourceId: 222,
      coreLevel: 11,
      syncLevel: 883,
      attractLevel: 40,
      skillLevels: [10, 10, 10],
      equips: [
        BattleEquipment(
          type: EquipType.head,
          equipClass: NikkeClass.attacker,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.statAmmo, 9), EquipLine(EquipLineType.increaseElementalDamage, 9)],
        ),
        BattleEquipment(
          type: EquipType.body,
          equipClass: NikkeClass.attacker,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [
            EquipLine(EquipLineType.statChargeTime, 2),
            EquipLine(EquipLineType.statAmmo, 5),
            EquipLine(EquipLineType.statDef, 9),
          ],
        ),
        BattleEquipment(
          type: EquipType.arm,
          equipClass: NikkeClass.attacker,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.statAtk, 10), EquipLine(EquipLineType.statAmmo, 3)],
        ),
        BattleEquipment(
          type: EquipType.leg,
          equipClass: NikkeClass.attacker,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [
            EquipLine(EquipLineType.statChargeDamage, 1),
            EquipLine(EquipLineType.statAtk, 14),
            EquipLine(EquipLineType.statAmmo, 5),
          ],
        ),
      ],
      favoriteItem: BattleFavoriteItem(gameData.getDollId(WeaponType.ar, Rarity.sr)!, 5),
      cube: null,
    );

    test('Scarlet resourceId 222', () {
      final simulation = BattleSimulation(
        playerOptions: playerOptions,
        nikkeOptions: [scarletOption.copy()..cube = BattleHarmonyCube(HarmonyCubeType.reload.cubeId, 15)],
      );

      final rapture =
          BattleRapture()
            ..uniqueId = 11
            ..distance = 30
            ..element = NikkeElement.water
            ..defence = 100;

      simulation.raptures.add(rapture);
      simulation.maxSeconds = 15;
      simulation.simulate();

      final scarlet = simulation.nikkes.first;
      expect(scarlet.baseAttack, moreOrLessEquals(903997, epsilon: 1));
      expect(scarlet.baseDefence, moreOrLessEquals(138135, epsilon: 1));
      expect(scarlet.getMaxAmmo(simulation), 57);
      expect(scarlet.getMaxHp(simulation), moreOrLessEquals(20546189, epsilon: 1));

      expect(simulation.timeline[888]!.length, 3); // first bullet (fire, damage, burstGen)
      final damageEvent1Scarlet1 = simulation.timeline[888]![1] as NikkeDamageEvent;
      expect(damageEvent1Scarlet1.damageParameter.calculateDamage(), moreOrLessEquals(596207, epsilon: 1));
      final burstGenEvent1Scarlet1 = simulation.timeline[888]![2] as BurstGenerationEvent;
      expect(burstGenEvent1Scarlet1.burst, 9000);

      expect(simulation.timeline[883]!.length, 3); // second bullet

      expect(simulation.timeline[838]!.length, 3); // 11 th
      final damageEvent11Scarlet1 = simulation.timeline[838]![1] as NikkeDamageEvent;
      expect(damageEvent11Scarlet1.damageParameter.calculateDamage(), moreOrLessEquals(706599, epsilon: 1));

      final damageEvent51Scarlet1 = simulation.timeline[638]![1] as NikkeDamageEvent; // 51 st
      expect(damageEvent51Scarlet1.damageParameter.calculateDamage(), moreOrLessEquals(1148169, epsilon: 1));

      expect(simulation.timeline[607]!.length, 1); // reload
      final reloadEvent = simulation.timeline[607]![0] as NikkeReloadStartEvent;
      expect(reloadEvent.reloadFrames, 109);
    });

    test('4 Scarlets with different cubes resourceId 222', () {
      final simulation = BattleSimulation(
        playerOptions: playerOptions,
        nikkeOptions: [
          scarletOption.copy()..cube = BattleHarmonyCube(HarmonyCubeType.reload.cubeId, 15),
          scarletOption.copy()..cube = BattleHarmonyCube(HarmonyCubeType.gainAmmo.cubeId, 15),
          scarletOption.copy()..cube = BattleHarmonyCube(HarmonyCubeType.ammoCapacity.cubeId, 7),
          scarletOption.copy()..cube = BattleHarmonyCube(HarmonyCubeType.burst.cubeId, 7),
        ],
      );

      final rapture =
          BattleRapture()
            ..uniqueId = 11
            ..distance = 30
            ..element = NikkeElement.water
            ..defence = 100;

      simulation.raptures.add(rapture);
      simulation.maxSeconds = 15;
      simulation.simulate();

      final scarlet1 = simulation.nikkes.first;
      expect(scarlet1.baseAttack, moreOrLessEquals(903997, epsilon: 1));
      expect(scarlet1.baseDefence, moreOrLessEquals(138135, epsilon: 1));
      expect(scarlet1.getMaxAmmo(simulation), 57);
      expect(scarlet1.getMaxHp(simulation), moreOrLessEquals(20546189, epsilon: 1));

      final scarlet3 = simulation.nikkes[2];
      expect(scarlet3.baseAttack, moreOrLessEquals(902127, epsilon: 1));
      expect(scarlet3.baseDefence, moreOrLessEquals(137763, epsilon: 1));
      expect(scarlet3.getMaxAmmo(simulation), 63);
      expect(scarlet3.getMaxHp(simulation), moreOrLessEquals(20490089, epsilon: 1));

      expect(simulation.timeline[888]!.length, 12); // first bullet (fire, damage, burstGen)
      final damageEvent1Scarlet2 = simulation.timeline[888]![4] as NikkeDamageEvent;
      expect(damageEvent1Scarlet2.damageParameter.calculateDamage(), moreOrLessEquals(596207, epsilon: 1));
      final burstGenEvent1Scarlet2 = simulation.timeline[888]![5] as BurstGenerationEvent;
      expect(burstGenEvent1Scarlet2.burst, 9000);

      final damageEvent1Scarlet4 = simulation.timeline[888]![10] as NikkeDamageEvent;
      expect(damageEvent1Scarlet4.damageParameter.calculateDamage(), moreOrLessEquals(552844, epsilon: 1));
      final burstGenEvent1Scarlet4 = simulation.timeline[888]![11] as BurstGenerationEvent;
      expect(burstGenEvent1Scarlet4.burst, 9419);

      expect(simulation.timeline[883]!.length, 12); // second bullet

      expect(simulation.timeline[838]!.length, 12); // 11 th
      final damageEvent11Scarlet2 = simulation.timeline[838]![4] as NikkeDamageEvent;
      expect(damageEvent11Scarlet2.damageParameter.calculateDamage(), moreOrLessEquals(706599, epsilon: 1));

      final damageEvent51Scarlet2 = simulation.timeline[638]![4] as NikkeDamageEvent; // 51 st
      expect(damageEvent51Scarlet2.damageParameter.calculateDamage(), moreOrLessEquals(1148169, epsilon: 1));

      expect(simulation.timeline[607]!.length, 2); // 1 & 4 reload
      final reloadEventScarlet1 = simulation.timeline[607]![0] as NikkeReloadStartEvent;
      expect(reloadEventScarlet1.reloadFrames, 109);
      final reloadEventScarlet4 = simulation.timeline[607]![1] as NikkeReloadStartEvent;
      expect(reloadEventScarlet4.reloadFrames, 150);

      expect(simulation.timeline[577]!.length, 1); // 3 reload
      final reloadEventScarlet3 = simulation.timeline[577]![0] as NikkeReloadStartEvent;
      expect(reloadEventScarlet3.reloadFrames, 150);

      expect(simulation.timeline[502]!.length, 1); // 2 reload
      final reloadEventScarlet2 = simulation.timeline[502]![0] as NikkeReloadStartEvent;
      expect(reloadEventScarlet2.reloadFrames, 150);
    });
  });
}
