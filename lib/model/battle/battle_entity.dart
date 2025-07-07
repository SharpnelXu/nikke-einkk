import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/buff.dart';
import 'package:nikke_einkk/model/battle/events/hp_change_event.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/skills.dart';

abstract class BattleEntity {
  int uniqueId = 0;
  int currentHp = 0;

  final List<BattleBuff> buffs = [];

  String get name => 'Entity $uniqueId';
  int get baseAttack;
  int get baseDefence;
  int get baseHp;

  NikkeElement get element => NikkeElement.unknown;

  void changeHp(BattleSimulation simulation, int changeValue, [bool isHeal = false]) {
    currentHp = (currentHp + changeValue).clamp(1, getMaxHp(simulation));

    simulation.registerEvent(simulation.currentFrame, HpChangeEvent(simulation, this, changeValue, isHeal: isHeal));
  }

  int getAttackBuffValues(BattleSimulation simulation) {
    return getBuffValue(simulation, FunctionType.statAtk, 0, (entity) => entity.baseAttack);
  }

  int getDefenceBuffValues(BattleSimulation simulation) {
    return getBuffValue(simulation, FunctionType.statDef, 0, (entity) => entity.baseDefence);
  }

  int getMaxHp(BattleSimulation simulation) {
    return getBuffValueOfTypes(
      simulation,
      [FunctionType.statHp, FunctionType.statHpHeal],
      baseHp,
      (entity) => entity.baseHp,
    );
  }

  int getHealVariation(BattleSimulation simulation) {
    return getPlainBuffValues(simulation, FunctionType.healVariation);
  }

  int getAddDamageBuffValues(BattleSimulation simulation) {
    return getPlainBuffValues(simulation, FunctionType.addDamage);
  }

  int getDrainHpBuff(BattleSimulation simulation) {
    return getPlainBuffValues(simulation, FunctionType.drainHpBuff);
  }

  int getIncreaseElementDamageBuffValues(BattleSimulation simulation) {
    // not sure if function standard does anything here, coule be the base ele rate is 10000 for all in data
    return getPlainBuffValues(simulation, FunctionType.incElementDmg);
  }

  int getCriticalDamageBuffValues(BattleSimulation simulation) {
    return getPlainBuffValues(simulation, FunctionType.statCriticalDamage);
  }

  int getGivingHealVariationBuffValues(BattleSimulation simulation) {
    return getPlainBuffValues(simulation, FunctionType.givingHealVariation);
  }

  int getDamageReductionBuffValues(BattleSimulation simulation) {
    return getPlainBuffValues(simulation, FunctionType.damageReduction);
  }

  int getPlainBuffValues(BattleSimulation simulation, FunctionType type) {
    int result = 0;
    for (final buff in buffs) {
      if (buff.data.functionType != type) continue;
      // all valueType is fixed and doesn't make sense to depend on user
      result += buff.data.functionValue * buff.count;
    }

    return result;
  }

  int getBuffValue(
    BattleSimulation simulation,
    FunctionType type,
    int baseValue,
    int Function(BattleEntity) getStandardBaseValue,
  ) {
    return getBuffValueOfTypes(simulation, [type], baseValue, getStandardBaseValue);
  }

  int getBuffValueOfTypes(
    BattleSimulation simulation,
    List<FunctionType> types,
    int baseValue,
    int Function(BattleEntity) getStandardBaseValue,
  ) {
    // position to group Id to percentValues
    final Map<int, Map<int, int>> percents = {};

    // might need to group by buffType (buff & buffEtc) and round separately
    int flatValue = 0;
    for (final buff in buffs) {
      if (!types.contains(buff.data.functionType)) continue;

      if (buff.data.functionValueType == ValueType.percent) {
        final standardUniqueId = buff.getFunctionStandardUniqueId();
        if (standardUniqueId != -1) {
          percents.putIfAbsent(standardUniqueId, () => {});
          final previousValue = percents[standardUniqueId]![buff.data.groupId] ?? 0;
          percents[standardUniqueId]![buff.data.groupId] = previousValue + buff.data.functionValue * buff.count;
        }
      } else if (buff.data.functionValueType == ValueType.integer) {
        flatValue += buff.data.functionValue;
      }
    }

    int result = baseValue + flatValue;
    for (final standardUniqueId in percents.keys) {
      final standard = simulation.getEntityByUniqueId(standardUniqueId);
      if (standard != null) {
        for (final buffType in percents[standardUniqueId]!.keys) {
          final percent = percents[standardUniqueId]![buffType]!;
          result += (getStandardBaseValue(standard) * toModifier(percent)).round();
        }
      }
    }

    return result;
  }

  void normalAction(BattleSimulation simulation) {
    for (final buff in buffs) {
      if (buff.data.durationType == DurationType.timeSec) {
        buff.duration -= 1;
      }
    }
  }

  void endCurrentFrame(BattleSimulation simulation) {
    final previousMaxHp = getMaxHp(simulation);

    final removeBuffGroupIds =
        buffs
            .where((buff) => buff.data.functionType == FunctionType.removeFunctionGroup)
            .map((buff) => buff.data.functionValue)
            .toList();

    buffs.removeWhere((buff) => buff.shouldRemove(simulation) || removeBuffGroupIds.contains(buff.data.groupId));

    final afterMaxHp = getMaxHp(simulation);
    if (previousMaxHp != afterMaxHp) {
      simulation.registerEvent(
        simulation.nextFrame,
        HpChangeEvent(simulation, this, afterMaxHp - previousMaxHp, isMaxHpOnly: true),
      );
    }
  }

  int getTimingTriggerValueChange(BattleSimulation simulation, int baseValue, int groupId) {
    int result = 0;
    for (final buff in buffs) {
      if (buff.data.functionType == FunctionType.timingTriggerValueChange && buff.targetGroupId == groupId) {
        if (buff.data.functionValueType == ValueType.integer) {
          result += buff.data.functionValue;
        } else if (buff.data.functionValueType == ValueType.percent) {
          result += (baseValue * toModifier(buff.data.functionValue)).round();
        }
      }
    }
    return result;
  }
}
