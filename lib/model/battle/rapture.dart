import 'package:nikke_einkk/model/common.dart';

class BattleRapture {
  bool canBeTargeted = true;

  bool isStageTarget = true;

  int defence = 0;

  int uniqueId = 0;

  int coreSize = 10;

  int distance = 25;

  Element element = Element.unknown;

  bool hasParts() {
    return false;
  }
}
