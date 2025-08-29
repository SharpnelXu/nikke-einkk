import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';
import 'package:nikke_einkk/model/battle/events/nikke_damage_event.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/module/common/custom_table.dart';

class LaunchWeaponEvent extends BattleEvent {
  final WeaponData weaponData;
  final Source source;

  LaunchWeaponEvent._(super.activatorId, super.targetIds, this.weaponData, this.source);

  factory LaunchWeaponEvent.create(int activatorId, WeaponData weaponData, Source source) {
    return LaunchWeaponEvent._(activatorId, [], weaponData, source);
  }

  @override
  void processNikke(BattleSimulation simulation, BattleNikke nikke) {
    final rapture = simulation.raptures.firstOrNull;
    if (nikke.uniqueId == activatorId && rapture != null) {
      final damageEvent = NikkeDamageEvent.launchWeapon(
        simulation: simulation,
        nikke: nikke,
        rapture: rapture,
        weaponData: weaponData,
      );
      simulation.registerEvent(simulation.currentFrame, damageEvent);
    }
  }

  @override
  Widget buildDisplayV2(BattleSimulation simulation) {
    return CustomTable(
      children: [
        CustomTableRow.fromTexts(texts: ['Launch Weapon', 'Activator'], defaults: battleHeaderData),
        CustomTableRow.fromTexts(texts: ['${weaponData.id}', '${simulation.getEntityName(activatorId)}']),
      ],
    );
  }
}
