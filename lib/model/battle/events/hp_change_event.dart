import 'package:flutter/cupertino.dart';
import 'package:nikke_einkk/model/battle/battle_entity.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';

class HpChangeEvent extends BattleEvent {
  late String name;
  late int ownerUniqueId; // who changed hp
  late int afterChangeHp;
  late int maxHp;
  bool isMaxHpOnly;
  bool isHeal;
  int changeAmount;

  HpChangeEvent(
    BattleSimulation simulation,
    BattleEntity entity,
    this.changeAmount, {
    this.isMaxHpOnly = false,
    this.isHeal = false,
  }) {
    name = entity.name;
    ownerUniqueId = entity.uniqueId;
    afterChangeHp = entity.currentHp;
    maxHp = entity.getMaxHp(simulation);
  }

  @override
  int getActivatorUniqueId() {
    return ownerUniqueId;
  }

  @override
  Widget buildDisplay() {
    final hpPercent = (afterChangeHp / maxHp * 100).toStringAsFixed(2);
    return Text(
      '$name (Pos $ownerUniqueId) ${isMaxHpOnly ? 'Max' : ''}HP change:'
      ' $changeAmount ($hpPercent% $afterChangeHp/$maxHp)',
    );
  }
}
