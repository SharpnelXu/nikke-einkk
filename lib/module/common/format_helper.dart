import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';
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

String dollLvString(FavoriteItemData? doll, int dollLevel) {
  if (doll == null) {
    return dollLevel.toString();
  }

  if (doll.favoriteRare == Rarity.ssr) {
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

String toPercentString(num value) {
  return '${(value / 100).toStringAsFixed(2)}%';
}

String timeString(int value) {
  return '${(value / 100).toStringAsFixed(2)} s';
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

String? durationString(int value, DurationType type) {
  switch (type) {
    case DurationType.timeSec:
    case DurationType.timeSecVer2:
      return value == 0 ? null : timeString(value);
    case DurationType.shots:
      return value == 0 ? null : '$value shots';
    case DurationType.battles:
      return '∞';
    case DurationType.hits:
      return value == 0 ? null : '$value hits';
    case DurationType.timeSecBattles:
      return 'Every ${timeString(value)}';
    case DurationType.none:
    case DurationType.unknown:
      return null;
  }
}

Color buffTypeColor(BuffType? type) {
  if (type == null) {
    return Colors.grey;
  }
  switch (type) {
    case BuffType.buff:
    case BuffType.buffEtc:
      return Colors.green;
    case BuffType.deBuff:
    case BuffType.deBuffEtc:
      return Colors.red;
    case BuffType.etc:
    case BuffType.unknown:
      return Colors.grey;
  }
}

String? functionStandardString(StandardType funcStandard) {
  switch (funcStandard) {
    case StandardType.user:
      return 'Activator';
    case StandardType.functionTarget:
      return 'Receiver';
    case StandardType.triggerTarget: // there is no triggerTarget in functionStandardType
    case StandardType.unknown:
    case StandardType.none:
      return null;
  }
}

String formatFunctionDescription(FunctionData func) {
  String result = locale.getTranslation(func.descriptionLoaclkey) ?? func.descriptionLoaclkey ?? '';
  final replaceKey = '{function_value02}';
  final replaceValue = (func.functionValue / 100).toStringAsFixed(2);
  result = result.replaceFirst(replaceKey, replaceValue);

  return result;
}

String formatSkillInfoDescription(SkillInfoData skillInfo) {
  String result = locale.getTranslation(skillInfo.descriptionLocalkey) ?? skillInfo.descriptionLocalkey;
  for (int v = 1; v <= skillInfo.descriptionValues.length; v += 1) {
    final replaceKey = '{description_value_${v < 10 ? '0' : ''}$v}';
    final replaceValue = skillInfo.descriptionValues[v - 1];
    result = result.replaceFirst(replaceKey, replaceValue.value ?? '');
  }

  return result;
}

List<InlineSpan> buildDescriptionTextSpans(String curText, TextStyle style, NikkeDatabaseV2 db) {
  final textSpans = <InlineSpan>[];
  int currentIndex = 0;

  // Combined regex pattern for both tag types
  final regex = RegExp(
    r'(<color=#([\dA-F]{6})>(.*?)</color>)|(<word_group=(\d+)>(.*?)</word_group>)',
    caseSensitive: false,
    dotAll: true,
  );

  for (final match in regex.allMatches(curText)) {
    // Add text before the match
    if (match.start > currentIndex) {
      textSpans.add(TextSpan(text: curText.substring(currentIndex, match.start), style: style));
    }

    // Process color tag
    if (match.group(1) != null) {
      final colorCode = match.group(2)!;
      final content = match.group(3)!;
      textSpans.addAll(
        buildDescriptionTextSpans(content, style.copyWith(color: Color(int.parse('0xFF$colorCode'))), db),
      );
    }
    // Process word_group tag
    else if (match.group(4) != null) {
      final wordGroupId = match.group(5)!;
      final content = match.group(6)!;
      final wordGroupData =
          db.wordGroupTable[wordGroupId]
              ?.where((data) => data.resourceType == 'locale')
              .sorted(
                (a, b) =>
                    a.pageNumber == b.pageNumber ? a.order.compareTo(b.order) : a.pageNumber.compareTo(b.pageNumber),
              ) ??
          [];
      final toolTipMessage =
          'Word Group ID: $wordGroupId\n'
          '${wordGroupData.map((data) => locale.getTranslation('Locale_Skill:${data.resourceValue}')).join('\n\n')}';
      textSpans.add(
        WidgetSpan(
          child: Tooltip(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            richMessage: TextSpan(
              children: buildDescriptionTextSpans(toolTipMessage, style.copyWith(color: Colors.black), db),
            ),
            child: Text(
              content,
              style: style.copyWith(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationColor: Colors.orange,
                decorationThickness: 1.5,
              ),
            ),
          ),
        ),
      );
    }

    currentIndex = match.end;
  }

  // Add remaining text
  if (currentIndex < curText.length) {
    textSpans.add(TextSpan(text: curText.substring(currentIndex), style: style));
  }
  return textSpans;
}

class DescriptionTextWidget extends StatelessWidget {
  final SkillInfoData skillInfoData;
  final bool useGlobal;

  NikkeDatabaseV2 get db => useGlobal ? global : cn;

  const DescriptionTextWidget(this.skillInfoData, this.useGlobal, {super.key});

  @override
  Widget build(BuildContext context) {
    final text = formatSkillInfoDescription(skillInfoData);
    final defaultStyle = DefaultTextStyle.of(context).style;
    final textSpans = buildDescriptionTextSpans(text, defaultStyle, db);

    return RichText(text: TextSpan(children: textSpans, style: defaultStyle));
  }
}
