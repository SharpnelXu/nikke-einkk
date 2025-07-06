import 'package:flutter_test/flutter_test.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/equipment.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/items.dart';
import 'package:nikke_einkk/model/user_data.dart';

import '../../test_helper.dart';

void main() async {
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
      );

      simulation.maxSeconds = 1;
      simulation.simulate();

      final scarlet = simulation.nonnullNikkes.first;
      expect(scarlet.getMaxAmmo(simulation), 66);
    });
  });
}
