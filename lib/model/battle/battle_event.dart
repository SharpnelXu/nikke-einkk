import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';

import 'nikke.dart';

abstract class BattleEvent {
  Widget buildDisplay();
}

// or replace these with an enum type if no real use case
class NikkeFireEvent implements BattleEvent {
  String name;
  int currentAmmo;
  int maxAmmo;
  int ownerPosition; // this is basically uniqueId

  NikkeFireEvent({required this.name, required this.currentAmmo, required this.maxAmmo, required this.ownerPosition});

  @override
  buildDisplay() {
    return Text('$name (Pos $ownerPosition) attack (Ammo: $currentAmmo/$maxAmmo)');
  }
}

class NikkeReloadStartEvent implements BattleEvent {
  String name;
  int reloadTimeData;
  int reloadFrames;
  int ownerPosition; // this is basically uniqueId

  NikkeReloadStartEvent({
    required this.name,
    required this.reloadTimeData,
    required this.reloadFrames,
    required this.ownerPosition,
  });

  @override
  Widget buildDisplay() {
    return Text(
      '$name (Pos $ownerPosition) reloading: '
      '${(reloadTimeData / 100).toStringAsFixed(2)}s ($reloadFrames frames)',
    );
  }
}

class NikkeDamageEvent implements BattleEvent {
  NikkeDamageType type;
  late String name;
  late int attackerPosition; // this is basically uniqueId for Nikke
  late int targetUniqueId;
  late int shotCount;

  late NikkeDamageParameter damageParameter;

  NikkeDamageEvent({required BattleNikkeData nikke, required BattleRaptureData rapture, required this.type}) {
    name = nikke.name;
    attackerPosition = nikke.position;
    targetUniqueId = rapture.uniqueId;
    shotCount = nikke.currentWeaponData.shotCount;

    // TODO: fill in other buff params
    damageParameter = NikkeDamageParameter(
      attack: nikke.baseAttack,
      defence: rapture.defence,
      damageRate: nikke.currentWeaponData.damage,
      coreHitRate: calculateCoreHitRate(nikke, rapture),
      coreDamageRate: nikke.currentWeaponData.coreDamageRate,
      criticalRate: nikke.characterData.criticalRatio,
      criticalDamageRate: nikke.characterData.criticalDamage,
      isBonusRange: nikke.isBonusRange(rapture.distance),
      isFullBurst: nikke.simulation.fullBurst,
      isStrongElement: nikke.element.strongAgainst(rapture.element),
      chargeDamageRate: nikke.chargeDamageRate,
    );
  }

  int calculateCoreHitRate(BattleNikkeData nikke, BattleRaptureData rapture) {
    // just a wild guess for now
    return (50 * rapture.coreSize / max(1, nikke.accuracyCircleScale * rapture.distance) * 10000).round();
  }

  @override
  Widget buildDisplay() {
    return Text(
      '$name (Pos $attackerPosition) ${type.name} damage: ${damageParameter.calculateExpectedDamage()} '
      '${shotCount > 1 ? '($shotCount Shots) ' : ''}'
      '(Core: ${(damageParameter.coreHitRate / 100).toStringAsFixed(2)}%, '
      'Crit: ${(damageParameter.criticalRate / 100).toStringAsFixed(2)}%)',
    );
  }
}

enum NikkeDamageType { bullet }
