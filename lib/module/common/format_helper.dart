import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/favorite_item.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/skills.dart';

/// From source_helper:CaseHelper package
extension CaseHelper on String {
  String get snake => _fixCase('_');
  String get screamingSnake => snake.toUpperCase();
  String get pascal {
    if (isEmpty) {
      return '';
    }

    return this[0].toUpperCase() + substring(1);
  }

  String _fixCase(String separator) => replaceAllMapped(RegExp('[A-Z]'), (match) {
    var lower = match.group(0)!.toLowerCase();

    if (match.start > 0) {
      lower = '$separator$lower';
    }

    return lower;
  });
}

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

String frameDataToNiceTimeString(int frame, int fps) {
  final timeData = BattleUtils.frameToTimeData(frame, fps);
  final seconds = timeData % 6000 / 100;
  return '${timeData ~/ 6000}:'
      '${seconds < 10 ? '0' : ''}'
      '${(timeData % 6000 / 100).toStringAsFixed(3)}';
}

String toPercentString(int value) {
  return '${(value / 10000).toStringAsFixed(2)}%';
}

String? valueString(int value, ValueType type) {
  switch (type) {
    case ValueType.integer:
      return '$value';
    case ValueType.percent:
      return toPercentString(value);
    case ValueType.none:
    case ValueType.unknown:
      return null;
  }
}
