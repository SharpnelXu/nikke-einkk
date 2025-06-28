import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';
import 'package:nikke_einkk/module/nikkes/nikke_list.dart';

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

    final textStyle = TextStyle(fontSize: 12, color: isSelected && characterData != null ? Colors.white : Colors.black);
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
          Text('$name', style: textStyle.copyWith(fontSize: 18)),
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
  final NikkeCharacterData? character;
  final int weaponId;

  NikkeDatabaseV2 get db => userDb.gameDb;

  const WeaponDataDisplay({super.key, this.character, required this.weaponId});

  @override
  Widget build(BuildContext context) {
    final sectionFontSize = 16.0;
    final weapon = db.characterShotTable[weaponId];
    final List<Widget> children = [
      if (weapon != null && weapon.nameLocalkey != null)
        Text(locale.getTranslation(weapon.nameLocalkey!) ?? weapon.nameLocalkey!, style: TextStyle(fontSize: 18)),
      Text('Weapon ID: $weaponId'),
      if (weapon != null && weapon.descriptionLocalkey != null) DescriptionTextWidget(formatWeaponDescription(weapon)),
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
            Text('Base: ${weapon.damage.percentString}'),
            if (character != null)
              Text(
                'Critical: ${character!.criticalDamage.percentString} '
                '(${character!.criticalRatio.percentString} chance)',
              ),
            Text('Core: ${weapon.coreDamageRate.percentString}'),
            if (weapon.fullChargeDamage != 10000)
              Text('Full Charge: ${weapon.fullChargeDamage.percentString} (${weapon.chargeTime.timeString})'),
          ],
        ),
        Text('Burst', style: TextStyle(fontSize: sectionFontSize)),
        Wrap(
          spacing: 15,
          alignment: WrapAlignment.center,
          children: [
            Text('Base: ${(weapon.burstEnergyPerShot / 100).percentString}'),
            Text('Target: ${(weapon.targetBurstEnergyPerShot / 100).percentString}'),
            if (weapon.fullChargeBurstEnergy != 10000)
              Text('Full Charge: ${weapon.fullChargeBurstEnergy.percentString}'),
            Text('Shot Count: ${weapon.shotCount} x ${weapon.muzzleCount}'),
          ],
        ),
        Text('Ammo', style: TextStyle(fontSize: sectionFontSize)),
        Wrap(
          spacing: 15,
          alignment: WrapAlignment.center,
          children: [
            Text('Max Ammo: ${weapon.maxAmmo}'),
            Text('Reload Time: ${weapon.reloadTime.timeString} (${weapon.reloadBullet.percentString})'),
            Text('Exit Cover: ${weapon.spotFirstDelay.timeString}'),
            Text('Enter Cover: ${weapon.spotLastDelay.timeString}'),
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
            Text('Reset Time: ${weapon.rateOfFireResetTime.timeString}'),
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
                        height: max(1, weapon.endAccuracyCircleScale * 0.75),
                        width: max(1, weapon.endAccuracyCircleScale * 0.75),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 3),
                          color: null,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        height: max(1, weapon.startAccuracyCircleScale * 0.75),
                        width: max(1, weapon.startAccuracyCircleScale * 0.75),
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
            Text('Reset Time: ${weapon.accuracyChangeSpeed.timeString}'),
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
            Text('Maintain Fire Stance: ${weapon.maintainFireStance.timeString}'),
            Text('Up Fire Timing: ${weapon.upTypeFireTiming.percentString}'),
          ],
        ),
      ]);
    }
    return Column(mainAxisSize: MainAxisSize.min, spacing: 3, children: children);
  }
}

class NikkeAdvancedFilterDialog extends StatefulWidget {
  final NikkeFilterData filterData;
  const NikkeAdvancedFilterDialog({super.key, required this.filterData});

  @override
  State<NikkeAdvancedFilterDialog> createState() => _NikkeAdvancedFilterDialogState();
}

class _NikkeAdvancedFilterDialogState extends State<NikkeAdvancedFilterDialog> {
  NikkeFilterData get filterData => widget.filterData;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Advanced Nikke Filter'),
      content: Column(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              Text('Skill Types', style: TextStyle(fontSize: 18)),
              FilledButton(
                style: FilledButton.styleFrom(
                  foregroundColor: filterData.skillOr ? Colors.white : Colors.black,
                  backgroundColor: filterData.skillOr ? Colors.blue : Colors.white,
                ),
                onPressed: () {
                  filterData.skillOr = !filterData.skillOr;
                  setState(() {});
                },
                child: Text(filterData.skillOr ? 'OR Mode' : 'AND Mode'),
              ),
            ],
          ),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children:
                CharacterSkillType.sorted.map((type) {
                  final enabled = filterData.skillTypes.contains(type);
                  return FilledButton(
                    style: FilledButton.styleFrom(
                      foregroundColor: enabled ? Colors.white : Colors.black,
                      backgroundColor: enabled ? Colors.blue : Colors.white,
                    ),
                    onPressed: () {
                      if (enabled) {
                        filterData.skillTypes.remove(type);
                      } else {
                        filterData.skillTypes.add(type);
                      }
                      setState(() {});
                    },
                    child: Text(type.name),
                  );
                }).toList(),
          ),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              Text('Function Types', style: TextStyle(fontSize: 18)),
              FilledButton(
                style: FilledButton.styleFrom(
                  foregroundColor: filterData.funcOr ? Colors.white : Colors.black,
                  backgroundColor: filterData.funcOr ? Colors.blue : Colors.white,
                ),
                onPressed: () {
                  filterData.funcOr = !filterData.funcOr;
                  setState(() {});
                },
                child: Text(filterData.funcOr ? 'OR Mode' : 'AND Mode'),
              ),
            ],
          ),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children:
                FunctionType.sorted.map((type) {
                  final enabled = filterData.funcTypes.contains(type);
                  return FilledButton(
                    style: FilledButton.styleFrom(
                      foregroundColor: enabled ? Colors.white : Colors.black,
                      backgroundColor: enabled ? Colors.blue : Colors.white,
                    ),
                    onPressed: () {
                      if (enabled) {
                        filterData.funcTypes.remove(type);
                      } else {
                        filterData.funcTypes.add(type);
                      }
                      setState(() {});
                    },
                    child: Text(type.name),
                  );
                }).toList(),
          ),
          Text('Timing Trigger Types', style: TextStyle(fontSize: 18)),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children:
                TimingTriggerType.sorted.map((type) {
                  final enabled = filterData.timingTypes.contains(type);
                  return FilledButton(
                    style: FilledButton.styleFrom(
                      foregroundColor: enabled ? Colors.white : Colors.black,
                      backgroundColor: enabled ? Colors.blue : Colors.white,
                    ),
                    onPressed: () {
                      if (enabled) {
                        filterData.timingTypes.remove(type);
                      } else {
                        filterData.timingTypes.add(type);
                      }
                      setState(() {});
                    },
                    child: Text(type.name),
                  );
                }).toList(),
          ),
          Text('Status Trigger Types', style: TextStyle(fontSize: 18)),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children:
                StatusTriggerType.sorted.map((type) {
                  final enabled = filterData.statusTypes.contains(type);
                  return FilledButton(
                    style: FilledButton.styleFrom(
                      foregroundColor: enabled ? Colors.white : Colors.black,
                      backgroundColor: enabled ? Colors.blue : Colors.white,
                    ),
                    onPressed: () {
                      if (enabled) {
                        filterData.statusTypes.remove(type);
                      } else {
                        filterData.statusTypes.add(type);
                      }
                      setState(() {});
                    },
                    child: Text(type.name),
                  );
                }).toList(),
          ),
        ],
      ),
      contentPadding: const EdgeInsetsDirectional.fromSTEB(24.0, 20.0, 24.0, 24.0),
      scrollable: true,
      actions: [
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      insetPadding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
    );
  }
}
