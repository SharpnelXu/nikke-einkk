import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';

import 'nikke.dart';

class BattleEvent {}

class NikkeFireEvent implements BattleEvent {
  int ownerPosition; // this is basically uniqueId

  NikkeFireEvent({required this.ownerPosition});
}

class NikkeDamageEvent implements BattleEvent {
  late int attackerPosition; // this is basically uniqueId for Nikke
  late int targetUniqueId;

  late NikkeDamageParameter damageParameter;

  NikkeDamageEvent({required BattleNikkeData nikke, required BattleRaptureData rapture}) {
    attackerPosition = nikke.position;
    targetUniqueId = rapture.uniqueId;

    // TODO: fill in other params
    damageParameter = NikkeDamageParameter(
      attack: nikke.baseAttack,
      defence: rapture.defence,
      damageRate: nikke.currentWeaponData.damage,
    );
  }
}
