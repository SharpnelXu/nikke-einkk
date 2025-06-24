import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';

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
        border: Border.all(
          color: characterData?.isVisible ?? true ? characterData?.originalRare.color ?? Colors.black : Colors.red,
          width: 3,
        ),
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
            Positioned(top: 2, left: 2, child: Text(characterData!.corporation.name.toUpperCase(), style: textStyle)),
          if (characterData != null)
            Positioned(
              bottom: 2,
              left: 2,
              child: Text(characterData!.characterClass.name.toUpperCase(), style: textStyle),
            ),
          if (weapon != null)
            Positioned(top: 2, right: 2, child: Text(weapon!.weaponType.toString(), style: textStyle)),
          if (characterData != null)
            Positioned(bottom: 2, right: 2, child: Text(characterData!.useBurstSkill.toString(), style: textStyle)),
        ],
      ),
    );
  }
}

class WeaponDataDisplay extends StatelessWidget {
  final bool useGlobal;
  final NikkeCharacterData? character;
  final int weaponId;

  NikkeDatabaseV2 get db => useGlobal ? global : cn;

  const WeaponDataDisplay({super.key, this.character, required this.weaponId, required this.useGlobal});

  @override
  Widget build(BuildContext context) {
    final sectionFontSize = 16.0;
    final weapon = db.characterShotTable[weaponId];
    final List<Widget> children = [
      Text('Weapon ID: $weaponId - ${weapon == null ? 'Not Found' : 'Found'}', style: TextStyle(fontSize: 18)),
    ];
    if (weapon != null) {
      children.addAll([
        Wrap(
          spacing: 15,
          alignment: WrapAlignment.center,
          children: [
            Text('Weapon Type: ${weapon.rawWeaponType}'),
            if (character != null) Text('Bonus Range: ${character!.bonusRangeMin} - ${character!.bonusRangeMax}'),
            Text('Shot Timing: ${weapon.rawShotTiming}'),
            Text('Fire Type: ${weapon.rawFireType}'),
          ],
        ),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5,
          children: [
            Text('Damage', style: TextStyle(fontSize: sectionFontSize)),
            Tooltip(
              message: 'Note: crit & range is tied to character model',
              child: Icon(Icons.info_outline, size: 16),
            ),
          ],
        ),
        Wrap(
          spacing: 15,
          alignment: WrapAlignment.center,
          children: [
            Text('Base: ${toPercentString(weapon.damage)}'),
            if (character != null)
              Text(
                'Critical: ${toPercentString(character!.criticalDamage)} '
                '(${toPercentString(character!.criticalRatio)} chance)',
              ),
            Text('Core: ${toPercentString(weapon.coreDamageRate)}'),
            if (weapon.fullChargeDamage != 10000)
              Text('Full Charge: ${toPercentString(weapon.fullChargeDamage)} (${timeString(weapon.chargeTime)})'),
          ],
        ),
        Text('Burst', style: TextStyle(fontSize: sectionFontSize)),
        Wrap(
          spacing: 15,
          alignment: WrapAlignment.center,
          children: [
            Text('Base: ${toPercentString(weapon.burstEnergyPerShot / 100)}'),
            Text('Target: ${toPercentString(weapon.targetBurstEnergyPerShot / 100)}'),
            if (weapon.fullChargeBurstEnergy != 10000)
              Text('Full Charge: ${toPercentString(weapon.fullChargeBurstEnergy)}'),
            Text('Shot Count: ${weapon.shotCount} x ${weapon.muzzleCount}'),
          ],
        ),
        Text('Ammo', style: TextStyle(fontSize: sectionFontSize)),
        Wrap(
          spacing: 15,
          alignment: WrapAlignment.center,
          children: [
            Text('Max Ammo: ${weapon.maxAmmo}'),
            Text('Reload Time: ${timeString(weapon.reloadTime)} (${toPercentString(weapon.reloadBullet)})'),
            Text('Exit Cover: ${timeString(weapon.spotFirstDelay)}'),
            Text('Enter Cover: ${timeString(weapon.spotLastDelay)}'),
          ],
        ),
        if (weapon.spotProjectileSpeed > 0) Text('Projectile', style: TextStyle(fontSize: sectionFontSize)),
        if (weapon.spotProjectileSpeed > 0)
          Wrap(
            spacing: 15,
            alignment: WrapAlignment.center,
            children: [
              Text('Speed: ${weapon.spotProjectileSpeed}'),
              Text('Explosion Range: ${weapon.spotExplosionRange}'),
            ],
          ),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5,
          children: [
            Text('Rate Of Fire', style: TextStyle(fontSize: sectionFontSize)),
            Tooltip(message: 'Note: capped to 60 due to frame rate', child: Icon(Icons.info_outline, size: 16)),
          ],
        ),
        Wrap(
          spacing: 15,
          alignment: WrapAlignment.center,
          children: [
            Text('Rate: ${weapon.rateOfFire} - ${weapon.endRateOfFire}'),
            Text('(${weapon.rateOfFire / 60} - ${weapon.endRateOfFire / 60} shots/s)'),
            Text('Change Per Shot: ${weapon.rateOfFireChangePerShot}'),
            Text('Reset Time: ${timeString(weapon.rateOfFireResetTime)}'),
          ],
        ),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5,
          children: [
            Text('Accuracy', style: TextStyle(fontSize: sectionFontSize)),
            Tooltip(
              richMessage: WidgetSpan(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      child: Container(
                        height: weapon.endAccuracyCircleScale * 0.75,
                        width: weapon.endAccuracyCircleScale * 0.75,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 3),
                          color: null,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        height: weapon.startAccuracyCircleScale * 0.75,
                        width: weapon.startAccuracyCircleScale * 0.75,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 3),
                          color: null,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              child: Icon(Icons.info_outline, size: 16),
            ),
          ],
        ),
        Wrap(
          spacing: 15,
          alignment: WrapAlignment.center,
          children: [
            Text('Rate: ${weapon.startAccuracyCircleScale} - ${weapon.endAccuracyCircleScale}'),
            Text('Change Per Shot: ${weapon.accuracyChangePerShot}'),
            Text('Reset Time: ${timeString(weapon.accuracyChangeSpeed)}'),
          ],
        ),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5,
          children: [
            Text('Misc', style: TextStyle(fontSize: sectionFontSize)),
            Tooltip(
              message:
                  'Note: Maintain Fire Stance: whether RL characters stay outside cover after each shot'
                  ' (E.g. SBS, A2, Raven)\n\n'
                  'Up Fire Timing: how long until the shot is actually fired for the characters above\n'
                  '(E.g. 50% means the bullet is fired after the maintain fire stance animation plays 50%)\n\n'
                  'Pending further verifications',
              child: Icon(Icons.info_outline, size: 16),
            ),
          ],
        ),
        Wrap(
          spacing: 15,
          alignment: WrapAlignment.center,
          children: [
            Text('Penetration: ${weapon.penetration}'),
            Text('Maintain Fire Stance: ${timeString(weapon.maintainFireStance)}'),
            Text('Up Fire Timing: ${toPercentString(weapon.upTypeFireTiming)}'),
          ],
        ),
      ]);
    }
    return Column(mainAxisSize: MainAxisSize.min, spacing: 3, children: children);
  }
}
