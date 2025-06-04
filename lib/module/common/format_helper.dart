import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/favorite_item.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';

String coreString(int coreLevel) {
  if (coreLevel < 1 || coreLevel > 11) return '$coreLevel';
  final gradeLevel = coreLevel > 4 ? 4 : coreLevel;
  String result = '';
  for (int count = 1; count < gradeLevel; count += 1) {
    result += '★';
  }
  for (int count = 3; count >= gradeLevel; count -= 1) {
    result += '☆';
  }

  if (coreLevel == 11) {
    result += ' MAX';
  } else if (coreLevel > 4) {
    result += ' C${coreLevel - 4}';
  }

  return result;
}

String dollLvString(BattleFavoriteItem? doll, int dollLevel) {
  if (doll == null) {
    return dollLevel.toString();
  }

  if (doll.rarity == Rarity.ssr) {
    String result = '★';
    for (int i = 0; i < dollLevel; i += 1) {
      result += '★';
    }
    for (int i = dollLevel; i < 2; i += 1) {
      result += '☆';
    }
    return result;
  } else {
    return dollLevel.toString();
  }
}

const avatarSize = 120.0;

Widget buildNikkeIcon(NikkeCharacterData? characterData, bool isSelected, [String defaultText = 'None']) {
  final name = db.getTranslation(characterData?.nameLocalkey)?.zhCN ?? characterData?.resourceId ?? defaultText;
  final weapon = db.characterShotTable[characterData?.shotId];

  final colors =
      characterData?.elementId
          .map((eleId) => NikkeElement.fromId(eleId).color.withAlpha(isSelected ? 255 : 50))
          .toList();

  final textStyle = TextStyle(fontSize: 15, color: isSelected && characterData != null ? Colors.white : Colors.black);
  return Container(
    width: avatarSize,
    height: avatarSize,
    margin: const EdgeInsets.all(5.0),
    padding: const EdgeInsets.all(3.0),
    decoration: BoxDecoration(
      border: Border.all(color: characterData?.originalRare.color ?? Colors.black, width: 3),
      borderRadius: BorderRadius.circular(5),
      gradient: colors != null && colors.length > 1 ? LinearGradient(colors: colors) : null,
      color: colors != null && colors.length == 1 ? colors.first : null,
    ),
    child: Stack(
      alignment: Alignment.center,
      fit: StackFit.loose,
      children: [
        Text('$name', style: textStyle),
        if (characterData != null)
          Positioned(top: 2, left: 2, child: Text(characterData.corporation.name.toUpperCase(), style: textStyle)),
        if (characterData != null)
          Positioned(
            bottom: 2,
            left: 2,
            child: Text(characterData.characterClass.name.toUpperCase(), style: textStyle),
          ),
        if (weapon != null) Positioned(top: 2, right: 2, child: Text(weapon.weaponType.toString(), style: textStyle)),
        if (characterData != null)
          Positioned(bottom: 2, right: 2, child: Text(characterData.useBurstSkill.toString(), style: textStyle)),
      ],
    ),
  );
}

Widget buildRaptureIcon(BattleRaptureOptions option) {
  final textStyle = TextStyle(fontSize: 15, color: Colors.white);
  return Container(
    width: avatarSize,
    height: avatarSize,
    margin: const EdgeInsets.all(5.0),
    padding: const EdgeInsets.all(3.0),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black, width: 3),
      borderRadius: BorderRadius.circular(5),
      color: option.element.color,
    ),
    child: Stack(alignment: Alignment.center, fit: StackFit.loose, children: [Text(option.name, style: textStyle)]),
  );
}
