import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/module/common/custom_table.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';

class BurstGenerationEvent extends BattleEvent {
  final int burst;
  final bool focusBonus;
  final Source source;

  BurstGenerationEvent._(super.activatorId, super.targetIds, this.burst, this.source, this.focusBonus);

  factory BurstGenerationEvent.bullet(BattleSimulation simulation, BattleNikke nikke, BattleRapture rapture) {
    final weaponData = nikke.currentWeaponData;
    final bool isCharge = weaponData.weaponType.isCharge;
    int chargePercent = isCharge ? (10000 * nikke.chargeFrames / nikke.getFramesToFullCharge(simulation)).round() : 0;
    chargePercent = chargePercent.clamp(0, 10000);
    final bonusBurst = (nikke.option.alwaysFocus || simulation.currentNikke == nikke.uniqueId) && isCharge;

    final positionBurstBonus = bonusBurst ? 10000 + (15000 * toModifier(chargePercent)).round() : 10000;

    final baseBurst = nikke.getBurstGen(simulation, rapture.isStageTarget);
    final burst =
        (baseBurst * nikke.getShotCount(simulation) * weaponData.muzzleCount * toModifier(positionBurstBonus)).round();

    return BurstGenerationEvent._(nikke.uniqueId, [rapture.uniqueId], burst, Source.bullet, bonusBurst);
  }

  factory BurstGenerationEvent.fill(BattleSimulation simulation, BattleNikke nikke, int burst, Source source) {
    return BurstGenerationEvent._(nikke.uniqueId, [], burst, source, false);
  }

  int? get targetId => targetIds.firstOrNull;

  @override
  Widget buildDisplayV2(BattleSimulation simulation) {
    return CustomTable(
      children: [
        CustomTableRow.fromTexts(
          texts: ['Burst Gen', 'Source', 'Activator', if (targetId != null) 'Target'],
          defaults: battleHeaderData,
        ),
        CustomTableRow.fromTexts(
          texts: [
            '+${(burst / 10000).toStringAsFixed(2)}%${Source.bullet == source && focusBonus ? ' (Focus Bonus)' : ''}',
            source.name.pascal,
            '${simulation.getEntityName(activatorId)}',
            if (targetId != null) '${simulation.getEntityName(targetId!)}',
          ],
        ),
      ],
    );
  }
}
