import 'package:flutter/cupertino.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/skills.dart';

class RaptureDamageEvent extends BattleEvent {
  late int attackerUniqueId;
  late int targetUniqueId;
  late String name;
  late NikkeDamageParameter damageParameter;
  late bool invalid;

  @override
  int getActivatorUniqueId() {
    return attackerUniqueId;
  }

  @override
  List<int> getTargetUniqueIds() {
    return [targetUniqueId];
  }

  RaptureDamageEvent({
    required BattleSimulation simulation,
    required BattleRapture rapture,
    required BattleNikke nikke,
    required int damageRate,
  }) {
    name = nikke.name;
    attackerUniqueId = rapture.uniqueId;
    targetUniqueId = nikke.uniqueId;

    damageParameter = NikkeDamageParameter(
      attack: rapture.baseAttack,
      attackBuff: rapture.getAttackBuffValues(simulation),
      defence: nikke.baseDefence,
      defenceBuff: nikke.getDefenceBuffValues(simulation),
      damageRate: damageRate,
      isStrongElement: rapture.element.strongAgainst(nikke.element),
      damageReductionBuff: nikke.getDamageReductionBuffValues(simulation),
    );
    invalid = nikke.buffs.any((buff) => buff.data.functionType == FunctionType.immuneDamage);
  }

  @override
  Widget buildDisplay() {
    return Text('$name (pos $attackerUniqueId) received ${damageParameter.calculateExpectedDamage()} damage');
  }
}
