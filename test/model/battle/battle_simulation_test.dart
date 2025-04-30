import 'package:flutter_test/flutter_test.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/common.dart';

import '../../test_helper.dart';

void main() async {
  await TestHelper.loadData();

  group('Nikke Simulation Test', () {
    test('Scarlet resourceId 222', () {
      final simulation = BattleSimulationData(
        playerOptions: BattlePlayerOptions(
          personalRecycleLevel: 400,
          corpRecycleLevels: {Corporation.pilgrim: 400},
          classRecycleLevels: {NikkeClass.attacker: 400},
        ),
        nikkeOptions: [
          BattleNikkeOptions(
            nikkeResourceId: 222,
            coreLevel: 11,
            syncLevel: 901,
            attractLevel: 40,
          )
        ],
      );

      simulation.raptures.add(BattleRaptureData());
      simulation.maxSeconds = 30;
      simulation.simulate();

      expect(simulation.timeline[1788]!.length, 2); //  first bullet
      expect(simulation.timeline[1783]!.length, 2); //  second bullet
      expect(simulation.timeline[1693]!.length, 2); //  last (20th) bullet
      expect(simulation.timeline[1692]!.length, 1); //  reload start
      expect(simulation.timeline[1530]!.length, 2); //  first bullet of second magazine
    });
  });
}
