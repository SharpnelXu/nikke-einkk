import 'package:nikke_einkk/model/battle/battle_event.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/buff.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/skills.dart';

abstract class BattleEntity {
  int uniqueId = 0;
  int currentHp = 0;

  final List<BattleBuff> buffs = [];

  String get name => 'Entity $uniqueId';
  int get baseAttack;
  int get baseDefence;
  int get baseHp;

  void changeHp(BattleSimulation simulation, int changeValue) {
    currentHp = (currentHp + changeValue).clamp(1, getMaxHp(simulation));

    simulation.registerEvent(simulation.currentFrame, HpChangeEvent(simulation, this, changeValue));
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
    // position to percentValues
    final Map<int, Map<BuffType, int>> percents = {};

    // might need to group by buffType (buff & buffEtc) and round separately
    int flatValue = 0;
    for (final buff in buffs) {
      if (!types.contains(buff.data.functionType)) continue;

      if (buff.data.functionValueType == ValueType.percent) {
        final standardUniqueId = buff.getFunctionStandardUniqueId();
        if (standardUniqueId != -1) {
          percents.putIfAbsent(standardUniqueId, () => {});
          final previousValue = percents[standardUniqueId]![buff.data.buff] ?? 0;
          percents[standardUniqueId]![buff.data.buff] = previousValue + buff.data.functionValue * buff.count;
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
          result += (getStandardBaseValue(standard) * BattleUtils.toModifier(percent)).round();
        }
      }
    }

    return result;
  }
}
