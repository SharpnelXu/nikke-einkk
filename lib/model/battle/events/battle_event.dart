import 'package:flutter/cupertino.dart';

abstract class BattleEvent {
  Widget buildDisplay();

  int getActivatorUniqueId() {
    return -1;
  }

  List<int> getTargetUniqueIds() {
    return [];
  }
}
