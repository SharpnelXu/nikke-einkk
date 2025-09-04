import 'package:nikke_einkk/model/battle/battle_entity.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/function.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/skills.dart';

class BattleBuff {
  int buffGiverId;
  int buffReceiverId;
  FunctionData data;
  Source source;

  int targetGroupId = 0;
  int fullDuration = 0;
  int duration = 0;
  int count = 1;

  BattleBuff._({
    required this.data,
    required this.buffGiverId,
    required this.buffReceiverId,
    required this.source,
    this.duration = 0,
    this.targetGroupId = 0,
  }) : fullDuration = duration;

  factory BattleBuff.create({
    required FunctionData data,
    required int buffGiverUniqueId,
    required int buffReceiverUniqueId,
    required Source source,
    required BattleSimulation simulation,
    int? targetGroupId,
  }) {
    final duration =
        data.durationType.isTimed ? timeDataToFrame(data.durationValue, simulation.fps) : data.durationValue;
    return BattleBuff._(
      data: data,
      buffGiverId: buffGiverUniqueId,
      buffReceiverId: buffReceiverUniqueId,
      source: source,
      duration: duration,
      targetGroupId: targetGroupId ?? 0,
    );
  }

  bool shouldRemove(BattleSimulation simulation) {
    switch (data.durationType) {
      case DurationType.none:
      case DurationType.timeSecBattles:
        return false;
      case DurationType.battles:
        // added for Alice S2 (continuous penetration if hp above threshold)
        return !BattleFunction.checkStatusTrigger(
              simulation,
              getStatusTriggerStandardTarget(simulation, data.statusTriggerStandard),
              data.statusTriggerType,
              data.statusTriggerValue,
              getStatusTriggerStandardTarget(simulation, data.statusTrigger2Standard),
              data.statusTrigger2Value,
            ) ||
            !BattleFunction.checkStatusTrigger(
              simulation,
              getStatusTriggerStandardTarget(simulation, data.statusTrigger2Standard),
              data.statusTrigger2Type,
              data.statusTrigger2Value,
              getStatusTriggerStandardTarget(simulation, data.statusTriggerStandard),
              data.statusTriggerValue,
            );
      case DurationType.timeSec:
      case DurationType.timeSecVer2:
      case DurationType.shots:
      case DurationType.hits:
      case DurationType.hitsVer2:
        return duration <= 0;
      case DurationType.unknown:
      case DurationType.reloadAllAmmoCount:
        return true;
    }
  }

  BattleEntity? getStatusTriggerStandardTarget(BattleSimulation simulation, StandardType standardType) {
    switch (standardType) {
      case StandardType.user:
        return simulation.getEntityById(buffGiverId);
      case StandardType.functionTarget:
        return simulation.getEntityById(buffReceiverId);
      case StandardType.triggerTarget:
      case StandardType.none:
      case StandardType.unknown:
        return null;
    }
  }

  int getFunctionStandardId() {
    switch (data.functionStandard) {
      case StandardType.user:
        return buffGiverId;
      case StandardType.functionTarget:
        return buffReceiverId;
      case StandardType.triggerTarget: // there is no triggerTarget in functionStandardType
      case StandardType.unknown:
      case StandardType.none:
        return -1;
    }
  }

  @override
  String toString() {
    return '[$count] ${data.functionType.name} ${data.functionValue} ${data.functionValueType.name}';
  }
}
