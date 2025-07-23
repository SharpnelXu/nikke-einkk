import 'package:flutter_test/flutter_test.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/events/nikke_damage_event.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/model/user_data.dart';

import '../../test_helper.dart';

void main() {
  TestHelper.loadData();

  group('Function Tests', () {
    test('Full charge only counts bullets', () {
      final simulation = BattleSimulation(
        playerOptions: PlayerOptions(),
        nikkeOptions: [Const.helm],
        raptureOptions: [Const.trainingWaterTarget],
        advancedOption: BattleAdvancedOption(maxSeconds: 3),
      );
      simulation.init();

      // 12 frames leave cover + 59 frames to charge
      for (int i = 0; i < 71; i += 1) {
        simulation.proceedOneFrame();
      }

      final events = simulation.timeline[simulation.previousFrame];
      expect(events, isNotNull);
      final damageEvents = events!.whereType<NikkeDamageEvent>().toList();
      expect(damageEvents.length, 2);
      expect(damageEvents.first.source, Source.bullet);
      expect(damageEvents.last.source, Source.skill2);
    });
  });
}
