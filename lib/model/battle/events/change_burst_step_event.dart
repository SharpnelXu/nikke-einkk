import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';
import 'package:nikke_einkk/module/common/custom_table.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';

class ChangeBurstStepEvent extends BattleEvent {
  final int currentStage;
  final int nextStage;
  final int duration;

  ChangeBurstStepEvent(super.activatorId, this.currentStage, this.nextStage, this.duration);

  @override
  Widget buildDisplayV2(BattleSimulation simulation) {
    return CustomTable(
      children: [
        CustomTableRow.fromTexts(
          texts: ['Burst Step', if (activatorId > 0) 'Activator', if (duration > 0) 'Duration'],
          defaults: battleHeaderData,
        ),
        CustomTableRow.fromTexts(
          texts: [
            'Step $currentStage → $nextStage',
            if (activatorId > 0) '${simulation.getEntityName(activatorId)}',
            if (duration > 0) duration.timeString,
          ],
        ),
      ],
    );
  }
}
