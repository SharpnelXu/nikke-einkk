import 'package:flutter/cupertino.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';

class NikkeReloadStartEvent extends BattleEvent {
  String name;
  num reloadTimeData;
  int reloadFrames;
  int ownerUniqueId;

  NikkeReloadStartEvent({
    required this.name,
    required this.reloadTimeData,
    required this.reloadFrames,
    required this.ownerUniqueId,
  });

  @override
  int getActivatorId() {
    return ownerUniqueId;
  }

  @override
  Widget buildDisplay() {
    return Text(
      '$name (Pos $ownerUniqueId) reloading: '
      '${(reloadTimeData / 100).toStringAsFixed(2)}s ($reloadFrames frames)',
    );
  }
}
