import 'package:flutter/cupertino.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';

class UseSkillEvent extends BattleEvent {
  late String name;
  final int skillId;
  final int ownerUniqueId;
  final int skillGroup;
  final int skillNum;
  final List<int> skillTargetUniqueIds = [];

  UseSkillEvent(
    BattleSimulation simulation,
    this.skillId,
    this.ownerUniqueId,
    this.skillGroup,
    this.skillNum,
    List<int> targetUniqueIds,
  ) {
    name = simulation.getEntityById(ownerUniqueId)!.name;
    skillTargetUniqueIds.addAll(targetUniqueIds);
  }

  @override
  int getActivatorId() {
    return ownerUniqueId;
  }

  @override
  List<int> getTargetIds() {
    return skillTargetUniqueIds;
  }

  @override
  Widget buildDisplay() {
    // final skillName =
    //     dbLegacy.getTranslation(dbLegacy.skillInfoTable[skillId]?.nameLocalkey)?.zhCN ?? 'Skill $skillNum';
    return Text('$name (Pos $ownerUniqueId) activates skillName');
  }
}
