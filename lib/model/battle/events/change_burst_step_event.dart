import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';

class ChangeBurstStepEvent extends BattleEvent {
  late String? name;
  final int ownerUniqueId;
  late int currentStage;
  late int nextStage;
  late int duration;

  ChangeBurstStepEvent(BattleSimulation simulation, this.ownerUniqueId, this.nextStage, this.duration) {
    final owner = simulation.getNikkeOnPosition(ownerUniqueId);
    name = owner?.name;
    currentStage = simulation.burstStage;
  }

  @override
  int getActivatorUniqueId() {
    return ownerUniqueId;
  }

  @override
  Widget buildDisplay() {
    return Text(
      'Burst stage $currentStage -> $nextStage ${name != null ? 'by $name (Pos $ownerUniqueId) '
              'Duration ${(duration / 100).toStringAsFixed(2)}s' : ''}',
    );
  }
}
