import 'dart:math';

import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';

import 'nikke.dart';

class BattleEvent {}

// or replace these with an enum type if no real use case
class NikkeFireEvent implements BattleEvent {
  int ownerPosition; // this is basically uniqueId

  NikkeFireEvent({required this.ownerPosition});
}

class NikkeReloadStartEvent implements BattleEvent {
  int ownerPosition; // this is basically uniqueId

  NikkeReloadStartEvent({required this.ownerPosition});
}

class NikkeDamageEvent implements BattleEvent {
  late int attackerPosition; // this is basically uniqueId for Nikke
  late int targetUniqueId;

  late NikkeDamageParameter damageParameter;

  NikkeDamageEvent({required BattleNikkeData nikke, required BattleRaptureData rapture}) {
    attackerPosition = nikke.position;
    targetUniqueId = rapture.uniqueId;

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
}
