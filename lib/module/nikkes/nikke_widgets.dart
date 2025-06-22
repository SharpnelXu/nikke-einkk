import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';

const avatarSize = 120.0;

class NikkeIcon extends StatelessWidget {
  final NikkeCharacterData? characterData;
  final WeaponData? weapon;
  final bool isSelected;
  final String defaultText;
  const NikkeIcon({
    super.key,
    this.characterData,
    this.weapon,
    required this.isSelected,
    this.defaultText = 'Not Found',
  });

  @override
  Widget build(BuildContext context) {
    final name = locale.getTranslation(characterData?.nameLocalkey) ?? characterData?.resourceId ?? defaultText;
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
}
