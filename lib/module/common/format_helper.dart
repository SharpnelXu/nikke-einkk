import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

extension FormatHelper on num {
  static final format = NumberFormat.decimalPattern();
  String get percentValue => (this / 100).toStringAsFixed(2);
  String get percentString => '$percentValue%';
  String get timeString => '$percentValue s';
  String get decimalPattern => format.format(round());
}

String coreString(int coreLevel) {
  final actualCoreLv = coreLevel % 100;
  final gradeLevel = actualCoreLv > 4 ? 4 : actualCoreLv;
  String result = '';
  for (int count = 1; count < gradeLevel; count += 1) {
    result += '★';
  }
  for (int count = 3; count >= gradeLevel; count -= 1) {
    result += '☆';
  }

  if (actualCoreLv == 11) {
    result += 'MAX';
  } else if (actualCoreLv > 4) {
    result += 'C${actualCoreLv - 4}';
  }

  return result;
}

int maxDollLv(Rarity? dollRare) {
  return dollRare == null
      ? 0
      : dollRare == Rarity.ssr
      ? 2
      : 15;
}

String dollLvString(Rarity? dollRare, int dollLevel) {
  if (dollRare == null || dollRare != Rarity.ssr) {
    return dollLevel.toString();
  } else {
    String result = '★';
    for (int i = 0; i < dollLevel; i += 1) {
      result += '★';
    }
    for (int i = dollLevel; i < 2; i += 1) {
      result += '☆';
    }
    return result;
  }
}

const avatarSize = 120.0;

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

String? skillValueString(int value, ValueType type, [num extraRate = 1]) {
  switch (type) {
    case ValueType.integer:
      return '$value';
    case ValueType.percent:
      return (value * extraRate).percentString;
    case ValueType.none:
    case ValueType.unknown:
      return null;
  }
}

String? durationString(int value, DurationType type) {
  switch (type) {
    case DurationType.timeSec:
    case DurationType.timeSecVer2:
      return value == 0 ? null : value.timeString;
    case DurationType.shots:
      return value == 0 ? null : '$value shots';
    case DurationType.battles:
      return '∞';
    case DurationType.hits:
      return value == 0 ? null : '$value hits';
    case DurationType.timeSecBattles:
      return 'Every ${value.timeString}';
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

String formatWeaponDescription(WeaponData weapon) {
  String result = locale.getTranslation(weapon.descriptionLocalkey) ?? weapon.descriptionLocalkey ?? '';
  result = result.replaceAll('{damage}', weapon.damage.percentValue);
  result = result.replaceAll('{core_damage_rate}', weapon.coreDamageRate.percentValue);
  result = result.replaceAll('{charge_time}', weapon.chargeTime.percentValue);
  result = result.replaceAll('{full_charge_damage}', weapon.fullChargeDamage.percentValue);

  return result;
}

String formatFunctionDescription(FunctionData func) {
  String result = locale.getTranslation(func.descriptionLocalkey) ?? func.descriptionLocalkey ?? '';
  result = result.replaceAll('{function_value01}', '${func.functionValue}');
  result = result.replaceAll('{function_value02}', func.functionValue.percentValue);
  result = result.replaceAll('{function_dec_value01}', '${func.functionValue.abs()}');
  result = result.replaceAll('{function_dec_value02}', func.functionValue.abs().percentValue);

  return result;
}

String formatSkillInfoDescription(SkillInfoData skillInfo) {
  String result = locale.getTranslation(skillInfo.descriptionLocalkey) ?? skillInfo.descriptionLocalkey;
  for (int v = 1; v <= skillInfo.descriptionValues.length; v += 1) {
    final replaceKey = '{description_value_${v < 10 ? '0' : ''}$v}';
    final replaceValue = skillInfo.descriptionValues[v - 1];
    result = result.replaceAll(replaceKey, replaceValue.value ?? '');
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
  final String text;

  const DescriptionTextWidget(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context).style;
    final textSpans = buildDescriptionTextSpans(text, defaultStyle, userDb.gameDb);

    return RichText(text: TextSpan(children: textSpans, style: defaultStyle));
  }
}
