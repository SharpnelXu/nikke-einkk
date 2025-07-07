import 'package:flutter/cupertino.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';

class BattleStartEvent extends BattleEvent {
  static BattleStartEvent battleStartEvent = BattleStartEvent._();

  BattleStartEvent._();

  @override
  Widget buildDisplay() {
    return Text('Battle Start');
  }
}
