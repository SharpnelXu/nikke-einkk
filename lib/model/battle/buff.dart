import 'package:nikke_einkk/model/battle/battle_entity.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/function.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/skills.dart';

class BattleBuff {
  int buffGiverUniqueId;
  int buffReceiverUniqueId;
  FunctionData data;

  int duration = 0;
  int count = 0;

  BattleBuff(this.data, this.buffGiverUniqueId, this.buffReceiverUniqueId, BattleSimulation simulation) {
    duration =
        data.durationType == DurationType.timeSec
            ? BattleUtils.timeDataToFrame(data.durationValue, simulation.fps)
            : data.durationValue;
    count = 1;
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
            ) ||
            !BattleFunction.checkStatusTrigger(
              simulation,
              getStatusTriggerStandardTarget(simulation, data.statusTrigger2Standard),
              data.statusTrigger2Type,
              data.statusTrigger2Value,
            );
      case DurationType.timeSec:
      case DurationType.shots:
      case DurationType.hits:
        return duration <= 0;
      case DurationType.unknown:
        return true;
    }
  }

  BattleEntity? getStatusTriggerStandardTarget(BattleSimulation simulation, StandardType standardType) {
    switch (standardType) {
      case StandardType.user:
        return simulation.getEntityByUniqueId(buffGiverUniqueId);
      case StandardType.functionTarget:
        return simulation.getEntityByUniqueId(buffReceiverUniqueId);
      case StandardType.triggerTarget:
      case StandardType.none:
      case StandardType.unknown:
        return null;
    }
  }

  int getFunctionStandardUniqueId() {
    switch (data.functionStandard) {
      case StandardType.user:
        return buffGiverUniqueId;
      case StandardType.functionTarget:
        return buffReceiverUniqueId;
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
