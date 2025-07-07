import 'package:flutter/cupertino.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/buff.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';
import 'package:nikke_einkk/model/skills.dart';

class BuffEvent extends BattleEvent {
  late FunctionData data;
  late String giverName;
  late int buffGiverUniqueId;
  late String receiverName;
  late int buffReceiverUniqueId;
  late int buffCount;

  BuffEvent(BattleSimulation simulation, BattleBuff buff) {
    data = buff.data;
    buffGiverUniqueId = buff.buffGiverUniqueId;
    giverName = simulation.getEntityByUniqueId(buffGiverUniqueId)!.name;
    buffReceiverUniqueId = buff.buffReceiverUniqueId;
    receiverName = simulation.getEntityByUniqueId(buffReceiverUniqueId)!.name;
    buffCount = buff.count;
  }

  @override
  int getActivatorUniqueId() {
    return buffGiverUniqueId;
  }

  @override
  List<int> getTargetUniqueIds() {
    return [buffReceiverUniqueId];
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
