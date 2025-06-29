import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/module/common/custom_table.dart';
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

  static final boldStyle = TextStyle(fontWeight: FontWeight.bold);
  static final headerData = TableCellData(isHeader: true, style: boldStyle);

  @override
  Widget build(BuildContext context) {
    final weapon = db.characterShotTable[weaponId];
    final List<Widget> children = [
      CustomTableRow.fromTexts(
        texts: [
          if (weapon != null && weapon.nameLocalkey != null)
            locale.getTranslation(weapon.nameLocalkey!) ?? weapon.nameLocalkey!,
          'Weapon ID: $weaponId',
        ],
        defaults: headerData,
      ),
      if (weapon != null && weapon.descriptionLocalkey != null)
        CustomTableRow.fromTexts(texts: ['Description'], defaults: headerData),
      if (weapon != null && weapon.descriptionLocalkey != null)
        CustomTableRow.fromChildren(children: [DescriptionTextWidget(formatWeaponDescription(weapon))]),
    ];
    if (weapon != null) {
      children.addAll([
        CustomTableRow.fromTexts(
          texts: ['Weapon Type', 'Input Type', 'Shot Timing', 'Fire Type'],
          defaults: headerData,
        ),
        CustomTableRow.fromTexts(
          texts: [weapon.rawWeaponType, weapon.rawInputType, weapon.rawShotTiming, weapon.rawFireType],
        ),
        CustomTableRow.fromTexts(
          texts: ['Damage Rate', 'Core Damage', 'Full Charge Damage', 'Charge Time'],
          defaults: headerData,
        ),
        CustomTableRow.fromTexts(
          texts: [
            weapon.damage.percentString,
            weapon.coreDamageRate.percentString,
            weapon.fullChargeDamage != 10000 ? weapon.fullChargeDamage.percentString : 'N/A',
            weapon.chargeTime != 0 ? weapon.chargeTime.timeString : 'N/A',
          ],
        ),
        if (character != null)
          CustomTableRow.fromChildren(
            defaults: headerData,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 3,
                children: [
                  Text('Bonus Range', style: boldStyle),
                  Tooltip(message: 'Note: tied to character model', child: Icon(Icons.info_outline, size: 16)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 3,
                children: [
                  Text('Critical Damage', style: boldStyle),
                  Tooltip(message: 'Note: tied to character model', child: Icon(Icons.info_outline, size: 16)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 3,
                children: [
                  Text('Critical Chance', style: boldStyle),
                  Tooltip(message: 'Note: tied to character model', child: Icon(Icons.info_outline, size: 16)),
                ],
              ),
            ],
          ),
        if (character != null)
          CustomTableRow.fromTexts(
            texts: [
              '${character!.bonusRangeMin} - ${character!.bonusRangeMax}',
              character!.criticalDamage.percentString,
              character!.criticalRatio.percentString,
            ],
          ),
        CustomTableRow.fromTexts(
          texts: ['Burst', 'Target Burst', 'Full Charge Burst', 'Shot Count'],
          defaults: headerData,
        ),
        CustomTableRow.fromTexts(
          texts: [
            (weapon.burstEnergyPerShot / 100).percentString,
            (weapon.targetBurstEnergyPerShot / 100).percentString,
            weapon.fullChargeBurstEnergy != 10000 ? weapon.fullChargeBurstEnergy.percentString : 'N/A',
            '${weapon.shotCount} x ${weapon.muzzleCount}',
          ],
        ),
        CustomTableRow.fromTexts(
          texts: ['Max Ammo', 'Reload Time', 'Reload %', 'Exit Cover Time', 'Enter Cover Time'],
          defaults: headerData,
        ),
        CustomTableRow.fromTexts(
          texts: [
            '${weapon.maxAmmo}',
            weapon.reloadTime.timeString,
            weapon.reloadBullet.percentString,
            weapon.spotFirstDelay.timeString,
            weapon.spotLastDelay.timeString,
          ],
        ),
        if (weapon.spotProjectileSpeed > 0)
          CustomTableRow.fromTexts(texts: ['Projectile Speed', 'Explosion Range', 'Radius'], defaults: headerData),
        if (weapon.spotProjectileSpeed > 0)
          CustomTableRow.fromTexts(
            texts: ['${weapon.spotProjectileSpeed}', '${weapon.spotExplosionRange}', '${weapon.spotRadius}'],
          ),
        CustomTableRow.fromTexts(texts: ['Fire Rate', 'Change Per Shot', 'Reset Time'], defaults: headerData),
        CustomTableRow.fromTexts(
          texts: [
            '${weapon.rateOfFire} - ${weapon.endRateOfFire} RPM',
            '${weapon.rateOfFireChangePerShot}',
            weapon.rateOfFireResetTime.timeString,
          ],
        ),
        CustomTableRow.fromChildren(
          defaults: headerData,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 3,
              children: [
                Text('Accuracy', style: boldStyle),
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
            Text('Change Per Shot', style: boldStyle),
            Text('Reset Time', style: boldStyle),
          ],
        ),
        CustomTableRow.fromTexts(
          texts: [
            '${weapon.startAccuracyCircleScale} - ${weapon.endAccuracyCircleScale}',
            '${weapon.accuracyChangePerShot}',
            weapon.accuracyChangeSpeed.timeString,
          ],
        ),
        CustomTableRow.fromChildren(
          defaults: headerData,
          children: [
            Text('Penetration', style: boldStyle),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 3,
              children: [
                Text('Maintain Fire Stance', style: boldStyle),
                Tooltip(
                  message:
                      'Note: A forced time for characters to stay outside cover after each shot'
                      ' (E.g. SBS, A2, Raven)\n\n'
                      'Pending verification as A2 seems to stay outside 9 frames longer.',
                  child: Icon(Icons.info_outline, size: 16),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 3,
              children: [
                Text('Fire Timing', style: boldStyle),
                Tooltip(
                  message:
                      'Note: how long during the fire animation until the shot is actually fired'
                      ' (For characters with UP Input Type, E.g. SBS, A2, Raven)\n\n'
                      'Pending verification.',
                  child: Icon(Icons.info_outline, size: 16),
                ),
              ],
            ),
          ],
        ),
        CustomTableRow.fromTexts(
          texts: [
            weapon.penetration != 0 ? 'True' : 'False',
            weapon.maintainFireStance != 0 ? weapon.maintainFireStance.timeString : 'N/A',
            weapon.upTypeFireTiming != 0
                ? '${(weapon.maintainFireStance * toModifier(weapon.upTypeFireTiming)).timeString} (${weapon.upTypeFireTiming.percentString})'
                : 'N/A',
          ],
        ),
      ]);
    }
    return Container(constraints: BoxConstraints(maxWidth: 700), child: CustomTable(children: children));
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
