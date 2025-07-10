import 'package:flutter/cupertino.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';

class BattleEvent {
  final int activatorId;
  final List<int> targetIds;

  BattleEvent([this.activatorId = -1, List<int> targetIds = const []]) : targetIds = targetIds.toList();

  Widget buildDisplay() {
    return Text('$runtimeType');
  }

  Widget buildDisplayV2(BattleSimulation simulation) {
    return Text('$runtimeType');
  }

  int getActivatorId() {
    return activatorId;
  }

  List<int> getTargetIds() {
    return targetIds;
  }
}
