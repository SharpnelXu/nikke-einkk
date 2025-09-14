import 'package:collection/collection.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/buff.dart';
import 'package:nikke_einkk/model/battle/events/hp_change_event.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/skills.dart';

import 'events/buff_event.dart';

abstract class BattleEntity {
  int uniqueId = 0;
  int currentHp = 0;

  final List<BattleBuff> buffs = [];
  final Map<int, int> funcRatioTracker = {};

  String get name => 'Entity $uniqueId';
  int get baseAttack;
  int get baseDefence;
  int get baseHp;
  Set<NikkeElement> get baseElements => {NikkeElement.unknown};

  bool checkRatio(int groupId, int triggerValue) {
    int ratioTracker = funcRatioTracker[groupId] ?? 0;
    final ratioCheck = triggerValue >= 10000 || ratioTracker == 0 || ratioTracker >= 10000;
    if (ratioCheck) {
      ratioTracker %= 10000;
    }

    if (triggerValue < 10000 && triggerValue > 0) {
      funcRatioTracker[groupId] = ratioTracker + triggerValue;
    }

    return ratioCheck;
  }

  void changeHp(BattleSimulation simulation, int changeValue, [bool isHeal = false]) {
    currentHp = (currentHp + changeValue).clamp(1, getMaxHp(simulation));

    simulation.registerEvent(
      simulation.currentFrame,
      HpChangeEvent(
        uniqueId,
        changeAmount: changeValue,
        afterChangeHp: currentHp,
        maxHp: getMaxHp(simulation),
        isHeal: isHeal,
      ),
    );
  }

  int getFinalAttack(BattleSimulation simulation) {
    final maxHpReplace = getBuffValue(
      simulation,
      FunctionType.atkReplaceMaxHpRate,
      0,
      (entity) => entity.getMaxHp(simulation),
    );
    if (maxHpReplace > 0) {
      return maxHpReplace;
    }
    return baseAttack + getAttackBuffValues(simulation);
  }

  int getAttackBuffValues(BattleSimulation simulation) {
    final maxHpConversion = getBuffValue(
      simulation,
      FunctionType.atkChangeMaxHpRate,
      0,
      (entity) => entity.getMaxHp(simulation),
    );
    final hpLossConversion = getBuffValue(
      simulation,
      FunctionType.atkChangHpRate,
      0,
      (entity) => entity.baseAttack * (1 - entity.currentHp / entity.getMaxHp(simulation)).clamp(0, 1) * 100,
    );

    final highestAllyAttack = simulation.aliveNikkes.sorted((a, b) => b.baseAttack - a.baseAttack).first;
    final copyAttack = toModifier(getPlainBuffValues(simulation, FunctionType.copyAtk)) * highestAllyAttack.baseAttack;

    final statAttack = getBuffValue(simulation, FunctionType.statAtk, 0, (entity) => entity.baseAttack);
    return statAttack + maxHpConversion + hpLossConversion + copyAttack.round();
  }

  int getFinalDefence(BattleSimulation simulation) {
    return baseDefence + getDefenceBuffValues(simulation);
  }

  int getDefenceBuffValues(BattleSimulation simulation) {
    final hpLossConversion = getBuffValue(
      simulation,
      FunctionType.defChangHpRate,
      0,
      (entity) => entity.baseDefence * (1 - entity.currentHp / entity.getMaxHp(simulation)).clamp(0, 1) * 100,
    );
    final statDef = getBuffValue(simulation, FunctionType.statDef, 0, (entity) => entity.baseDefence);

    return statDef + hpLossConversion;
  }

  int getMaxHp(BattleSimulation simulation) {
    final highestAllyHp = simulation.aliveNikkes.sorted((a, b) => b.baseHp - a.baseHp).first;
    final copyHp = toModifier(getPlainBuffValues(simulation, FunctionType.copyHp)) * highestAllyHp.baseHp;

    final statHp = getBuffValueOfTypes(
      simulation,
      [FunctionType.statHp, FunctionType.statHpHeal],
      baseHp,
      (entity) => entity.baseHp,
    );

    return statHp + copyHp.round();
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

  int getDurationDamageRatioBuffValues(BattleSimulation simulation) {
    return getPlainBuffValues(simulation, FunctionType.durationDamageRatio);
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

  int? getFirstPlainBuffValues(BattleSimulation simulation, FunctionType type) {
    for (final buff in buffs) {
      if (buff.data.functionType == type) {
        return buff.data.functionValue * buff.count;
      }
    }
    return null;
  }

  int getBuffValue(
    BattleSimulation simulation,
    FunctionType type,
    int baseValue,
    num Function(BattleEntity) getStandardBaseValue,
  ) {
    return getBuffValueOfTypes(simulation, [type], baseValue, getStandardBaseValue);
  }

  int getBuffValueOfTypes(
    BattleSimulation simulation,
    List<FunctionType> types,
    int baseValue,
    num Function(BattleEntity) getStandardBaseValue,
  ) {
    // position to group Id to percentValues
    final Map<int, Map<int, int>> percents = {};

    // might need to group by buffType (buff & buffEtc) and round separately
    int flatValue = 0;
    for (final buff in buffs) {
      if (!types.contains(buff.data.functionType)) continue;

      if (buff.data.functionValueType == ValueType.percent) {
        final standardUniqueId = buff.getFunctionStandardId();
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
      final standard = simulation.getEntityById(standardUniqueId);
      if (standard != null) {
        for (final buffGroup in percents[standardUniqueId]!.keys) {
          final percent = percents[standardUniqueId]![buffGroup]!;
          result += (getStandardBaseValue(standard) * toModifier(percent)).round();
        }
      }
    }

    return result;
  }

  bool hasChangeNormalDefIgnoreDamage(BattleSimulation simulation) {
    return hasBuff(simulation, FunctionType.changeNormalDefIgnoreDamage);
  }

  bool hasBuff(BattleSimulation simulation, FunctionType type) {
    return buffs.any((buff) => buff.data.functionType == type);
  }

  void normalAction(BattleSimulation simulation) {
    for (final buff in buffs) {
      final data = buff.data;
      if (data.durationType.isTimed) {
        buff.duration -= 1;
      }

      if (data.functionType == FunctionType.changeCurrentHpValue && data.durationType.isDurationBuff) {
        final activeFrame = data.durationValue > 0 && (buff.fullDuration - buff.duration) % simulation.fps == 0;
        if (activeFrame) {
          if (data.functionValueType == ValueType.integer) {
            changeHp(simulation, data.functionValue);
          } else if (data.functionValueType == ValueType.percent) {
            final functionStandard = simulation.getEntityById(buff.getFunctionStandardId());
            if (functionStandard != null) {
              final changeValue = toModifier(data.functionValue) * functionStandard.currentHp;
              changeHp(simulation, changeValue.round());
            }
          }
        }
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

    final removedBuffs =
        buffs.where((buff) => buff.shouldRemove(simulation) || removeBuffGroupIds.contains(buff.data.groupId)).toList();
    for (final buff in removedBuffs) {
      buffs.remove(buff);
      simulation.registerEvent(simulation.nextFrame, BuffEvent.remove(buff));
    }

    final afterMaxHp = getMaxHp(simulation);
    if (previousMaxHp != afterMaxHp) {
      simulation.registerEvent(
        simulation.nextFrame,
        HpChangeEvent(
          uniqueId,
          changeAmount: afterMaxHp - previousMaxHp,
          afterChangeHp: currentHp,
          maxHp: getMaxHp(simulation),
          isMaxHpOnly: true,
        ),
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

  int getDamageValueChange(BattleSimulation simulation, int baseValue, int groupId) {
    int result = 0;
    for (final buff in buffs) {
      if (buff.data.functionType == FunctionType.damageFunctionValueChange && buff.targetGroupId == groupId) {
        if (buff.data.functionValueType == ValueType.integer) {
          result += buff.data.functionValue;
        } else if (buff.data.functionValueType == ValueType.percent) {
          result += (baseValue * toModifier(buff.data.functionValue)).round();
        }
      }
    }
    return result;
  }

  Set<NikkeElement> getEffectiveElements() {
    final Set<NikkeElement> result = {...baseElements};
    for (final buff in buffs) {
      if (buff.data.functionType == FunctionType.addIncElementDmgType) {
        final element = NikkeElement.fromId(buff.data.functionValue);
        if (element != NikkeElement.unknown) {
          result.add(element);
        }
      }
    }

    return result;
  }
}
