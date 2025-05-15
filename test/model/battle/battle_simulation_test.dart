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
      classRecycleLevels: {NikkeClass.attacker: 211, NikkeClass.supporter: 193, NikkeClass.defender: 184},
    );
    final BattleNikkeOptions scarletOption = BattleNikkeOptions(
      nikkeResourceId: 222,
      coreLevel: 11,
      syncLevel: 884,
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
            ..defence = 140;

      simulation.raptures.add(rapture);
      simulation.maxSeconds = 15;
      simulation.simulate();

      final scarlet = simulation.nikkes.first;
      expect(scarlet.baseAttack, 904831);
      expect(scarlet.baseDefence, 138266);
      expect(scarlet.getMaxAmmo(simulation), 57);
      expect(scarlet.getMaxHp(simulation), 20565804);

      expect(simulation.timeline[888]!.length, 3); // first bullet (fire, damage, burstGen)
      final damageEvent1Scarlet1 = simulation.timeline[888]![1] as NikkeDamageEvent;
      expect(damageEvent1Scarlet1.damageParameter.calculateDamage(), 596736);
      expect(damageEvent1Scarlet1.damageParameter.calculateDamage(critical: true), 826250);
      final burstGenEvent1Scarlet1 = simulation.timeline[888]![2] as BurstGenerationEvent;
      expect(burstGenEvent1Scarlet1.burst, 9000);

      expect(simulation.timeline[883]!.length, 3); // second bullet

      expect(simulation.timeline[838]!.length, 3); // 11 th
      final damageEvent11Scarlet1 = simulation.timeline[838]![1] as NikkeDamageEvent;
      expect(damageEvent11Scarlet1.damageParameter.calculateDamage(), 707230);
      expect(damageEvent11Scarlet1.damageParameter.calculateDamage(critical: true), 979242);

      expect(simulation.timeline[788]!.length, 3); // 21 th
      final damageEvent21Scarlet1 = simulation.timeline[788]![1] as NikkeDamageEvent;
      expect(damageEvent21Scarlet1.damageParameter.calculateDamage(), 817724);
      expect(damageEvent21Scarlet1.damageParameter.calculateDamage(critical: true), 1132234);

      expect(simulation.timeline[738]!.length, 3); // 31 th
      final damageEvent31Scarlet1 = simulation.timeline[738]![1] as NikkeDamageEvent;
      expect(damageEvent31Scarlet1.damageParameter.calculateDamage(), 928218);
      expect(damageEvent31Scarlet1.damageParameter.calculateDamage(critical: true), 1285225);

      expect(simulation.timeline[688]!.length, 3); // 41 th
      final damageEvent41Scarlet1 = simulation.timeline[688]![1] as NikkeDamageEvent;
      expect(damageEvent41Scarlet1.damageParameter.calculateDamage(), 1038712);
      expect(damageEvent41Scarlet1.damageParameter.calculateDamage(critical: true), 1438217);

      expect(simulation.timeline[638]!.length, 3); // 51 th
      final damageEvent51Scarlet1 = simulation.timeline[638]![1] as NikkeDamageEvent;
      expect(damageEvent51Scarlet1.damageParameter.calculateDamage(), 1149206);
      expect(damageEvent51Scarlet1.damageParameter.calculateDamage(critical: true), 1591208);

      expect(simulation.timeline[607]!.length, 1); // reload
      final reloadEvent = simulation.timeline[607]![0] as NikkeReloadStartEvent;
      expect(reloadEvent.reloadFrames, 109);

      // when sync is 883
      // equip buffs: 1111 + 1393, self buff 2315 * count, total is 14079
      // gives 903997 + 1272737.37 - 100 = 2176634.37
      // if equip & buff is separate:
      // equip total atk: 226360.84 => 226361
      // self buff if calculated together 1046376.52 => 1046377
      // gives 903997 + 226361 + 1046377 - 100 = 2176635
      // if equip buff separate => 100434.06 & 125926.78
      // individual buff (23.15%) => 213905.3055
      // acceptable range: 2176637 ~ 2176638, at least 2176636 for roundUp, and at most 2176639 for roundDown
      // non-decimal portion is 7 + 4 + 6 + 6, so 4 is +1, and range is +1 ~ +6
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
            ..defence = 140;

      simulation.raptures.add(rapture);
      simulation.maxSeconds = 15;
      simulation.simulate();

      final scarlet1 = simulation.nikkes.first;
      expect(scarlet1.baseAttack, 904831);
      expect(scarlet1.baseDefence, 138266);
      expect(scarlet1.getMaxAmmo(simulation), 57);
      expect(scarlet1.getMaxHp(simulation), 20565804);

      final scarlet3 = simulation.nikkes[2];
      expect(scarlet3.baseAttack, 902961);
      expect(scarlet3.baseDefence, 137894);
      expect(scarlet3.getMaxAmmo(simulation), 63);
      expect(scarlet3.getMaxHp(simulation), 20509704);

      expect(simulation.timeline[888]!.length, 12); // first bullet (fire, damage, burstGen)
      final damageEvent1Scarlet2 = simulation.timeline[888]![4] as NikkeDamageEvent;
      expect(damageEvent1Scarlet2.damageParameter.calculateDamage(), 596736);
      final burstGenEvent1Scarlet2 = simulation.timeline[888]![5] as BurstGenerationEvent;
      expect(burstGenEvent1Scarlet2.burst, 9000);

      final damageEvent1Scarlet4 = simulation.timeline[888]![10] as NikkeDamageEvent;
      expect(damageEvent1Scarlet4.damageParameter.calculateDamage(), 553336);
      final burstGenEvent1Scarlet4 = simulation.timeline[888]![11] as BurstGenerationEvent;
      expect(burstGenEvent1Scarlet4.burst, 9419);

      expect(simulation.timeline[883]!.length, 12); // second bullet

      expect(simulation.timeline[838]!.length, 12); // 11 th
      final damageEvent11Scarlet2 = simulation.timeline[838]![4] as NikkeDamageEvent;
      expect(damageEvent11Scarlet2.damageParameter.calculateDamage(), 707230);

      final damageEvent51Scarlet2 = simulation.timeline[638]![4] as NikkeDamageEvent; // 51 st
      expect(damageEvent51Scarlet2.damageParameter.calculateDamage(), 1149206);

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

    final BattleNikkeOptions aliceOption = BattleNikkeOptions(
      nikkeResourceId: 191,
      coreLevel: 11,
      syncLevel: 884,
      attractLevel: 30,
      skillLevels: [10, 6, 10],
      equips: [
        BattleEquipment(
          type: EquipType.head,
          equipClass: NikkeClass.attacker,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [
            EquipLine(EquipLineType.statAtk, 9),
            EquipLine(EquipLineType.statChargeTime, 7),
            EquipLine(EquipLineType.statAmmo, 13),
          ],
        ),
        BattleEquipment(
          type: EquipType.body,
          equipClass: NikkeClass.attacker,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.statAmmo, 11), EquipLine(EquipLineType.statAtk, 5)],
        ),
        BattleEquipment(
          type: EquipType.arm,
          equipClass: NikkeClass.attacker,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.statAtk, 11), EquipLine(EquipLineType.statChargeTime, 9)],
        ),
        BattleEquipment(
          type: EquipType.leg,
          equipClass: NikkeClass.attacker,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.statAtk, 11), EquipLine(EquipLineType.statAmmo, 7)],
        ),
      ],
      favoriteItem: BattleFavoriteItem(gameData.getDollId(WeaponType.sr, Rarity.sr)!, 15),
      cube: null,
    );

    test('4 Alice with different cubes resourceId 191', () {
      final simulation = BattleSimulation(
        playerOptions: playerOptions,
        nikkeOptions: [
          aliceOption.copy()..cube = BattleHarmonyCube(HarmonyCubeType.reload.cubeId, 15),
          aliceOption.copy()..cube = BattleHarmonyCube(HarmonyCubeType.chargeDamage.cubeId, 7),
          aliceOption.copy()..cube = BattleHarmonyCube(HarmonyCubeType.chargeSpeed.cubeId, 7),
          aliceOption.copy()..cube = BattleHarmonyCube(HarmonyCubeType.burst.cubeId, 7),
        ],
      );

      final rapture =
          BattleRapture()
            ..uniqueId = 11
            ..distance = 30
            ..element = NikkeElement.water
            ..defence = 140;

      simulation.raptures.add(rapture);
      simulation.maxSeconds = 15;
      simulation.simulate();

      final alice1 = simulation.nikkes.first;
      expect(alice1.baseAttack, 903741);
      expect(alice1.baseDefence, 117328);
      expect(alice1.getMaxAmmo(simulation), 18);
      expect(alice1.getMaxHp(simulation), 20699696);

      expect(simulation.timeline[807]!.length, 3); // first bullet (fire, damage, burstGen)
      final damageEvent1Alice3 = simulation.timeline[807]![1] as NikkeDamageEvent;
      expect(damageEvent1Alice3.damageParameter.calculateDamage(core: true), 6756013);
      final burstGenEvent1Alice3 = simulation.timeline[807]![2] as BurstGenerationEvent;
      expect(burstGenEvent1Alice3.burst, 140000);

      expect(simulation.timeline[805]!.length, 9);
      final damageEvent1Alice1 = simulation.timeline[805]![1] as NikkeDamageEvent;
      expect(damageEvent1Alice1.damageParameter.calculateDamage(core: true), 6770023);
      final burstGenEvent1Alice1 = simulation.timeline[805]![2] as BurstGenerationEvent;
      expect(burstGenEvent1Alice1.burst, 56000);
      final damageEvent1Alice2 = simulation.timeline[805]![4] as NikkeDamageEvent;
      expect(damageEvent1Alice2.damageParameter.calculateDamage(core: true), moreOrLessEquals(6845765, epsilon: 1));
      final burstGenEvent1Alice4 = simulation.timeline[805]![8] as BurstGenerationEvent;
      expect(burstGenEvent1Alice4.burst, 58610);
    });
  });
}
