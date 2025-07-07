import 'package:flutter/cupertino.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';

class ExitFullBurstEvent extends BattleEvent {
  static ExitFullBurstEvent exitFullBurstEvent = ExitFullBurstEvent._();

  ExitFullBurstEvent._();

  @override
  Widget buildDisplay() {
    return Text('Exit full burst');
  }
}
