import 'package:nikke_einkk/model/battle/equipment.dart';
import 'package:nikke_einkk/model/common.dart';

class BattleNikkeData {
  NikkeCharacterData characterData;
  // weapon data
  // skill data

  // level
  // core level
  // attract level
  // recycle levels
  List<BattleEquipmentData> equips;
  // skill levels
  // cube
  // doll

  BattleNikkeData({required this.characterData, this.equips = [],});
}
