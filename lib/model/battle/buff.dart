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

  List<int> getFunctionStandardUniqueIds() {
    final List<int> result = [];
    switch (data.functionStandard) {
      case StandardType.user:
        result.add(buffGiverUniqueId);
        break;
      case StandardType.functionTarget:
        result.add(buffReceiverUniqueId);
        break;
      case StandardType.triggerTarget: // there is no triggerTarget in functionStandardType
      case StandardType.unknown:
      case StandardType.none:
        break;
    }
    return result;
  }
}
