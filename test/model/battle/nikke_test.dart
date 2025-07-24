import 'package:flutter_test/flutter_test.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/events/nikke_damage_event.dart';
import 'package:nikke_einkk/model/battle/events/nikke_fire_event.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/equipment.dart';
import 'package:nikke_einkk/model/harmony_cube.dart';
import 'package:nikke_einkk/model/items.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/model/user_data.dart';

import '../../test_helper.dart';

void main() {
  TestHelper.loadData();

  group('Nikke Stat Calculation Test', () {
    test('Dorothy resourceId 233', () {
      final dorothy = BattleNikke(
        playerOptions: PlayerOptions(personalRecycleLevel: 0, corpRecycleLevels: {}, classRecycleLevels: {}),
        option: NikkeOptions(nikkeResourceId: 233, coreLevel: 1),
      );

      // default lv1 lb0
      expect(dorothy.baseHp, 15000);
      expect(dorothy.baseAttack, 500);
      expect(dorothy.baseDefence, 100);

      // lv2 lb0
      dorothy.option.syncLevel = 2;
      expect(dorothy.baseHp, 15750);
      expect(dorothy.baseAttack, 525);
      expect(dorothy.baseDefence, 105);

      // lv1 lb1
      dorothy.option.syncLevel = 1;
      dorothy.option.coreLevel = 2;
      expect(dorothy.baseHp, 18300);
      expect(dorothy.baseAttack, 530);
      expect(dorothy.baseDefence, 202);

      // lv1 lbmax
      dorothy.option.coreLevel = 4;
      expect(dorothy.baseHp, 24900);
      expect(dorothy.baseAttack, 590);
      expect(dorothy.baseDefence, 406);

      dorothy.playerOptions.personalRecycleLevel = 410;
      dorothy.playerOptions.corpRecycleLevels[Corporation.pilgrim] = 392;
      dorothy.playerOptions.classRecycleLevels[NikkeClass.supporter] = 187;
      dorothy.option.attractLevel = 40;
      dorothy.option.coreLevel = 5;
      expect(dorothy.baseHp, 416313);
      expect(dorothy.baseAttack, 12587);
      expect(dorothy.baseDefence, 3765);
    });

    test('Rosanna: Chic Ocean resourceId 283', () {
      final rosanna = BattleNikke(
        playerOptions: PlayerOptions(
          personalRecycleLevel: 410,
          corpRecycleLevels: {Corporation.tetra: 217},
          classRecycleLevels: {NikkeClass.supporter: 187},
        ),
        option: NikkeOptions(nikkeResourceId: 283, coreLevel: 5, syncLevel: 866, attractLevel: 29),
      );

      expect(rosanna.baseHp, 18537879);
      expect(rosanna.baseAttack, 612174);
      expect(rosanna.baseDefence, 123687);
    });

    test('Mica: Snow Buddy resourceId 62', () {
      final mica = BattleNikke(
        playerOptions: PlayerOptions(
          personalRecycleLevel: 410,
          corpRecycleLevels: {Corporation.tetra: 217},
          classRecycleLevels: {NikkeClass.supporter: 187},
        ),
        option: NikkeOptions(nikkeResourceId: 62, coreLevel: 9, syncLevel: 866, attractLevel: 22),
      );

      expect(mica.baseHp, 19979208);
      expect(mica.baseAttack, 659768);
      expect(mica.baseDefence, 115173);
    });

    test('Flora resourceId 411', () {
      final flora = BattleNikke(
        playerOptions: PlayerOptions(
          personalRecycleLevel: 420,
          corpRecycleLevels: {Corporation.missilis: 197},
          classRecycleLevels: {NikkeClass.supporter: 193},
        ),
        option: NikkeOptions(nikkeResourceId: 411, coreLevel: 11, syncLevel: 884, attractLevel: 13),
      );

      expect(flora.baseHp, 22070775);
      expect(flora.baseAttack, 728348);
      expect(flora.baseDefence, 123496);

      // from blabla so may not be entirely accurate too be honest...
      flora.option.syncLevel = 901;
      expect(flora.baseHp, 22070775 + 1433386);
      expect(flora.baseAttack, 728348 + 47779);
      expect(flora.baseDefence, 123496 + 7994);

      flora.option.syncLevel = 601;
      flora.option.coreLevel = 4;
      expect(flora.baseHp, 22070775 - 15065630);
      expect(flora.baseAttack, 728348 - 501285);
      expect(flora.baseDefence, 123496 - 84073);

      flora.option.coreLevel = 7;
      expect(flora.baseHp, 22070775 - 14645321);
      expect(flora.baseAttack, 728348 - 487661);
      expect(flora.baseDefence, 123496 - 81708);

      flora.option.syncLevel = 963;
      expect(flora.baseHp, 22070775 + 4464769);
      expect(flora.baseAttack, 728348 + 149340);
      expect(flora.baseDefence, 123496 + 24872);
    });

    test('Brid resourceId 70', () {
      final brid = BattleNikke(
        playerOptions: PlayerOptions(
          personalRecycleLevel: 420,
          corpRecycleLevels: {Corporation.elysion: 197},
          classRecycleLevels: {NikkeClass.attacker: 211},
        ),
        option: NikkeOptions(nikkeResourceId: 70, coreLevel: 11, syncLevel: 884, attractLevel: 15),
      );

      expect(brid.baseHp, 19921125);
      expect(brid.baseAttack, 873013);
      expect(brid.baseDefence, 132774);

      // from blabla so may not be entirely accurate too be honest...
      brid.option.syncLevel = 934;
      expect(brid.baseHp, 19921125 + 2958183);
      expect(brid.baseAttack, 873013 + 131474);
      expect(brid.baseDefence, 132774 + 19720);

      brid.option.syncLevel = 251;
      brid.option.coreLevel = 8;
      expect(brid.baseHp, 19921125 - 18647109);
      expect(brid.baseAttack, 873013 - 828109);
      expect(brid.baseDefence, 132774 - 124320);

      brid.option.syncLevel = 85;
      brid.option.coreLevel = 7;
      expect(brid.baseHp, 19921125 - 19402485);
      expect(brid.baseAttack, 873013 - 861463);
      expect(brid.baseDefence, 132774 - 129353);

      brid.option.syncLevel = 565;
      brid.option.coreLevel = 2;
      expect(brid.baseHp, 19921125 - 14674981);
      expect(brid.baseAttack, 873013 - 650474);
      expect(brid.baseDefence, 132774 - 97992);

      brid.option.syncLevel = 267;
      brid.option.coreLevel = 4;
      // this sets hp to end in 25, and would result in a half rounding problem for higher core levels
      expect(brid.baseHp, 19921125 - 18623700);
      expect(brid.baseAttack, 873013 - 826201);
      expect(brid.baseDefence, 132774 - 124160);

      brid.option.coreLevel = 5;
      expect(brid.baseHp, 19921125 - 18597751);
      expect(brid.baseAttack, 873013 - 825265);
      expect(brid.baseDefence, 132774 - 123988);

      brid.option.coreLevel = 6;
      expect(brid.baseHp, 19921125 - 18571803);
      expect(brid.baseAttack, 873013 - 824329);
      expect(brid.baseDefence, 132774 - 123815);

      brid.option.coreLevel = 7;
      expect(brid.baseHp, 19921125 - 18545854);
      expect(brid.baseAttack, 873013 - 823392);
      expect(brid.baseDefence, 132774 - 123643);

      brid.option.coreLevel = 8;
      expect(brid.baseHp, 19921125 - 18519906);
      expect(brid.baseAttack, 873013 - 822456);
      expect(brid.baseDefence, 132774 - 123471);

      brid.option.coreLevel = 9;
      expect(brid.baseHp, 19921125 - 18493957);
      expect(brid.baseAttack, 873013 - 821520);
      expect(brid.baseDefence, 132774 - 123299);

      brid.option.coreLevel = 10;
      expect(brid.baseHp, 19921125 - 18468009);
      expect(brid.baseAttack, 873013 - 820584);
      expect(brid.baseDefence, 132774 - 123126);

      brid.option.coreLevel = 11;
      expect(brid.baseHp, 19921125 - 18442060);
      expect(brid.baseAttack, 873013 - 819647);
      expect(brid.baseDefence, 132774 - 122954);
    });

    test('Yarou Scarlet ammo rounding test', () {
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
            equipLines: [EquipLine(EquipLineType.statAmmo, 11)],
          ),
          EquipmentOption(
            type: EquipType.body,
            equipClass: NikkeClass.attacker,
            rarity: EquipRarity.t10,
            level: 5,
            equipLines: [EquipLine(EquipLineType.statAmmo, 5)],
          ),
          EquipmentOption(
            type: EquipType.arm,
            equipClass: NikkeClass.attacker,
            rarity: EquipRarity.t10,
            level: 5,
            equipLines: [EquipLine(EquipLineType.statAmmo, 11)],
          ),
          EquipmentOption(
            type: EquipType.leg,
            equipClass: NikkeClass.attacker,
            rarity: EquipRarity.t10,
            level: 5,
            equipLines: [EquipLine(EquipLineType.statAmmo, 5)],
          ),
        ],
      );
      final simulation = BattleSimulation(
        playerOptions: PlayerOptions(),
        nikkeOptions: [scarletOption],
        raptureOptions: [BattleRaptureOptions(startDistance: 30, element: NikkeElement.water, startDefence: 100)],
        advancedOption: BattleAdvancedOption(maxSeconds: 1),
      );

      simulation.simulate();

      final scarlet = simulation.nonnullNikkes.first;
      expect(scarlet.getMaxAmmo(simulation), 66);
    });
  });

  group('Fire rate test', () {
    test('Nero as SMG', () {
      final simulation = BattleSimulation(
        playerOptions: PlayerOptions(),
        nikkeOptions: [NikkeOptions(nikkeResourceId: 380)],
        raptureOptions: [BattleRaptureOptions(startDistance: 30, element: NikkeElement.water, startDefence: 100)],
        advancedOption: BattleAdvancedOption(maxSeconds: 2),
      );

      simulation.init();
      int shootCounter = 0;
      final expectedShootFrames = List.generate(24, (idx) {
        return 8 + (idx % 2 == 0 ? 5 * idx ~/ 2 : 5 * (idx - 1) ~/ 2 + 3);
      });
      for (int i = 0; i < 67; i += 1) {
        // add 8 for nero's spotFirstDelay
        final frame = simulation.currentFrame;
        simulation.proceedOneFrame();
        for (final event in simulation.timeline[frame] ?? []) {
          if (event is NikkeFireEvent) {
            shootCounter += 1;
            expect(frame, simulation.maxFrames - expectedShootFrames.removeAt(0));
          }
        }
      }
      expect(shootCounter, 24);
    });

    test('Tove as AR', () {
      final simulation = BattleSimulation(
        playerOptions: PlayerOptions(),
        nikkeOptions: [NikkeOptions(nikkeResourceId: 192)],
        raptureOptions: [BattleRaptureOptions(startDistance: 30, element: NikkeElement.water, startDefence: 100)],
        advancedOption: BattleAdvancedOption(maxSeconds: 2),
      );

      simulation.init();
      int shootCounter = 0;
      final expectedShootFrames = List.generate(12, (idx) {
        return 20 + idx * 5;
      });
      for (int i = 0; i < 76; i += 1) {
        // add 20 for tove's spotFirstDelay
        final frame = simulation.currentFrame;
        simulation.proceedOneFrame();
        for (final event in simulation.timeline[frame] ?? []) {
          if (event is NikkeFireEvent) {
            shootCounter += 1;
            expect(frame, simulation.maxFrames - expectedShootFrames.removeAt(0));
          }
        }
      }
      expect(shootCounter, 12);
    });

    test('Pepper as SG', () {
      final simulation = BattleSimulation(
        playerOptions: PlayerOptions(),
        nikkeOptions: [NikkeOptions(nikkeResourceId: 131)],
        raptureOptions: [BattleRaptureOptions(startDistance: 30, element: NikkeElement.water, startDefence: 100)],
        advancedOption: BattleAdvancedOption(maxSeconds: 2),
      );

      simulation.init();
      int shootCounter = 0;
      final expectedShootFrames = List.generate(3, (idx) {
        return 12 + idx * 40;
      });
      for (int i = 0; i < 93; i += 1) {
        // add 20 for tove's spotFirstDelay
        final frame = simulation.currentFrame;
        simulation.proceedOneFrame();
        for (final event in simulation.timeline[frame] ?? []) {
          if (event is NikkeFireEvent) {
            shootCounter += 1;
            expect(frame, simulation.maxFrames - expectedShootFrames.removeAt(0));
          }
        }
      }
      expect(shootCounter, 3);
    });
  });

  group('Cindy', () {
    test('Weapon Mechanism', () {
      final simulation = BattleSimulation(
        playerOptions: PlayerOptions(),
        nikkeOptions: [NikkeOptions(nikkeResourceId: 511)],
        raptureOptions: [Const.trainingWaterTarget],
      );
      simulation.init();
      final expectedShootFrame = 12 + 59; // 12 exit 59 charging
      simulation.proceedNFrames(expectedShootFrame);
      final firstShot = simulation.timeline[simulation.previousFrame]?.whereType<NikkeFireEvent>().toList();
      expect(firstShot, isNotNull);
      expect(firstShot, isNotEmpty);

      final nextShotFrame = (60 * simulation.fps / 180).round(); // 180 is Cindy's fire rate
      simulation.proceedNFrames(nextShotFrame);
      final secondShot = simulation.timeline[simulation.previousFrame]?.whereType<NikkeFireEvent>().toList();
      expect(secondShot, isNotNull);
      expect(secondShot, isNotEmpty);

      final finalShotFrame = nextShotFrame * 22; // cindy default ammo is 24
      simulation.proceedNFrames(finalShotFrame);
      final finalShot = simulation.timeline[simulation.previousFrame]?.whereType<NikkeFireEvent>().toList();
      expect(finalShot, isNotNull);
      expect(finalShot, isNotEmpty);
      expect(simulation.nonnullNikkes.first.totalBulletsFired, 24);

      final secondClipFirstShotFrame = 12 + 120 + 12 + 59; // enter cover + reload + exit cover + charging
      simulation.proceedNFrames(secondClipFirstShotFrame);
      final secondClipFirstShot = simulation.timeline[simulation.previousFrame]?.whereType<NikkeFireEvent>().toList();
      expect(secondClipFirstShot, isNotNull);
      expect(secondClipFirstShot, isNotEmpty);
      expect(simulation.nonnullNikkes.first.totalBulletsFired, 25);
    });

    // test damage & burst
    test('Damage Test', () {
      final syncLv = 920;
      final simulation = BattleSimulation(
        playerOptions: PlayerOptions(
          personalRecycleLevel: 440,
          corpRecycleLevels: {
            Corporation.pilgrim: 440,
            Corporation.missilis: 216,
            Corporation.abnormal: 185,
            Corporation.tetra: 248,
            Corporation.elysion: 227,
          },
          classRecycleLevels: {NikkeClass.attacker: 243, NikkeClass.supporter: 216, NikkeClass.defender: 216},
        ),
        nikkeOptions: [
          Const.liter..syncLevel = syncLv,
          Const.cindy
            ..syncLevel = syncLv
            ..cube = HarmonyCubeOption.fromType(HarmonyCubeType.gainAmmo, 15),
          Const.helm
            ..syncLevel = syncLv
            ..cube = HarmonyCubeOption.fromType(HarmonyCubeType.reload, 15),
          Const.crown
            ..syncLevel = syncLv
            ..cube = HarmonyCubeOption.fromType(HarmonyCubeType.reload, 15),
        ],
        raptureOptions: [Const.shootingRangeWaterBoss],
      );

      simulation.init();
      final cindyId = 2;
      final cindy = simulation.getEntityById(cindyId)!;
      expect(cindy.getMaxHp(simulation), 27172647);
      expect(cindy.currentHp, 27172647);
      expect(cindy.baseAttack, 664275);
      expect(cindy.baseDefence, 178253);
      final expectedShootFrame = 12 + 59 - 4; // 12 exit 59 charging - 4 due to equip line
      simulation.proceedNFrames(expectedShootFrame);
      final firstShotDamageEvents =
          simulation.timeline[simulation.previousFrame]
              ?.whereType<NikkeDamageEvent>()
              .where((event) => event.activatorId == cindyId)
              .toList();
      expect(firstShotDamageEvents, isNotNull);
      expect(firstShotDamageEvents!.length, 2);
      final firstShot = firstShotDamageEvents.first;
      final firstS1 = firstShotDamageEvents.last;
      expect(firstShot.source, Source.bullet);
      expect(firstShot.damageParameter.calculateDamage(core: true), moreOrLessEquals(1690317, epsilon: 5));
      expect(firstS1.source, Source.skill1);
      expect(firstS1.damageParameter.calculateDamage(), moreOrLessEquals(1642191, epsilon: 3));

      List<NikkeDamageEvent>? cindyBurstDmg;
      while ((cindyBurstDmg?.isEmpty ?? true) && simulation.currentFrame > 0) {
        simulation.proceedOneFrame();
        final events = simulation.timeline[simulation.previousFrame];
        cindyBurstDmg =
            events
                ?.whereType<NikkeDamageEvent>()
                .where((event) => event.activatorId == cindyId && event.source == Source.burst)
                .toList();
      }
      expect(cindy.getMaxHp(simulation), 27607409);
      expect(cindyBurstDmg, isNotNull);
      expect(cindyBurstDmg!.length, 2);
      expect(cindyBurstDmg.first.damageParameter.calculateDamage(), moreOrLessEquals(58715278, epsilon: 3));
      expect(cindyBurstDmg.last.damageParameter.calculateDamage(), moreOrLessEquals(2637622, epsilon: 3));

      for (int count = 2; count <= 10; count += 1) {
        simulation.proceedNFrames(12); // each cindy burst is 12 frames apart
        final events = simulation.timeline[simulation.previousFrame];
        cindyBurstDmg =
            events
                ?.whereType<NikkeDamageEvent>()
                .where((event) => event.activatorId == cindyId && event.source == Source.burst)
                .toList();
        expect(cindyBurstDmg, isNotNull);
        expect(cindyBurstDmg!.length, 2);
        expect(cindyBurstDmg.first.damageParameter.calculateDamage(), moreOrLessEquals(58715278, epsilon: 3));
        final cindyMaxHp = cindy.getMaxHp(simulation);
        final expectedStackDamage = cindyMaxHp == 27607409 ? 2637622 : 2649826;
        expect(
          cindyBurstDmg.last.damageParameter.calculateDamage(),
          moreOrLessEquals(expectedStackDamage.toDouble(), epsilon: 3),
        );
      }

      cindyBurstDmg = null;
      while ((cindyBurstDmg?.isEmpty ?? true) && simulation.currentFrame > 0) {
        simulation.proceedOneFrame();
        final events = simulation.timeline[simulation.previousFrame];
        cindyBurstDmg =
            events
                ?.whereType<NikkeDamageEvent>()
                .where((event) => event.activatorId == cindyId && event.source == Source.burst)
                .toList();
      }
      expect(cindy.getMaxHp(simulation), 32389795); // max stack
      expect(cindyBurstDmg, isNotNull);
      expect(cindyBurstDmg!.length, 2);
      expect(cindyBurstDmg.first.damageParameter.calculateDamage(), moreOrLessEquals(64963951, epsilon: 5));
      expect(cindyBurstDmg.last.damageParameter.calculateDamage(), moreOrLessEquals(34453045, epsilon: 3));
    });
  });

  group('Summer Anis', () {
    test('LastAmmoUse', () {
      final simulation = BattleSimulation(
        playerOptions: PlayerOptions(),
        nikkeOptions: [
          NikkeOptions(nikkeResourceId: 15)..cube = HarmonyCubeOption.fromType(HarmonyCubeType.gainAmmo, 1),
        ],
        raptureOptions: [Const.trainingWaterTarget],
      );

      final anisId = 1;
      simulation.init();
      simulation.proceedNFrames(12 + 40 * 4 + 1); // exit cover, five shots, to reload event
      final anisSkillDmg =
          simulation.timeline[simulation.previousFrame]
              ?.whereType<NikkeDamageEvent>()
              .where((event) => event.activatorId == anisId && event.source == Source.skill2)
              .toList();
      expect(anisSkillDmg, isNotNull);

      simulation.proceedNFrames(
        12 + 120 + 12 + 40 * 5 + 1,
      ); // enter cover, reload, exit cover, six shots due to cube, to reload event
      final anisSkill2Dmg =
          simulation.timeline[simulation.previousFrame]
              ?.whereType<NikkeDamageEvent>()
              .where((event) => event.activatorId == anisId && event.source == Source.skill2)
              .toList();
      expect(anisSkill2Dmg, isNotNull);
    });

    test('IsSearchElement', () {
      final simulation = BattleSimulation(
        playerOptions: PlayerOptions(),
        nikkeOptions: [NikkeOptions(nikkeResourceId: 15), Const.liter, Const.crown, Const.helm],
        raptureOptions: [Const.trainingWaterTarget],
      );

      simulation.init();
      while (simulation.burstStage != 4 && simulation.currentFrame > 0) {
        simulation.proceedOneFrame();
      }
      final anis = simulation.getEntityById(1)!;
      expect(anis.buffs.where((buff) => buff.data.groupId == 2015101), isNotEmpty);
      final helm = simulation.getEntityById(4)!;
      expect(helm.buffs.where((buff) => buff.data.groupId == 2015101), isEmpty);
    });
  });

  group('Rouge', () {
    test('checkPosition fail on pos1', () {
      final simulation = BattleSimulation(
        playerOptions: PlayerOptions(),
        nikkeOptions: [NikkeOptions(nikkeResourceId: 272), Const.liter, Const.crown],
        raptureOptions: [Const.trainingWaterTarget],
      );
      simulation.init();

      final rouge = simulation.battleNikkes.first!;
      final liter = simulation.battleNikkes[1]!;
      expect(rouge.buffs.where((buff) => buff.buffGiverId == rouge.uniqueId && buff.source == Source.skill2), isEmpty);
      expect(liter.buffs.where((buff) => buff.buffGiverId == rouge.uniqueId && buff.source == Source.skill2), isEmpty);
    });

    test('checkPosition success on pos4', () {
      final simulation = BattleSimulation(
        playerOptions: PlayerOptions(),
        nikkeOptions: [Const.liter, Const.crown, Const.helm, NikkeOptions(nikkeResourceId: 272)],
        raptureOptions: [Const.trainingWaterTarget],
      );
      simulation.init();

      final rouge = simulation.battleNikkes[3]!;
      final helm = simulation.battleNikkes[2]!;
      expect(
        rouge.buffs.where((buff) => buff.buffGiverId == rouge.uniqueId && buff.source == Source.skill2),
        isNotEmpty,
      );
      expect(
        helm.buffs.where((buff) => buff.buffGiverId == rouge.uniqueId && buff.source == Source.skill2),
        isNotEmpty,
      );
    });
  });
}
