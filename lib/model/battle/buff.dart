import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/skills.dart';

class BattleBuff {
  final FunctionData data;
  final int activatorPosition;
  final int triggerPosition;
  final int ownerPosition;

  // TODO: deduct duration
  int duration = 0;
  int count = 0;

  BattleBuff(this.data, this.activatorPosition, this.triggerPosition, this.ownerPosition) {
    duration = data.durationValue;
    count = 1;
  }

  bool isActive(BattleSimulation simulation) {
    return checkDuration(simulation) &&
        checkStatusTrigger(simulation, data.statusTriggerType, data.statusTriggerStandard, data.statusTriggerValue) &&
        checkStatusTrigger(simulation, data.statusTrigger2Type, data.statusTrigger2Standard, data.statusTrigger2Value);
  }

  bool checkDuration(BattleSimulation simulation) {
    switch (data.durationType) {
      case DurationType.none:
      case DurationType.battles:
      case DurationType.timeSecBattles:
        return true;
      case DurationType.timeSec:
      case DurationType.shots:
      case DurationType.hits:
        return duration > 0;
      case DurationType.unknown:
        return false;
    }
  }

  bool checkStatusTrigger(BattleSimulation simulation, StatusTriggerType type, StandardType standard, int value) {
    switch (type) {
      case StatusTriggerType.none:
        return true;
      case StatusTriggerType.unknown:
      case StatusTriggerType.isAlive:
      case StatusTriggerType.isAmmoCount:
      case StatusTriggerType.isBurstMember:
      case StatusTriggerType.isBurstStepState:
      case StatusTriggerType.isCharacter:
      case StatusTriggerType.isCheckFunctionOverlapUp:
      case StatusTriggerType.isCheckMonster:
      case StatusTriggerType.isCheckMonsterType:
      case StatusTriggerType.isCheckPartsId:
      case StatusTriggerType.isCheckPosition:
      case StatusTriggerType.isCheckTarget:
      case StatusTriggerType.isCheckTeamBurstNextStep:
      case StatusTriggerType.isClassType:
      case StatusTriggerType.isCover:
      case StatusTriggerType.isExplosiveCircuitOff:
      case StatusTriggerType.isFullCharge:
      case StatusTriggerType.isFullCount:
      case StatusTriggerType.isFunctionBuffCheck:
      case StatusTriggerType.isFunctionOff:
      case StatusTriggerType.isFunctionOn:
      case StatusTriggerType.isFunctionTypeOffCheck:
      case StatusTriggerType.isHaveBarrier:
      case StatusTriggerType.isHaveDecoy:
      case StatusTriggerType.isHpRatioUnder:
      case StatusTriggerType.isHpRatioUp:
      case StatusTriggerType.isNotBurstMember:
      case StatusTriggerType.isNotCheckTeamBurstNextStep:
      case StatusTriggerType.isNotHaveBarrier:
      case StatusTriggerType.isPhase:
      case StatusTriggerType.isSameSquadCount:
      case StatusTriggerType.isSameSquadUp:
      case StatusTriggerType.isSearchElementId:
      case StatusTriggerType.isStun:
      case StatusTriggerType.isWeaponType:
        return false;
    }
  }

  BattleNikke? getFunctionStandardTarget(BattleSimulation simulation) {
    switch (data.functionStandard) {
      case StandardType.user:
        return simulation.getNikkeOnPosition(activatorPosition);
      case StandardType.functionTarget:
        return simulation.getNikkeOnPosition(ownerPosition);
      case StandardType.triggerTarget:
        return simulation.getNikkeOnPosition(triggerPosition);
      case StandardType.unknown:
      case StandardType.none:
        return null;
    }
  }

  int getFunctionStandardTargetPosition(BattleSimulation simulation) {
    switch (data.functionStandard) {
      case StandardType.user:
        return activatorPosition;
      case StandardType.functionTarget:
        return ownerPosition;
      case StandardType.triggerTarget:
        return triggerPosition;
      case StandardType.unknown:
      case StandardType.none:
        return -1;
    }
  }
}
