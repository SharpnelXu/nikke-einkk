import 'package:flutter/cupertino.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/module/common/custom_table.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';

class RaptureDamageEvent extends BattleEvent {
  NikkeDamageParameter damageParameter;
  bool hitCover;
  bool invalid;

  RaptureDamageEvent._(super.activatorId, super.targetIds, this.damageParameter, this.invalid, this.hitCover);

  factory RaptureDamageEvent.create(
    BattleSimulation simulation,
    BattleRapture rapture,
    BattleNikke nikke,
    int damageRate,
    bool hitCover,
  ) {
    final damageParameter = NikkeDamageParameter(
      attack: rapture.baseAttack,
      attackBuff: rapture.getAttackBuffValues(simulation),
      defence: nikke.baseDefence,
      defenceBuff: nikke.getDefenceBuffValues(simulation),
      damageRate: damageRate,
      isStrongElement: rapture.element.strongAgainst(nikke.element),
      damageReductionBuff: nikke.getDamageReductionBuffValues(simulation),
    );
    final invalid = nikke.buffs.any((buff) => buff.data.functionType == FunctionType.immuneDamage);
    return RaptureDamageEvent._(rapture.uniqueId, [nikke.uniqueId], damageParameter, invalid, hitCover);
  }

  int get targetId => targetIds.first;

  @override
  void processNikke(BattleSimulation simulation, BattleNikke nikke) {
    if (nikke.uniqueId == targetId) {
      for (final buff in nikke.buffs) {
        if (buff.data.durationType.isShots && simulation.db.onHitFunctionTypes.contains(buff.data.functionType)) {
          buff.duration -= 1;
        }
      }
    }
  }

  @override
  Widget buildDisplayV2(BattleSimulation simulation) {
    return CustomTable(
      children: [
        CustomTableRow.fromTexts(
          texts: ['Rapture Damage', 'Activator', 'Target', 'Invalid'],
          defaults: battleHeaderData,
        ),
        CustomTableRow.fromTexts(
          texts: [
            damageParameter.calculateExpectedDamage().decimalPattern,
            '${simulation.getEntityName(activatorId)}',
            '${simulation.getEntityName(targetId)}',
            '$invalid',
          ],
        ),
      ],
    );
  }
}
