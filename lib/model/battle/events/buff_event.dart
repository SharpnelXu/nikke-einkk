import 'package:flutter/cupertino.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/buff.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';
import 'package:nikke_einkk/model/skills.dart';

class BuffEvent extends BattleEvent {
  late FunctionData data;
  late String giverName;
  late int buffGiverId;
  late String receiverName;
  late int buffReceiverId;
  late int buffCount;

  BuffEvent(BattleSimulation simulation, BattleBuff buff) {
    data = buff.data;
    buffGiverId = buff.buffGiverId;
    giverName = simulation.getEntityById(buffGiverId)!.name;
    buffReceiverId = buff.buffReceiverId;
    receiverName = simulation.getEntityById(buffReceiverId)!.name;
    buffCount = buff.count;
  }

  BuffEvent.temp(super.activatorId, super.targetIds, this.data, this.buffCount);

  factory BuffEvent.create(BattleSimulation simulation, BattleBuff buff) {
    // TODO: rethink what info is needed
    return BuffEvent(simulation, buff);
  }

  @override
  int getActivatorId() {
    return buffGiverId;
  }

  @override
  List<int> getTargetIds() {
    return [buffReceiverId];
  }

  @override
  Widget buildDisplayV2(BattleSimulation simulation) {
    return Text('$runtimeType');
  }

  @override
  Widget buildDisplay() {
    final valueString =
        data.functionValueType == ValueType.percent
            ? '${(data.functionValue / 100).toStringAsFixed(2)}%'
            : '${data.functionValue}';
    final funcString =
        '${data.functionType.name} $valueString (${data.functionStandard.name}) $buffCount/${data.fullCount}';
    // final skillName = dbLegacy.getTranslation(data.nameLocalkey)?.zhCN ?? 'Buff';
    return Text('Skill $funcString (to $receiverName by $giverName)');
  }
}
