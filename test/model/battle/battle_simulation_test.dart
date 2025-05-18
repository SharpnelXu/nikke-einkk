import 'package:collection/collection.dart';
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

      final damageEvent51Scarlet2 = simulation.timeline[638]![3] as NikkeDamageEvent; // 51 st, no more burst gen event
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

      expect(simulation.timeline[810]!.length, 3); // first bullet (fire, damage, burstGen)
      final damageEvent1Alice3 = simulation.timeline[810]![1] as NikkeDamageEvent;
      expect(damageEvent1Alice3.damageParameter.calculateDamage(core: true), 6756013);
      final burstGenEvent1Alice3 = simulation.timeline[810]![2] as BurstGenerationEvent;
      expect(burstGenEvent1Alice3.burst, 140000);

      expect(simulation.timeline[808]!.length, 9);
      final damageEvent1Alice1 = simulation.timeline[808]![1] as NikkeDamageEvent;
      expect(damageEvent1Alice1.damageParameter.calculateDamage(core: true), 6770023);
      final burstGenEvent1Alice1 = simulation.timeline[808]![2] as BurstGenerationEvent;
      expect(burstGenEvent1Alice1.burst, 56000);
      final damageEvent1Alice2 = simulation.timeline[808]![4] as NikkeDamageEvent;
      expect(damageEvent1Alice2.damageParameter.calculateDamage(core: true), moreOrLessEquals(6845765, epsilon: 1));
      final burstGenEvent1Alice4 = simulation.timeline[808]![8] as BurstGenerationEvent;
      expect(burstGenEvent1Alice4.burst, 58610);
    });

    test('Rapunzel: Pure Grace fire timing', () {
      final simulation = BattleSimulation(
        playerOptions: playerOptions,
        nikkeOptions: [
          BattleNikkeOptions(
            nikkeResourceId: 226,
            coreLevel: 11,
            syncLevel: 884,
            attractLevel: 33,
            skillLevels: [1, 1, 1],
            equips: [],
          ),
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

      expect(simulation.timeline[831]!.length, 3); // first bullet (fire, damage, burstGen)
      expect(simulation.timeline[749]!.length, 3);
      expect(simulation.timeline[667]!.length, 3);
    });

    test('Scarlet with emergency max hp cube', () {
      final simulation = BattleSimulation(
        playerOptions: playerOptions,
        nikkeOptions: [scarletOption.copy()..cube = BattleHarmonyCube(HarmonyCubeType.emergencyMaxHp.cubeId, 15)],
      );

      final rapture =
          BattleRapture()
            ..uniqueId = 11
            ..distance = 30
            ..element = NikkeElement.water
            ..defence = 140;

      simulation.raptures.add(rapture);
      simulation.maxSeconds = 180;
      simulation.simulate();

      final scarlet = simulation.nikkes.first;
      expect(scarlet.getMaxHp(simulation), 20565804);
      final hpChangeEvent1 =
          simulation.timeline[10743]?.firstWhereOrNull((event) => event is HpChangeEvent) as HpChangeEvent;
      expect(hpChangeEvent1, isNotNull);
      expect(hpChangeEvent1.maxHp, 20565804);
      expect(hpChangeEvent1.afterChangeHp, 19741115);
      expect(hpChangeEvent1.changeAmount, -824689);

      final hpChangeEvents2 = simulation.timeline[7687]?.whereType<HpChangeEvent>().toList();
      expect(hpChangeEvents2, isNotNull);
      expect(hpChangeEvents2!.length, 2);
      expect(hpChangeEvents2[0].maxHp, 20565804);
      expect(hpChangeEvents2[0].afterChangeHp, 4001155);
      expect(hpChangeEvents2[0].changeAmount, -167149);
      expect(hpChangeEvents2[1].maxHp, 23062493);
      expect(hpChangeEvents2[1].afterChangeHp, 4001155 + 23062493 - 20565804);
      expect(hpChangeEvents2[1].changeAmount, 23062493 - 20565804);
      expect(hpChangeEvents2[1].isMaxHpOnly, false);

      final hpChangeEvents3 = simulation.timeline[7079]?.whereType<HpChangeEvent>().toList();
      expect(hpChangeEvents3, isNotNull);
      expect(hpChangeEvents3!.length, 2);
      expect(hpChangeEvents3[1].maxHp, 23062493);
      expect(hpChangeEvents3[1].changeAmount, 0);
      expect(hpChangeEvents3[1].isMaxHpOnly, false);

      final hpChangeEvents4 = simulation.timeline[5878]?.whereType<HpChangeEvent>().toList();
      expect(hpChangeEvents4, isNotNull);
      expect(hpChangeEvents4!.length, 1);
      expect(hpChangeEvents4[0].maxHp, 20565804);
      expect(hpChangeEvents4[0].changeAmount, 20565804 - 23062493);
      expect(hpChangeEvents4[0].isMaxHpOnly, true);
    });

    test('SnowWhite attack & normal skill damage tests resource Id 220', () {
      final BattleNikkeOptions snowWhiteOption = BattleNikkeOptions(
        nikkeResourceId: 220,
        coreLevel: 11,
        syncLevel: 884,
        attractLevel: 40,
        skillLevels: [7, 10, 10],
        equips: [
          BattleEquipment(
            type: EquipType.head,
            equipClass: NikkeClass.attacker,
            rarity: EquipRarity.t10,
            level: 5,
            equipLines: [EquipLine(EquipLineType.statAtk, 5)],
          ),
          BattleEquipment(
            type: EquipType.body,
            equipClass: NikkeClass.attacker,
            rarity: EquipRarity.t10,
            level: 5,
            equipLines: [EquipLine(EquipLineType.statAtk, 8)],
          ),
          BattleEquipment(
            type: EquipType.arm,
            equipClass: NikkeClass.attacker,
            rarity: EquipRarity.t10,
            level: 5,
            equipLines: [EquipLine(EquipLineType.statAtk, 5)],
          ),
          BattleEquipment(
            type: EquipType.leg,
            equipClass: NikkeClass.attacker,
            rarity: EquipRarity.t10,
            level: 1,
            equipLines: [EquipLine(EquipLineType.statAtk, 11)],
          ),
        ],
        favoriteItem: BattleFavoriteItem(gameData.getDollId(WeaponType.ar, Rarity.r)!, 0),
        cube: null,
      );

      final simulation = BattleSimulation(
        playerOptions: BattlePlayerOptions(
          personalRecycleLevel: 420,
          corpRecycleLevels: {Corporation.pilgrim: 417},
          classRecycleLevels: {NikkeClass.attacker: 212},
        ),
        nikkeOptions: [snowWhiteOption.copy()..cube = BattleHarmonyCube(HarmonyCubeType.reload.cubeId, 15)],
      );

      final rapture =
          BattleRapture()
            ..uniqueId = 11
            ..distance = 30
            ..element = NikkeElement.electric
            ..defence = 140;

      simulation.raptures.add(rapture);
      simulation.maxSeconds = 90;
      simulation.simulate();

      final snowWhite = simulation.nikkes.first;
      expect(snowWhite.baseAttack, 900990);
      expect(snowWhite.baseDefence, 137056);
      expect(snowWhite.getMaxAmmo(simulation), 60);
      expect(snowWhite.getMaxHp(simulation), 20421354);

      expect(simulation.timeline[5238]!.length, 3);
      final damageEvent31SnowWhite = simulation.timeline[5238]![1] as NikkeDamageEvent;
      expect(damageEvent31SnowWhite.damageParameter.calculateDamage(), 320091);
      // 443203 is actual damage
      expect(damageEvent31SnowWhite.damageParameter.calculateDamage(critical: true), 443203 - 1);
      expect(damageEvent31SnowWhite.damageParameter.calculateDamage(core: true), 580275);
      expect(damageEvent31SnowWhite.damageParameter.calculateDamage(critical: true, core: true), 703387);

      expect(simulation.timeline[5093]!.length, 5); // S1
      final damageEventSkill1SnowWhite = simulation.timeline[5093]![3] as NikkeDamageEvent;
      expect(damageEventSkill1SnowWhite.type, NikkeDamageType.skill);
      expect(damageEventSkill1SnowWhite.damageParameter.calculateDamage(), 1212706);

      expect(simulation.timeline[4501]!.length, 1); // S2
      final damageEventSkill2SnowWhite = simulation.timeline[4501]![0] as NikkeDamageEvent;
      expect(damageEventSkill2SnowWhite.type, NikkeDamageType.skill);
      expect(damageEventSkill2SnowWhite.damageParameter.calculateDamage(), 2422566);
    });

    final BattleNikkeOptions literOption = BattleNikkeOptions(
      nikkeResourceId: 82,
      coreLevel: 11,
      syncLevel: 884,
      attractLevel: 30,
      skillLevels: [10, 6, 10],
      equips: [
        BattleEquipment(
          type: EquipType.head,
          equipClass: NikkeClass.supporter,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.increaseElementalDamage, 11)],
        ),
        BattleEquipment(
          type: EquipType.body,
          equipClass: NikkeClass.supporter,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.statAmmo, 11), EquipLine(EquipLineType.startAccuracyCircle, 11)],
        ),
        BattleEquipment(
          type: EquipType.arm,
          equipClass: NikkeClass.supporter,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.statDef, 11), EquipLine(EquipLineType.statAmmo, 11)],
        ),
        BattleEquipment(
          type: EquipType.leg,
          equipClass: NikkeClass.supporter,
          rarity: EquipRarity.t10,
          level: 3,
          equipLines: [
            EquipLine(EquipLineType.increaseElementalDamage, 11),
            EquipLine(EquipLineType.statChargeTime, 11),
          ],
        ),
      ],
      favoriteItem: BattleFavoriteItem(gameData.getDollId(WeaponType.smg, Rarity.r)!, 0),
      cube: null,
    );

    test('Liter skill test on minus CD', () {
      final simulation = BattleSimulation(
        playerOptions: BattlePlayerOptions(forceFillBurst: true),
        nikkeOptions: [
          literOption.copy()..cube = BattleHarmonyCube(HarmonyCubeType.gainAmmo.cubeId, 15),
          BattleNikkeOptions(
            nikkeResourceId: 80,
            coreLevel: 11,
            syncLevel: 884,
            attractLevel: 30,
            skillLevels: [4, 4, 4],
          )..cube = BattleHarmonyCube(HarmonyCubeType.burst.cubeId, 7),
          aliceOption.copy()..cube = BattleHarmonyCube(HarmonyCubeType.burst.cubeId, 7),
          scarletOption.copy(),
          BattleNikkeOptions(
            nikkeResourceId: 80,
            coreLevel: 11,
            syncLevel: 884,
            attractLevel: 30,
            skillLevels: [4, 4, 4],
          )..cube = BattleHarmonyCube(HarmonyCubeType.burst.cubeId, 7),
        ],
      );

      final rapture =
          BattleRapture()
            ..uniqueId = 11
            ..distance = 30
            ..element = NikkeElement.water
            ..defence = 140;

      simulation.raptures.add(rapture);
      simulation.maxSeconds = 180;
      simulation.simulate();

      final firstBurstFrame = simulation.timeline.keys.firstWhere(
        (frame) => simulation.timeline[frame]!.any((event) => event is ChangeBurstStepEvent),
      );
      final toStage1 =
          simulation.timeline[firstBurstFrame]!.firstWhere((event) => event is ChangeBurstStepEvent)
              as ChangeBurstStepEvent;
      expect(toStage1.ownerUniqueId, -1);
      expect(toStage1.nextStage, 1);
      final toStage2 =
          simulation.timeline[firstBurstFrame - 1]!.firstWhere((event) => event is ChangeBurstStepEvent)
              as ChangeBurstStepEvent;
      expect(toStage2.ownerUniqueId, 1);
      expect(toStage2.nextStage, 2);
      final toStage3 =
          simulation.timeline[firstBurstFrame - 2]!.firstWhere((event) => event is ChangeBurstStepEvent)
              as ChangeBurstStepEvent;
      expect(toStage3.ownerUniqueId, 2);
      expect(toStage3.nextStage, 3);
      final toStage4 =
          simulation.timeline[firstBurstFrame - 3]!.firstWhere((event) => event is ChangeBurstStepEvent)
              as ChangeBurstStepEvent;
      expect(toStage4.ownerUniqueId, 3);
      expect(toStage4.nextStage, 4);
      expect(toStage4.duration, 1000);

      final nextLiterBurstFrame = firstBurstFrame - 1 - 1200 + (2.34 * 60).round();
      expect(simulation.timeline.containsKey(nextLiterBurstFrame), true);
      final nextLiterBurst =
          simulation.timeline[nextLiterBurstFrame]!.firstWhereOrNull((event) => event is ChangeBurstStepEvent)
              as ChangeBurstStepEvent?;
      expect(nextLiterBurst, isNotNull);
      expect(nextLiterBurst!.ownerUniqueId, 1);
      expect(nextLiterBurst.nextStage, 2);

      final thirdLiterBurstFrame = nextLiterBurstFrame - 1200 + ((2.34 + 2.7) * 60).round();
      expect(simulation.timeline.containsKey(thirdLiterBurstFrame), true);
      final thirdLiterBurst =
          simulation.timeline[thirdLiterBurstFrame]!.firstWhereOrNull((event) => event is ChangeBurstStepEvent)
              as ChangeBurstStepEvent?;
      expect(thirdLiterBurst, isNotNull);
      expect(thirdLiterBurst!.ownerUniqueId, 1);
      expect(thirdLiterBurst.nextStage, 2);

      final fourthLiterBurstFrame = thirdLiterBurstFrame - 1200 + ((2.34 + 2.7 + 3.17) * 60).round();
      expect(simulation.timeline.containsKey(fourthLiterBurstFrame), true);
      final fourthLiterBurst =
          simulation.timeline[fourthLiterBurstFrame]!.firstWhereOrNull((event) => event is ChangeBurstStepEvent)
              as ChangeBurstStepEvent?;
      expect(fourthLiterBurst, isNotNull);
      expect(fourthLiterBurst!.ownerUniqueId, 1);
      expect(fourthLiterBurst.nextStage, 2);
    });
  });
}
