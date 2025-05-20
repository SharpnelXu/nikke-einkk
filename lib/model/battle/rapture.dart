import 'package:collection/collection.dart';
import 'package:nikke_einkk/model/battle/barrier.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/skills.dart';

import 'battle_entity.dart';

class BattleRaptureParts {
  int id;
  int maxHp = 10000;
  int hp = 10000;
  bool isBehindBoss = true;
  bool isCore = false;

  BattleRaptureParts(this.id);

  bool canBeDamaged(bool hasPierce) {
    return hp > 0 && (hasPierce || !isBehindBoss);
  }
}

class BattleRapture extends BattleEntity {
  bool canBeTargeted = true;

  bool isStageTarget = true;

  // set to 0 for no core
  int coreSize = 10;

  bool coreRequiresPierce = false;

  int distance = 25;

  int defence = 0;

  Barrier? barrier;

  @override
  int get baseHp => 100;

  @override
  int get baseDefence => defence;

  @override
  int get baseAttack => 100;

  List<BattleRaptureParts> parts = [];

  bool hasParts() {
    return parts.isNotEmpty;
  }

  bool hasPartsInFront() {
    return parts.isNotEmpty && parts.any((part) => !part.isBehindBoss);
  }

  int? getPartsInFront() {
    return parts.firstWhereOrNull((part) => !part.isBehindBoss && part.hp > 0)?.id;
  }

  @override
  void normalAction(BattleSimulation simulation) {
    super.normalAction(simulation);

    final barrier = this.barrier;
    if (barrier != null) {
      if (barrier.durationType == DurationType.timeSec) {
        barrier.duration -= 1;
        if (barrier.duration == 0) {
          this.barrier = null;
        }
      }

      if (barrier.hp <= 0) {
        this.barrier = null;
      }
    }
  }
}
