import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/events/buff_event.dart';
import 'package:nikke_einkk/model/battle/events/burst_gen_event.dart';
import 'package:nikke_einkk/model/battle/events/change_burst_step_event.dart';
import 'package:nikke_einkk/model/battle/events/hp_change_event.dart';
import 'package:nikke_einkk/model/battle/events/nikke_damage_event.dart';
import 'package:nikke_einkk/model/battle/events/nikke_reload_event.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/equipment.dart';
import 'package:nikke_einkk/model/favorite_item.dart';
import 'package:nikke_einkk/model/harmony_cube.dart';
import 'package:nikke_einkk/model/items.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/model/user_data.dart';

import '../../test_helper.dart';

void main() {
  TestHelper.loadData();

  group('Nikke Simulation Test', () {
    final PlayerOptions playerOptions = PlayerOptions(
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
    final NikkeOptions scarletOption = NikkeOptions(
      nikkeResourceId: 222,
      coreLevel: 11,
      syncLevel: 884,
      attractLevel: 40,
      skillLevels: [10, 10, 10],
      equips: [
        EquipmentOption(
          type: EquipType.head,
          equipClass: NikkeClass.attacker,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.statAmmo, 9), EquipLine(EquipLineType.increaseElementalDamage, 9)],
        ),
        EquipmentOption(
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
        EquipmentOption(
          type: EquipType.arm,
          equipClass: NikkeClass.attacker,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.statAtk, 10), EquipLine(EquipLineType.statAmmo, 3)],
        ),
        EquipmentOption(
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
      favoriteItem: FavoriteItemOption(weaponType: WeaponType.ar, rarity: Rarity.sr, level: 5),
      cube: null,
    );

    test('Scarlet resourceId 222', () {
      final simulation = BattleSimulation(
        playerOptions: playerOptions,
        nikkeOptions: [scarletOption.copy()..cube = HarmonyCubeOption.fromType(HarmonyCubeType.reload, 15)],
        raptureOptions: [BattleRaptureOptions(startDistance: 30, element: NikkeElement.water, startDefence: 140)],
        advancedOption: BattleAdvancedOption(maxSeconds: 15),
      );

      simulation.simulate();

      final scarlet = simulation.nonnullNikkes.first;
      expect(scarlet.baseAttack, 904831);
      expect(scarlet.baseDefence, 138266);
      expect(scarlet.getMaxAmmo(simulation), 57);
      expect(scarlet.getMaxHp(simulation), 20565804);

      expect(simulation.timeline[888], isNotEmpty); // first bullet (fire, damage, burstGen)
      final damageEvent1Scarlet1 = simulation.timeline[888]![1] as NikkeDamageEvent;
      expect(damageEvent1Scarlet1.damageParameter.calculateDamage(), 596736);
      expect(damageEvent1Scarlet1.damageParameter.calculateDamage(critical: true), 826250);
      final burstGenEvent1Scarlet1 = simulation.timeline[888]![2] as BurstGenerationEvent;
      expect(burstGenEvent1Scarlet1.burst, 9000);

      expect(simulation.timeline[883], isNotEmpty); // second bullet

      expect(simulation.timeline[838], isNotEmpty); // 11 th
      final damageEvent11Scarlet1 = simulation.timeline[838]![1] as NikkeDamageEvent;
      expect(damageEvent11Scarlet1.damageParameter.calculateDamage(), 707230);
      expect(damageEvent11Scarlet1.damageParameter.calculateDamage(critical: true), 979242);

      expect(simulation.timeline[788], isNotEmpty); // 21 th
      final damageEvent21Scarlet1 = simulation.timeline[788]![1] as NikkeDamageEvent;
      expect(damageEvent21Scarlet1.damageParameter.calculateDamage(), 817724);
      expect(damageEvent21Scarlet1.damageParameter.calculateDamage(critical: true), 1132234);

      expect(simulation.timeline[738], isNotEmpty); // 31 th
      final damageEvent31Scarlet1 = simulation.timeline[738]![1] as NikkeDamageEvent;
      expect(damageEvent31Scarlet1.damageParameter.calculateDamage(), 928218);
      expect(damageEvent31Scarlet1.damageParameter.calculateDamage(critical: true), 1285225);

      expect(simulation.timeline[688], isNotEmpty); // 41 th
      final damageEvent41Scarlet1 = simulation.timeline[688]![1] as NikkeDamageEvent;
      expect(damageEvent41Scarlet1.damageParameter.calculateDamage(), 1038712);
      expect(damageEvent41Scarlet1.damageParameter.calculateDamage(critical: true), 1438217);

      expect(simulation.timeline[638], isNotEmpty); // 51 th
      final damageEvent51Scarlet1 = simulation.timeline[638]![1] as NikkeDamageEvent;
      expect(damageEvent51Scarlet1.damageParameter.calculateDamage(), 1149206);
      expect(damageEvent51Scarlet1.damageParameter.calculateDamage(critical: true), 1591208);

      expect(simulation.timeline[607], isNotEmpty); // reload
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
          scarletOption.copy()..cube = HarmonyCubeOption.fromType(HarmonyCubeType.reload, 15),
          scarletOption.copy()..cube = HarmonyCubeOption.fromType(HarmonyCubeType.gainAmmo, 15),
          scarletOption.copy()..cube = HarmonyCubeOption.fromType(HarmonyCubeType.ammoCapacity, 7),
          scarletOption.copy()..cube = HarmonyCubeOption.fromType(HarmonyCubeType.burst, 7),
        ],
        raptureOptions: [BattleRaptureOptions(startDistance: 30, element: NikkeElement.water, startDefence: 140)],
        advancedOption: BattleAdvancedOption(maxSeconds: 15),
      );

      simulation.simulate();

      final scarlet1 = simulation.nonnullNikkes.first;
      expect(scarlet1.baseAttack, 904831);
      expect(scarlet1.baseDefence, 138266);
      expect(scarlet1.getMaxAmmo(simulation), 57);
      expect(scarlet1.getMaxHp(simulation), 20565804);

      final scarlet3 = simulation.nonnullNikkes[2];
      expect(scarlet3.baseAttack, 902961);
      expect(scarlet3.baseDefence, 137894);
      expect(scarlet3.getMaxAmmo(simulation), 63);
      expect(scarlet3.getMaxHp(simulation), 20509704);

      expect(simulation.timeline[888], isNotEmpty); // first bullet (fire, damage, burstGen)
      final damageEvent1Scarlet2 = simulation.timeline[888]![4] as NikkeDamageEvent;
      expect(damageEvent1Scarlet2.damageParameter.calculateDamage(), 596736);
      final burstGenEvent1Scarlet2 = simulation.timeline[888]![5] as BurstGenerationEvent;
      expect(burstGenEvent1Scarlet2.burst, 9000);

      final damageEvent1Scarlet4 = simulation.timeline[888]![10] as NikkeDamageEvent;
      expect(damageEvent1Scarlet4.damageParameter.calculateDamage(), 553336);
      final burstGenEvent1Scarlet4 = simulation.timeline[888]![11] as BurstGenerationEvent;
      expect(burstGenEvent1Scarlet4.burst, 9419);

      expect(simulation.timeline[883], isNotEmpty); // second bullet

      expect(simulation.timeline[838], isNotEmpty); // 11 th
      final damageEvent11Scarlet2 = simulation.timeline[838]![4] as NikkeDamageEvent;
      expect(damageEvent11Scarlet2.damageParameter.calculateDamage(), 707230);

      final damageEvent51Scarlet2 = simulation.timeline[638]![3] as NikkeDamageEvent; // 51 st, no more burst gen event
      expect(damageEvent51Scarlet2.damageParameter.calculateDamage(), 1149206);

      expect(simulation.timeline[607], isNotEmpty); // 1 & 4 reload
      final reloadEventScarlet1 = simulation.timeline[607]![0] as NikkeReloadStartEvent;
      expect(reloadEventScarlet1.reloadFrames, 109);
      final reloadEventScarlet4 = simulation.timeline[607]![1] as NikkeReloadStartEvent;
      expect(reloadEventScarlet4.reloadFrames, 150);

      expect(simulation.timeline[577], isNotEmpty); // 3 reload
      final reloadEventScarlet3 = simulation.timeline[577]![0] as NikkeReloadStartEvent;
      expect(reloadEventScarlet3.reloadFrames, 150);

      expect(simulation.timeline[502], isNotEmpty); // 2 reload
      final reloadEventScarlet2 = simulation.timeline[502]![0] as NikkeReloadStartEvent;
      expect(reloadEventScarlet2.reloadFrames, 150);
    });

    final NikkeOptions aliceOption = NikkeOptions(
      nikkeResourceId: 191,
      coreLevel: 11,
      syncLevel: 884,
      attractLevel: 30,
      skillLevels: [10, 6, 10],
      equips: [
        EquipmentOption(
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
        EquipmentOption(
          type: EquipType.body,
          equipClass: NikkeClass.attacker,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.statAmmo, 11), EquipLine(EquipLineType.statAtk, 5)],
        ),
        EquipmentOption(
          type: EquipType.arm,
          equipClass: NikkeClass.attacker,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.statAtk, 11), EquipLine(EquipLineType.statChargeTime, 9)],
        ),
        EquipmentOption(
          type: EquipType.leg,
          equipClass: NikkeClass.attacker,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.statAtk, 11), EquipLine(EquipLineType.statAmmo, 7)],
        ),
      ],
      favoriteItem: FavoriteItemOption(weaponType: WeaponType.sr, rarity: Rarity.sr, level: 15),
      cube: null,
    );

    test('4 Alice with different cubes resourceId 191', () {
      final simulation = BattleSimulation(
        playerOptions: playerOptions,
        nikkeOptions: [
          aliceOption.copy()..cube = HarmonyCubeOption.fromType(HarmonyCubeType.reload, 15),
          aliceOption.copy()..cube = HarmonyCubeOption.fromType(HarmonyCubeType.chargeDamage, 7),
          aliceOption.copy()..cube = HarmonyCubeOption.fromType(HarmonyCubeType.chargeSpeed, 7),
          aliceOption.copy()..cube = HarmonyCubeOption.fromType(HarmonyCubeType.burst, 7),
        ],
        raptureOptions: [BattleRaptureOptions(startDistance: 30, element: NikkeElement.water, startDefence: 140)],
        advancedOption: BattleAdvancedOption(maxSeconds: 15),
      );

      simulation.simulate();

      final alice1 = simulation.nonnullNikkes.first;
      expect(alice1.baseAttack, 903741);
      expect(alice1.baseDefence, 117328);
      expect(alice1.getMaxAmmo(simulation), 18);
      expect(alice1.getMaxHp(simulation), 20699696);

      expect(simulation.timeline[809], isNotEmpty); // first bullet (fire, damage, burstGen)
      final damageEvent1Alice3 = simulation.timeline[809]![1] as NikkeDamageEvent;
      expect(damageEvent1Alice3.damageParameter.calculateDamage(core: true), 6756013);
      final burstGenEvent1Alice3 = simulation.timeline[809]![2] as BurstGenerationEvent;
      expect(burstGenEvent1Alice3.burst, 140000);

      expect(simulation.timeline[807], isNotEmpty);
      final damageEvent1Alice1 = simulation.timeline[807]![1] as NikkeDamageEvent;
      expect(damageEvent1Alice1.damageParameter.calculateDamage(core: true), 6770023);
      final burstGenEvent1Alice1 = simulation.timeline[807]![2] as BurstGenerationEvent;
      expect(burstGenEvent1Alice1.burst, 56000);
      final damageEvent1Alice2 = simulation.timeline[807]![4] as NikkeDamageEvent;
      expect(damageEvent1Alice2.damageParameter.calculateDamage(core: true), moreOrLessEquals(6845765, epsilon: 1));
      final burstGenEvent1Alice4 = simulation.timeline[807]![8] as BurstGenerationEvent;
      expect(burstGenEvent1Alice4.burst, 58610);
    });

    test('Rapunzel: Pure Grace fire timing', () {
      final simulation = BattleSimulation(
        playerOptions: playerOptions,
        nikkeOptions: [
          NikkeOptions(
            nikkeResourceId: 226,
            coreLevel: 11,
            syncLevel: 884,
            attractLevel: 33,
            skillLevels: [1, 1, 1],
            equips: [],
          ),
        ],
        raptureOptions: [BattleRaptureOptions(startDistance: 30, element: NikkeElement.water, startDefence: 140)],
        advancedOption: BattleAdvancedOption(maxSeconds: 15),
      );

      simulation.simulate();

      expect(simulation.timeline[830]!.isNotEmpty, true); // first bullet (fire, damage, burstGen)
      expect(simulation.timeline[747]!.isNotEmpty, true);
      expect(simulation.timeline[664]!.isNotEmpty, true);
    });

    test('Scarlet with emergency max hp cube', () {
      final simulation = BattleSimulation(
        playerOptions: playerOptions,
        nikkeOptions: [scarletOption.copy()..cube = HarmonyCubeOption.fromType(HarmonyCubeType.emergencyMaxHp, 15)],
        raptureOptions: [BattleRaptureOptions(startDistance: 30, element: NikkeElement.water, startDefence: 140)],
      );

      simulation.simulate();

      final scarlet = simulation.nonnullNikkes.first;
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
      final NikkeOptions snowWhiteOption = NikkeOptions(
        nikkeResourceId: 220,
        coreLevel: 11,
        syncLevel: 884,
        attractLevel: 40,
        skillLevels: [7, 10, 10],
        equips: [
          EquipmentOption(
            type: EquipType.head,
            equipClass: NikkeClass.attacker,
            rarity: EquipRarity.t10,
            level: 5,
            equipLines: [EquipLine(EquipLineType.statAtk, 5)],
          ),
          EquipmentOption(
            type: EquipType.body,
            equipClass: NikkeClass.attacker,
            rarity: EquipRarity.t10,
            level: 5,
            equipLines: [EquipLine(EquipLineType.statAtk, 8)],
          ),
          EquipmentOption(
            type: EquipType.arm,
            equipClass: NikkeClass.attacker,
            rarity: EquipRarity.t10,
            level: 5,
            equipLines: [EquipLine(EquipLineType.statAtk, 5)],
          ),
          EquipmentOption(
            type: EquipType.leg,
            equipClass: NikkeClass.attacker,
            rarity: EquipRarity.t10,
            level: 1,
            equipLines: [EquipLine(EquipLineType.statAtk, 11)],
          ),
        ],
        favoriteItem: FavoriteItemOption(weaponType: WeaponType.ar, rarity: Rarity.r, level: 0),
        cube: null,
      );

      final simulation = BattleSimulation(
        playerOptions: PlayerOptions(
          personalRecycleLevel: 420,
          corpRecycleLevels: {Corporation.pilgrim: 417},
          classRecycleLevels: {NikkeClass.attacker: 212},
        ),
        nikkeOptions: [snowWhiteOption.copy()..cube = HarmonyCubeOption.fromType(HarmonyCubeType.reload, 15)],
        raptureOptions: [BattleRaptureOptions(startDistance: 30, element: NikkeElement.electric, startDefence: 140)],
        advancedOption: BattleAdvancedOption(maxSeconds: 90),
      );

      simulation.simulate();

      final snowWhite = simulation.nonnullNikkes.first;
      expect(snowWhite.baseAttack, 900990);
      expect(snowWhite.baseDefence, 137056);
      expect(snowWhite.getMaxAmmo(simulation), 60);
      expect(snowWhite.getMaxHp(simulation), 20421354);

      expect(simulation.timeline[5238], isNotEmpty);
      final damageEvent31SnowWhite = simulation.timeline[5238]![1] as NikkeDamageEvent;
      expect(damageEvent31SnowWhite.damageParameter.calculateDamage(), 320091);
      // 443203 is actual damage
      expect(damageEvent31SnowWhite.damageParameter.calculateDamage(critical: true), 443203 - 1);
      expect(damageEvent31SnowWhite.damageParameter.calculateDamage(core: true), 580275);
      expect(damageEvent31SnowWhite.damageParameter.calculateDamage(critical: true, core: true), 703387);

      expect(simulation.timeline[5093], isNotEmpty); // S1
      final damageEventSkill1SnowWhite =
          simulation.timeline[5093]!
                  .where((event) => event is NikkeDamageEvent && event.source == Source.skill1)
                  .firstOrNull
              as NikkeDamageEvent?;
      expect(damageEventSkill1SnowWhite, isNotNull);
      expect(damageEventSkill1SnowWhite!.damageParameter.calculateDamage(), 1212706);

      expect(simulation.timeline[4501], isNotEmpty); // S2
      final damageEventSkill2SnowWhite = simulation.timeline[4501]![1] as NikkeDamageEvent;
      expect(damageEventSkill2SnowWhite.source, Source.skill2);
      expect(damageEventSkill2SnowWhite.damageParameter.calculateDamage(), 2422566);
    });

    final NikkeOptions literOption = NikkeOptions(
      nikkeResourceId: 82,
      coreLevel: 11,
      syncLevel: 884,
      attractLevel: 30,
      skillLevels: [10, 6, 10],
      equips: [
        EquipmentOption(
          type: EquipType.head,
          equipClass: NikkeClass.supporter,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.increaseElementalDamage, 11)],
        ),
        EquipmentOption(
          type: EquipType.body,
          equipClass: NikkeClass.supporter,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.statAmmo, 11), EquipLine(EquipLineType.startAccuracyCircle, 11)],
        ),
        EquipmentOption(
          type: EquipType.arm,
          equipClass: NikkeClass.supporter,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.statDef, 11), EquipLine(EquipLineType.statAmmo, 11)],
        ),
        EquipmentOption(
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
      favoriteItem: FavoriteItemOption(weaponType: WeaponType.smg, rarity: Rarity.r, level: 0),
      cube: null,
    );

    test('Liter skill test on minus CD', () {
      final simulation = BattleSimulation(
        playerOptions: PlayerOptions(),
        nikkeOptions: [
          literOption.copy()..cube = HarmonyCubeOption.fromType(HarmonyCubeType.gainAmmo, 15),
          NikkeOptions(nikkeResourceId: 80, coreLevel: 11, syncLevel: 884, attractLevel: 30, skillLevels: [4, 4, 4])
            ..cube = HarmonyCubeOption.fromType(HarmonyCubeType.burst, 7),
          aliceOption.copy()..cube = HarmonyCubeOption.fromType(HarmonyCubeType.burst, 7),
          scarletOption.copy(),
          NikkeOptions(nikkeResourceId: 80, coreLevel: 11, syncLevel: 884, attractLevel: 30, skillLevels: [4, 4, 4])
            ..cube = HarmonyCubeOption.fromType(HarmonyCubeType.burst, 7),
        ],
        raptureOptions: [BattleRaptureOptions(startDistance: 30, element: NikkeElement.water, startDefence: 140)],
        advancedOption: BattleAdvancedOption(forceFillBurst: true),
      );

      simulation.simulate();

      final firstBurstFrame = simulation.timeline.keys.firstWhere(
        (frame) => simulation.timeline[frame]!.any((event) => event is ChangeBurstStepEvent),
      );
      final toStage1 =
          simulation.timeline[firstBurstFrame]!.firstWhere((event) => event is ChangeBurstStepEvent)
              as ChangeBurstStepEvent;
      expect(toStage1.activatorId, -1);
      expect(toStage1.nextStage, 1);
      final toStage2 =
          simulation.timeline[firstBurstFrame - 1]!.firstWhere((event) => event is ChangeBurstStepEvent)
              as ChangeBurstStepEvent;
      expect(toStage2.activatorId, 1);
      expect(toStage2.nextStage, 2);
      final toStage3 =
          simulation.timeline[firstBurstFrame - 2]!.firstWhere((event) => event is ChangeBurstStepEvent)
              as ChangeBurstStepEvent;
      expect(toStage3.activatorId, 2);
      expect(toStage3.nextStage, 3);
      final toStage4 =
          simulation.timeline[firstBurstFrame - 3]!.firstWhere((event) => event is ChangeBurstStepEvent)
              as ChangeBurstStepEvent;
      expect(toStage4.activatorId, 3);
      expect(toStage4.nextStage, 4);
      expect(toStage4.duration, 1000);

      final nextLiterBurstFrame = firstBurstFrame - 1 - 1200 + (2.34 * 60).round();
      expect(simulation.timeline.containsKey(nextLiterBurstFrame), true);
      final nextLiterBurst =
          simulation.timeline[nextLiterBurstFrame]!.firstWhereOrNull((event) => event is ChangeBurstStepEvent)
              as ChangeBurstStepEvent?;
      expect(nextLiterBurst, isNotNull);
      expect(nextLiterBurst!.activatorId, 1);
      expect(nextLiterBurst.nextStage, 2);

      final thirdLiterBurstFrame = nextLiterBurstFrame - 1200 + ((2.34 + 2.7) * 60).round();
      expect(simulation.timeline.containsKey(thirdLiterBurstFrame), true);
      final thirdLiterBurst =
          simulation.timeline[thirdLiterBurstFrame]!.firstWhereOrNull((event) => event is ChangeBurstStepEvent)
              as ChangeBurstStepEvent?;
      expect(thirdLiterBurst, isNotNull);
      expect(thirdLiterBurst!.activatorId, 1);
      expect(thirdLiterBurst.nextStage, 2);

      final fourthLiterBurstFrame = thirdLiterBurstFrame - 1200 + ((2.34 + 2.7 + 3.17) * 60).round();
      expect(simulation.timeline.containsKey(fourthLiterBurstFrame), true);
      final fourthLiterBurst =
          simulation.timeline[fourthLiterBurstFrame]!.firstWhereOrNull((event) => event is ChangeBurstStepEvent)
              as ChangeBurstStepEvent?;
      expect(fourthLiterBurst, isNotNull);
      expect(fourthLiterBurst!.activatorId, 1);
      expect(fourthLiterBurst.nextStage, 2);
    });

    final crownOption = NikkeOptions(
      nikkeResourceId: 330,
      coreLevel: 11,
      syncLevel: 884,
      attractLevel: 40,
      skillLevels: [10, 10, 10],
      equips: [
        EquipmentOption(
          type: EquipType.head,
          equipClass: NikkeClass.defender,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [],
        ),
        EquipmentOption(
          type: EquipType.body,
          equipClass: NikkeClass.defender,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.statAmmo, 11)],
        ),
        EquipmentOption(
          type: EquipType.arm,
          equipClass: NikkeClass.defender,
          rarity: EquipRarity.t10,
          level: 5,
          equipLines: [EquipLine(EquipLineType.statAmmo, 11)],
        ),
        EquipmentOption(
          type: EquipType.leg,
          equipClass: NikkeClass.defender,
          rarity: EquipRarity.t10,
          level: 3,
          equipLines: [],
        ),
      ],
      favoriteItem: FavoriteItemOption(weaponType: WeaponType.mg, rarity: Rarity.sr, level: 15),
      cube: null,
    );

    test('Crown skill tests', () {
      final PlayerOptions updatedPlayerOptions = PlayerOptions(
        personalRecycleLevel: 420,
        corpRecycleLevels: {
          Corporation.pilgrim: 417,
          Corporation.missilis: 198,
          Corporation.abnormal: 156,
          Corporation.tetra: 225,
          Corporation.elysion: 200,
        },
        classRecycleLevels: {NikkeClass.attacker: 212, NikkeClass.supporter: 197, NikkeClass.defender: 187},
      );
      final simulation = BattleSimulation(
        playerOptions: updatedPlayerOptions,
        nikkeOptions: [
          literOption.copy()..cube = HarmonyCubeOption.fromType(HarmonyCubeType.gainAmmo, 15),
          crownOption.copy()..cube = HarmonyCubeOption.fromType(HarmonyCubeType.reload, 15),
          scarletOption.copy(),
          scarletOption.copy(),
        ],
        raptureOptions: [BattleRaptureOptions(startDistance: 30, element: NikkeElement.water, startDefence: 140)],
        advancedOption: BattleAdvancedOption(maxSeconds: 90),
      );

      simulation.simulate();

      final crown = simulation.nonnullNikkes[1];
      expect(crown.baseHp, 25116193);
      expect(crown.baseAttack, 614834);
      expect(crown.baseDefence, 142547);

      // go to second burst so scarlet has full self buffs
      final burstTimeFrame = simulation.timeline.keys.firstWhere(
        (frame) =>
            frame < 5168 &&
            simulation.timeline[frame]!.any((event) => event is ChangeBurstStepEvent && event.nextStage == 4),
      );
      // crown's add def skill group
      expect(
        simulation.timeline[burstTimeFrame]!.firstWhereOrNull(
          (event) => event is BuffEvent && event.data.groupId == 2330102,
        ),
        isNotNull,
      );
      // -60 for common burst damage delay
      final scarletBurstDamageEvent =
          simulation.timeline[burstTimeFrame - 60]!.firstWhere(
                (event) => event is NikkeDamageEvent && event.source == Source.burst && event.activatorId == 4,
              )
              as NikkeDamageEvent;
      expect(scarletBurstDamageEvent.damageParameter.calculateDamage(), 48325502 + 3); // 3 more than actual

      final scarletDamageFrameAfterBurst = simulation.timeline.keys.firstWhere(
        (frame) =>
            frame < burstTimeFrame &&
            simulation.timeline[frame]!.any(
              (event) => event is NikkeDamageEvent && event.source == Source.bullet && event.activatorId == 3,
            ),
      );
      final scarletDamageEventPos4 =
          simulation.timeline[scarletDamageFrameAfterBurst]!.firstWhere(
                (event) => event is NikkeDamageEvent && event.source == Source.bullet && event.activatorId == 4,
              )
              as NikkeDamageEvent;
      expect(scarletDamageEventPos4.damageParameter.calculateDamage(), 3171493);

      final scarletDamageEventPos3 =
          simulation.timeline[scarletDamageFrameAfterBurst]!.firstWhere(
                (event) => event is NikkeDamageEvent && event.source == Source.bullet && event.activatorId == 3,
              )
              as NikkeDamageEvent;
      expect(scarletDamageEventPos3.damageParameter.calculateDamage(), 2774043);

      // when crown max stacks skill 2, 2330206 is add damage group
      expect(
        simulation.timeline.values.firstWhereOrNull(
          (events) => events.any((event) => event is BuffEvent && event.data.groupId == 2330206),
        ),
        isNotNull,
      );
    });
  });
}
