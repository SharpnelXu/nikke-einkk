import 'package:flutter/cupertino.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';

class NikkeFireEvent extends BattleEvent {
  String name;
  int currentAmmo;
  int maxAmmo;
  bool isFullCharge;
  int ownerUniqueId;

  NikkeFireEvent({
    required this.name,
    required this.isFullCharge,
    required this.currentAmmo,
    required this.maxAmmo,
    required this.ownerUniqueId,
  });

  @override
  buildDisplay() {
    return Text('$name (Pos $ownerUniqueId) attack (Ammo: ${currentAmmo - 1}/$maxAmmo)');
  }

  @override
  int getActivatorUniqueId() {
    return ownerUniqueId;
  }
}
