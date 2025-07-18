import 'package:flutter/cupertino.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/module/common/custom_table.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';

class UseSkillEvent extends BattleEvent {
  final int skillId;
  final int skillGroup;
  final Source source;

  UseSkillEvent(super.activatorId, super.targetIds, this.skillId, this.skillGroup, this.source);

  @override
  Widget buildDisplayV2(BattleSimulation simulation) {
    final skillInfoData = simulation.db.skillInfoTable[skillId];
    final skillType = simulation.db.characterSkillTable[skillId]?.skillType;
    final skillName = locale.getTranslation(skillInfoData?.nameLocalkey) ?? '$skillId';
    return CustomTable(
      children: [
        CustomTableRow.fromTexts(
          texts: ['Skill Activated', 'Activator', 'Targets', 'Source'],
          defaults: battleHeaderData,
        ),
        CustomTableRow.fromTexts(
          texts: [
            '$skillName (${skillType?.name}: $skillGroup)',
            '${simulation.getEntityName(activatorId)}',
            targetIds.map((targetId) => simulation.getEntityName(targetId)).join(', '),
            source.name.pascal,
          ],
        ),
      ],
    );
  }
}
