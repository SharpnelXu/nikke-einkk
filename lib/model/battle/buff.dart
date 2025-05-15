import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/skills.dart';

class BattleBuff {
  int buffGiverUniqueId;
  int buffReceiverUniqueId;
  FunctionData data;

  int duration = 0;
  int count = 0;

  BattleBuff(this.data, this.buffGiverUniqueId, this.buffReceiverUniqueId) {
    duration = data.durationValue;
    count = 1;
  }

  bool shouldRemove(BattleSimulation simulation) {
    switch (data.durationType) {
      case DurationType.none:
      case DurationType.battles:
      case DurationType.timeSecBattles:
        return false;
      case DurationType.timeSec:
      case DurationType.shots:
      case DurationType.hits:
        return duration <= 0;
      case DurationType.unknown:
        return true;
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
