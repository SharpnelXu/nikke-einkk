import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/equipment.dart';
import 'package:nikke_einkk/model/battle/favorite_item.dart';
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
    ];

    if (characterData != null && weapon != null) {
      final coreLevels = groupedData!.keys.sorted((a, b) => a.compareTo(b));

      children.addAll([
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
        // _buildDollColumn(characterData.nameCode, weapon.weaponType),
        // ...List.generate(4, (index) => _buildEquipmentOption(characterData, EquipType.values[index + 1])),
        // if (widget.advancedOption && WeaponType.chargeWeaponTypes.contains(weapon.weaponType))
        //   _chargeWeaponAdvancedOptionColumn(),
      ]);
    }
    return Container(
      padding: const EdgeInsets.all(8.0),
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(spacing: 5, crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _chargeWeaponAdvancedOptionColumn() {
    return Column(
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
        Text('Charge Mode:'),
        DropdownMenu<NikkeFullChargeMode>(
          textStyle: TextStyle(fontSize: 12),
          initialSelection: option.chargeMode,
          onSelected: (NikkeFullChargeMode? value) {
            option.chargeMode = value!;
            setState(() {});
          },
          dropdownMenuEntries: UnmodifiableListView<DropdownMenuEntry<NikkeFullChargeMode>>(
            NikkeFullChargeMode.values.map<DropdownMenuEntry<NikkeFullChargeMode>>(
              (NikkeFullChargeMode mode) => DropdownMenuEntry<NikkeFullChargeMode>(value: mode, label: mode.name),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDollColumn(int nameCode, WeaponType? weaponType) {
    final doll = option.favoriteItem;
    final allowedRare = [Rarity.unknown, Rarity.r, Rarity.sr];
    if (db.nameCodeFavItemTable.containsKey(nameCode)) {
      allowedRare.add(Rarity.ssr);
    }
    final entries = UnmodifiableListView<DropdownMenuEntry<Rarity>>(
      allowedRare.map<DropdownMenuEntry<Rarity>>(
        (Rarity rare) =>
            DropdownMenuEntry<Rarity>(value: rare, label: rare == Rarity.unknown ? 'None' : rare.name.toUpperCase()),
      ),
    );
    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: doll?.rarity.color ?? Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        spacing: 2,
        children:
            [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 3,
                children: [
                  Text('Doll'),
                  DropdownMenu<Rarity>(
                    width: 100,
                    textStyle: TextStyle(fontSize: 12),
                    initialSelection: option.favoriteItem?.rarity ?? Rarity.unknown,
                    onSelected: (Rarity? value) {
                      if (value == Rarity.unknown) {
                        option.favoriteItem = null;
                      } else if (doll != null) {
                        doll.rarity = value!;
                      } else {
                        option.favoriteItem = BattleFavoriteItem(
                          weaponType: weaponType ?? WeaponType.unknown,
                          rarity: value!,
                          level: 0,
                        );
                      }
                      if (value == Rarity.ssr) {
                        if (db.nameCodeFavItemTable.containsKey(nameCode)) {
                          option.favoriteItem!.nameCode = nameCode;
                        } else {
                          option.favoriteItem!.nameCode = 0;
                          option.favoriteItem!.rarity = Rarity.sr;
                        }
                      } else {
                        option.favoriteItem!.nameCode = 0;
                      }
                      setState(() {});
                    },
                    dropdownMenuEntries: entries,
                  ),
                ],
              ),
              SliderWithPrefix(
                titled: true,
                label: 'Lv',
                min: 0,
                max:
                    doll == null
                        ? 0
                        : doll.rarity == Rarity.ssr
                        ? 2
                        : 15,
                value: doll?.level ?? 0,
                valueFormatter: (v) {
                  if (doll == null) {
                    return v.toString();
                  }

                  if (doll.rarity == Rarity.ssr) {
                    String result = '★';
                    for (int i = 0; i < v; i += 1) {
                      result += '★';
                    }
                    for (int i = v; i < 2; i += 1) {
                      result += '☆';
                    }
                    return result;
                  } else {
                    return v.toString();
                  }
                },
                onChange: (newValue) {
                  if (doll != null) {
                    doll.level = newValue.round();
                    if (mounted) setState(() {});
                  }
                },
              ),
            ].map((widget) => Padding(padding: const EdgeInsets.all(3.0), child: widget)).toList(),
      ),
    );
  }

  static final List<DropdownMenuEntry<EquipRarity>> equipRareEntries =
      UnmodifiableListView<DropdownMenuEntry<EquipRarity>>(
        EquipRarity.values.map<DropdownMenuEntry<EquipRarity>>(
          (EquipRarity rare) => DropdownMenuEntry<EquipRarity>(
            value: rare,
            label: rare == EquipRarity.unknown ? 'None' : rare.name.toUpperCase(),
          ),
        ),
      );

  static final List<DropdownMenuEntry<EquipLineType>> equipLineTypeEntries =
      UnmodifiableListView<DropdownMenuEntry<EquipLineType>>(
        EquipLineType.values.map<DropdownMenuEntry<EquipLineType>>(
          (EquipLineType type) => DropdownMenuEntry<EquipLineType>(value: type, label: type.toString()),
        ),
      );

  Widget _buildEquipmentOption(NikkeCharacterData? characterData, EquipType type) {
    final nikkeClass = characterData?.characterClass;
    final corp = characterData?.corporation;
    final equipListIndex = type.index - 1;
    final equipment = option.equips[equipListIndex];
    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: equipment?.rarity.color ?? Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        spacing: 2,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 3,
            children: [
              Text('${type.name.toUpperCase()} Gear:'),
              DropdownMenu<EquipRarity>(
                width: 100,
                textStyle: TextStyle(fontSize: 12),
                initialSelection: equipment?.rarity ?? EquipRarity.unknown,
                onSelected: (EquipRarity? value) {
                  if (equipment == null) {
                    option.equips[equipListIndex] = BattleEquipmentOption(
                      type: type,
                      equipClass: nikkeClass ?? NikkeClass.unknown,
                      rarity: value!,
                    );
                  } else {
                    equipment.rarity = value!;
                  }
                  setState(() {});
                },
                dropdownMenuEntries: equipRareEntries,
              ),
            ],
          ),
          SliderWithPrefix(
            titled: true,
            label: 'Lv',
            min: 0,
            max: equipment?.rarity.maxLevel ?? 0,
            value: equipment?.level ?? 0,
            onChange: (newValue) {
              equipment?.level = newValue.round();
              if (mounted) setState(() {});
            },
          ),
          if (equipment?.rarity.canHaveCorp ?? false)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 3,
              children: [
                Text('Corp ${equipment?.corporation.name}'),
                Switch(
                  value: equipment?.corporation == corp,
                  onChanged: (v) {
                    equipment?.corporation = v && characterData != null ? characterData.corporation : Corporation.none;
                    if (mounted) setState(() {});
                  },
                ),
              ],
            ),
          if (equipment != null && equipment.rarity == EquipRarity.t10)
            ...List.generate(equipment.equipLines.length, (index) {
              final level = equipment.equipLines[index].level;
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        level > 10
                            ? Colors.orange
                            : level > 5
                            ? Colors.purple
                            : Colors.blue,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(5),
                  color: level == 15 ? Colors.black.withAlpha(200) : null,
                ),
                child: Column(
                  spacing: 3,
                  children:
                      [
                        DropdownMenu<EquipLineType>(
                          textStyle: TextStyle(fontSize: 12, color: level == 15 ? Colors.blue : null),
                          initialSelection: equipment.equipLines[index].type,
                          onSelected: (EquipLineType? value) {
                            equipment.equipLines[index].type = value!;
                            setState(() {});
                          },
                          dropdownMenuEntries: equipLineTypeEntries,
                        ),
                        SliderWithPrefix(
                          titled: true,
                          label: 'Lv',
                          valueFormatter: (level) {
                            final stateEffectData = db.stateEffectTable[equipment.equipLines[index].getStateEffectId()];
                            if (stateEffectData == null) {
                              return level.toString();
                            }
                            for (final functionId in stateEffectData.functions) {
                              if (functionId.function != 0) {
                                final function = db.functionTable[functionId.function]!;
                                return '$level (${function.functionValue.percentString})';
                              }
                            }
                            return level.toString();
                          },
                          labelStyle: TextStyle(color: level >= 12 ? Colors.blue : null),
                          min: 1,
                          max: 15,
                          value: level,
                          onChange: (newValue) {
                            equipment.equipLines[index].level = newValue.round();
                            if (mounted) setState(() {});
                          },
                        ),
                      ].map((widget) => Padding(padding: const EdgeInsets.all(3.0), child: widget)).toList(),
                ),
              );
            }),
        ],
      ),
    );
  }
}
