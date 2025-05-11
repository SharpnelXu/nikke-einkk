import 'package:nikke_einkk/model/common.dart';

import 'battle_entity.dart';

class BattleRapture extends BattleEntity {
  bool canBeTargeted = true;

  bool isStageTarget = true;

  int coreSize = 10;

  int distance = 25;

  @override
  int get baseHp => 100;

  @override
  int get baseDefence => 0;

  @override
  int get baseAttack => 100;

  Element element = Element.unknown;

  bool hasParts() {
    return false;
  }
}
