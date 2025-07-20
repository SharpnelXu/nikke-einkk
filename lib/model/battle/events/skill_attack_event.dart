import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';
import 'package:nikke_einkk/model/battle/function.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/module/common/custom_table.dart';

class SkillAttackEvent extends BattleEvent {
  final SkillData skillData;
  final Source source;

  SkillAttackEvent._(super.activatorId, super.targetIds, this.skillData, this.source);

  int get targetId => targetIds.first;

  factory SkillAttackEvent.create(int activatorId, int targetId, SkillData skillData, Source source) {
    return SkillAttackEvent._(activatorId, [targetId], skillData, source);
  }

  @override
  void processNikke(BattleSimulation simulation, BattleNikke nikke) {
    if (nikke.uniqueId == activatorId) {
      for (final beforeFuncId in [...skillData.beforeHurtFunctionIdList, ...skillData.afterHurtFunctionIdList]) {
        final functionData = simulation.db.functionTable[beforeFuncId];
        if (functionData != null) {
          final function = BattleFunction(functionData, activatorId, source);
          // connected function likely doesn't check trigger target
          function.executeFunction(this, simulation);
        }
      }
    }
  }

  @override
  Widget buildDisplayV2(BattleSimulation simulation) {
    final skillInfoData = simulation.db.skillInfoTable[skillData.id];
    final skillName = locale.getTranslation(skillInfoData?.nameLocalkey) ?? '${skillData.id}';
    return CustomTable(
      children: [
        CustomTableRow.fromTexts(texts: ['Skill Attack', 'Activator', 'Targets'], defaults: battleHeaderData),
        CustomTableRow.fromTexts(
          texts: [skillName, '${simulation.getEntityName(activatorId)}', '${simulation.getEntityName(targetId)}'],
        ),
      ],
    );
  }
}
