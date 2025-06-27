import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/equipment.dart';
import 'package:nikke_einkk/model/battle/favorite_item.dart';
import 'package:nikke_einkk/model/battle/harmony_cube.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';
import 'package:nikke_einkk/module/common/slider.dart';
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

class NikkeSetupColumn extends StatefulWidget {
  final BattleNikkeOptions option;
  final bool advancedOption;
  const NikkeSetupColumn({super.key, required this.option, this.advancedOption = false});

  @override
  State<NikkeSetupColumn> createState() => _NikkeSetupColumnState();
}

class _NikkeSetupColumnState extends State<NikkeSetupColumn> {
  BattleNikkeOptions get option => widget.option;
  bool get advanced => widget.advancedOption;
  NikkeDatabaseV2 get db => userDb.gameDb;

  static const sliderWidth = 80.0;

  @override
  Widget build(BuildContext context) {
    final groupedData = db.characterResourceGardeTable[option.nikkeResourceId];
    final characterData = groupedData?[option.coreLevel];
    final weapon = db.characterShotTable[characterData?.shotId];
    final coreLevels = groupedData!.keys.sorted((a, b) => a.compareTo(b));
    final showCoreAndAttract = characterData != null && characterData.originalRare != Rarity.r;
    final List<Widget> children = [
      Align(child: NikkeIcon(characterData: characterData, weapon: weapon, isSelected: false)),
      SliderWithPrefix(
        constraint: false,
        titled: false,
        leadingWidth: sliderWidth,
        label: 'Sync',
        min: 1,
        max: db.maxSyncLevel,
        value: option.syncLevel,
        valueFormatter: (v) => 'Lv$v',
        onChange: (newValue) {
          option.syncLevel = newValue.round();

          if (mounted) setState(() {});
        },
      ),
      if (showCoreAndAttract)
        SliderWithPrefix(
          constraint: false,
          titled: false,
          label: 'Core',
          leadingWidth: sliderWidth,
          min: 1,
          max: coreLevels.length,
          value: coreLevels.indexOf(option.coreLevel) + 1,
          valueFormatter: (v) => coreString(v),
          onChange: (newValue) {
            option.coreLevel = coreLevels[newValue.round() - 1];
            option.attractLevel = option.attractLevel.clamp(1, groupedData[option.coreLevel]!.maxAttractLv);
            if (mounted) setState(() {});
          },
        ),
      if (showCoreAndAttract)
        SliderWithPrefix(
          constraint: false,
          titled: false,
          label: 'Attract',
          leadingWidth: sliderWidth,
          min: 1,
          max: characterData.maxAttractLv,
          value: option.attractLevel,
          valueFormatter: (v) => 'Lv$v',
          onChange: (newValue) {
            option.attractLevel = newValue.round();
            if (mounted) setState(() {});
          },
        ),
      const Divider(),
      ...List.generate(
        3,
        (index) => SliderWithPrefix(
          constraint: false,
          titled: false,
          leadingWidth: sliderWidth,
          label: 'Skill ${index + 1}',
          min: 1,
          max: 10,
          value: option.skillLevels[index],
          valueFormatter: (v) => 'Lv$v',
          onChange: (newValue) {
            option.skillLevels[index] = newValue.round();
            if (mounted) setState(() {});
          },
        ),
      ),
      const Divider(),
      _buildCubeColumn(),
    ];

    if (characterData != null && weapon != null) {
      children.addAll([
        const Divider(),
        _buildDollColumn(characterData.nameCode, weapon.weaponType),
        const Divider(),
        ...List.generate(BattleNikkeOptions.equipTypes.length, (index) => _buildEquipmentOption(characterData, index)),
      ]);

      if (widget.advancedOption && WeaponType.chargeWeaponTypes.contains(weapon.weaponType)) {
        children.addAll([const Divider(), _chargeWeaponAdvancedOptionColumn()]);
      }
    }
    return Container(
      padding: const EdgeInsets.all(8.0),
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(spacing: 5, crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _chargeWeaponAdvancedOptionColumn() {
    return Column(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 3,
          children: [
            Text('Always Focus'),
            Switch(
              value: option.alwaysFocus,
              onChanged: (v) {
                option.alwaysFocus = v;
                if (mounted) setState(() {});
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 3,
          children: [
            Text('Cancel Charge Delay'),
            Switch(
              value: option.forceCancelShootDelay,
              onChanged: (v) {
                option.forceCancelShootDelay = v;
                if (mounted) setState(() {});
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 3,
          children: [
            Text('Charge Mode:'),
            DropdownMenu<NikkeFullChargeMode>(
              textStyle: TextStyle(fontSize: 12),
              initialSelection: option.chargeMode,
              onSelected: (NikkeFullChargeMode? value) {
                option.chargeMode = value!;
                setState(() {});
              },
              dropdownMenuEntries:
                  NikkeFullChargeMode.values.map((mode) => DropdownMenuEntry(value: mode, label: mode.name)).toList(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDollColumn(int nameCode, WeaponType weaponType) {
    final doll = option.favoriteItem;
    final allowedRare = [null, Rarity.r, Rarity.sr];
    if (db.nameCodeFavItemTable.containsKey(nameCode)) {
      allowedRare.add(Rarity.ssr);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 5,
      children: [
        SliderWithPrefix(
          constraint: false,
          titled: false,
          leadingWidth: sliderWidth,
          label: 'Doll',
          min: 0,
          max: allowedRare.length - 1,
          value: allowedRare.indexOf(doll?.rarity),
          valueFormatter: (v) => allowedRare[v]?.name.toUpperCase() ?? 'None',
          preferColor: doll?.rarity.color,
          onChange: (newValue) {
            final newRare = allowedRare[newValue.round()];
            if (newRare == null) {
              option.favoriteItem = null;
            } else if (doll != null) {
              doll.rarity = newRare;
              doll.level = doll.level.clamp(0, maxDollLv(newRare));
            } else {
              option.favoriteItem = BattleFavoriteItemOption(weaponType: weaponType, rarity: newRare, level: 0);
            }

            setState(() {});
          },
        ),
        if (doll != null)
          SliderWithPrefix(
            constraint: false,
            titled: false,
            leadingWidth: sliderWidth,
            label: 'Doll Lv',
            min: 0,
            max: maxDollLv(doll.rarity),
            value: doll.level,
            valueFormatter: (v) => dollLvString(doll.rarity, v),
            preferColor: doll.rarity.color,
            onChange: (newValue) {
              doll.level = newValue.round();
              if (mounted) setState(() {});
            },
          ),
      ],
    );
  }

  Widget _buildCubeColumn() {
    final cubeOption = option.cube;
    final availableCubes = [
      null,
      ...db.harmonyCubeTable.values.sorted((a, b) => a.order.compareTo(b.order)).map((data) => data.id),
    ];
    final cube = db.harmonyCubeTable[cubeOption?.cubeId];
    final cubeEnhanceData = db.harmonyCubeEnhanceLvTable[cube?.levelEnhanceId];

    final List<Widget> children = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Harmony Cube: '),
          DropdownMenu<int?>(
            textStyle: TextStyle(fontSize: 14),
            initialSelection: cubeOption?.cubeId,
            onSelected: (int? value) {
              if (value == null) {
                option.cube = null;
              } else if (cubeOption == null) {
                option.cube = BattleHarmonyCubeOption(value, 1);
              } else {
                cubeOption.cubeId = value;
              }
              setState(() {});
            },
            dropdownMenuEntries:
                availableCubes
                    .map(
                      (id) => DropdownMenuEntry(
                        value: id,
                        label: locale.getTranslation(db.harmonyCubeTable[id]?.nameLocalkey) ?? 'None',
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    ];
    if (cubeOption != null && cube != null && cubeEnhanceData != null) {
      final colorCode = int.tryParse('0xFF${cube.bgColor}');
      children.add(
        SliderWithPrefix(
          constraint: false,
          titled: false,
          leadingWidth: sliderWidth,
          label: 'Cube Lv',
          min: 1,
          max: cubeEnhanceData.keys.sorted((a, b) => a.compareTo(b)).last,
          value: cubeOption.cubeLevel,
          valueFormatter: (v) => 'Lv${cubeOption.cubeLevel}',
          preferColor: colorCode != null ? Color(colorCode) : null,
          onChange: (newValue) {
            cubeOption.cubeLevel = newValue.round();
            if (mounted) setState(() {});
          },
        ),
      );
      final cubeLevelData = cubeEnhanceData[cubeOption.cubeLevel]!;
      final List<Widget> wrapChildren = [];
      for (int idx = 0; idx < cubeLevelData.skillLevels.length; idx += 1) {
        if (cube.harmonyCubeSkillGroups.length > idx && cubeLevelData.skillLevels.length > idx) {
          final skillGroupId = cube.harmonyCubeSkillGroups[idx].skillGroupId;
          final skillLv = cubeLevelData.skillLevels[idx].level;
          if (skillGroupId == 0 || skillLv == 0) continue;

          final skillInfo = db.groupedSkillInfoTable[skillGroupId]?[skillLv];
          if (skillInfo == null) {
            wrapChildren.add(Text('Cube skill group $skillGroupId Lv $skillLv not found.'));
          } else {
            wrapChildren.addAll([
              Tooltip(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                richMessage: TextSpan(
                  children: buildDescriptionTextSpans(
                    formatSkillInfoDescription(skillInfo),
                    DefaultTextStyle.of(context).style,
                    db,
                  ),
                ),
                child: Icon(Icons.info_outline, size: 16),
              ),
              Text(locale.getTranslation(skillInfo.nameLocalkey) ?? skillInfo.nameLocalkey),
              Text('Lv$skillLv'),
            ]);
          }
        }
      }
      children.add(
        Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5,
          children: wrapChildren,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: children,
    );
  }

  Widget _buildEquipmentOption(NikkeCharacterData characterData, int equipListIndex) {
    final equipOption = option.equips[equipListIndex];
    final allowedEquipRares = [
      null,
      EquipRarity.t1,
      EquipRarity.t2,
      EquipRarity.t3,
      EquipRarity.t4,
      EquipRarity.t5,
      EquipRarity.t6,
      EquipRarity.t7,
      EquipRarity.t8,
      EquipRarity.t9,
      EquipRarity.t10,
    ];

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: equipOption?.rarity.color ?? Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          SliderWithPrefix(
            constraint: false,
            titled: false,
            leadingWidth: sliderWidth,
            label: '${BattleNikkeOptions.equipTypes[equipListIndex].name.pascal} Gear',
            min: 0,
            max: allowedEquipRares.length - 1,
            value: allowedEquipRares.indexOf(equipOption?.rarity),
            valueFormatter: (v) => allowedEquipRares[v]?.name.toUpperCase() ?? 'None',
            preferColor: equipOption?.rarity.color,
            onChange: (newValue) {
              final newRare = allowedEquipRares[newValue.round()];
              if (newRare == null) {
                option.equips[equipListIndex] = null;
              } else if (equipOption == null) {
                option.equips[equipListIndex] = BattleEquipmentOption(
                  type: BattleNikkeOptions.equipTypes[equipListIndex],
                  equipClass: characterData.characterClass,
                  rarity: newRare,
                  corporation: newRare.canHaveCorp ? characterData.corporation : Corporation.none,
                );
              } else {
                equipOption.rarity = newRare;
                equipOption.level = equipOption.level.clamp(0, newRare.maxLevel);
                if (!newRare.canHaveCorp) {
                  equipOption.corporation = Corporation.none;
                }
                if (newRare != EquipRarity.t10) {
                  equipOption.equipLines.clear();
                } else {
                  equipOption.equipLines.addAll(List.generate(3, (idx) => EquipLine.none()));
                }
              }

              setState(() {});
            },
          ),
          SliderWithPrefix(
            constraint: false,
            titled: false,
            leadingWidth: sliderWidth,
            label: 'Gear Lv',
            min: 0,
            max: equipOption?.rarity.maxLevel ?? 0,
            value: equipOption?.level ?? 0,
            valueFormatter: (v) => 'Lv$v',
            preferColor: equipOption?.rarity.color,
            onChange: (newValue) {
              equipOption?.level = newValue.round();
              if (mounted) setState(() {});
            },
          ),
          if (equipOption?.rarity.canHaveCorp ?? false)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 5,
              children: [
                Checkbox(
                  value: equipOption?.corporation == characterData.corporation,
                  onChanged: (v) {
                    equipOption?.corporation = v! ? characterData.corporation : Corporation.none;
                    if (mounted) setState(() {});
                  },
                ),
                Text('Use Corporation Label: ${equipOption?.corporation.name.toUpperCase()}'),
              ],
            ),
          if (equipOption != null && equipOption.rarity == EquipRarity.t10)
            ...List.generate(equipOption.equipLines.length, (index) {
              final equipLine = equipOption.equipLines[index];
              final level = equipOption.equipLines[index].level;
              final lineRare =
                  level > 10
                      ? Colors.orange
                      : level > 5
                      ? Colors.purple
                      : Colors.blue;
              final levelTextColor = level >= 12 ? Colors.blue : null;
              return Container(
                padding: const EdgeInsets.all(8.0),
                constraints: BoxConstraints(minWidth: double.infinity),
                decoration: BoxDecoration(
                  border: Border.all(color: lineRare, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 5,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Equip Line Type: '),
                        DropdownMenu<EquipLineType>(
                          textStyle: TextStyle(fontSize: 14),
                          initialSelection: equipLine.type,
                          onSelected: (EquipLineType? value) {
                            equipLine.type = value!;
                            if (equipLine.type == EquipLineType.none) {
                              equipLine.level = 1;
                            }
                            setState(() {});
                          },
                          dropdownMenuEntries:
                              EquipLineType.values
                                  .map((type) => DropdownMenuEntry(value: type, label: type.toString()))
                                  .toList(),
                        ),
                      ],
                    ),
                    if (equipLine.type != EquipLineType.none)
                      SliderWithPrefix(
                        constraint: false,
                        titled: false,
                        leadingWidth: sliderWidth,
                        label: 'Lv$level',
                        valueFormatter: (level) {
                          final stateEffectData = db.stateEffectTable[equipOption.equipLines[index].getStateEffectId()];
                          if (stateEffectData != null) {
                            for (final functionId in stateEffectData.functions) {
                              if (functionId.function != 0) {
                                final function = db.functionTable[functionId.function]!;
                                return function.functionValue.percentString;
                              }
                            }
                          }
                          return level.toString();
                        },
                        min: 1,
                        max: 15,
                        value: level,
                        preferColor: lineRare,
                        preferLabelColor: levelTextColor,
                        onChange: (newValue) {
                          equipLine.level = newValue.round();
                          if (mounted) setState(() {});
                        },
                      ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
