import 'package:flutter_test/flutter_test.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/events/nikke_damage_event.dart';
import 'package:nikke_einkk/model/battle/function.dart';
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

  group('Status Trigger Tests verifications', () {
    test('test isCheckTeamBurstNextStep & isNotCheckTeamBurstNextStep', () {
      final simulation = BattleSimulation(
        playerOptions: PlayerOptions(),
        nikkeOptions: [Const.helm, Const.crown, Const.liter],
        raptureOptions: [Const.trainingWaterTarget],
        advancedOption: BattleAdvancedOption(maxSeconds: 3),
      );
      simulation.init();

      final helm = simulation.aliveNikkes.first;
      final liter = simulation.aliveNikkes[2];

      expect(simulation.burstStage, 0);
      bool result = BattleFunction.checkStatusTrigger(
        simulation,
        helm,
        StatusTriggerType.isCheckTeamBurstNextStep,
        1,
        null,
        0,
      );
      expect(result, isTrue);
      result = BattleFunction.checkStatusTrigger(
        simulation,
        helm,
        StatusTriggerType.isNotCheckTeamBurstNextStep,
        1,
        null,
        0,
      );
      expect(result, isFalse);

      result = BattleFunction.checkStatusTrigger(
        simulation,
        liter,
        StatusTriggerType.isCheckTeamBurstNextStep,
        1,
        null,
        0,
      );
      expect(result, isFalse);
      result = BattleFunction.checkStatusTrigger(
        simulation,
        liter,
        StatusTriggerType.isNotCheckTeamBurstNextStep,
        1,
        null,
        0,
      );
      expect(result, isTrue);

      result = BattleFunction.checkStatusTrigger(
        simulation,
        helm,
        StatusTriggerType.isCheckTeamBurstNextStep,
        3,
        null,
        0,
      );
      expect(result, isFalse);
      result = BattleFunction.checkStatusTrigger(
        simulation,
        helm,
        StatusTriggerType.isNotCheckTeamBurstNextStep,
        3,
        null,
        0,
      );
      expect(result, isTrue);
    });
  });
}
