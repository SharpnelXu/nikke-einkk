import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/equipment.dart';
import 'package:nikke_einkk/model/favorite_item.dart';
import 'package:nikke_einkk/model/harmony_cube.dart';
import 'package:nikke_einkk/model/items.dart';
import 'package:nikke_einkk/model/user_data.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';
import 'package:nikke_einkk/module/common/slider.dart';

class NikkeSetupColumn extends StatefulWidget {
  final NikkeOptions option;
  final Map<int, int> cubeLvs;
  final bool advancedOption;
  final bool useGlobal;
  const NikkeSetupColumn({
    super.key,
    required this.option,
    this.advancedOption = false,
    this.useGlobal = true,
    required this.cubeLvs,
  });

  @override
  State<NikkeSetupColumn> createState() => _NikkeSetupColumnState();
}

class _NikkeSetupColumnState extends State<NikkeSetupColumn> {
  NikkeOptions get option => widget.option;
  bool get advanced => widget.advancedOption;
  bool get useGlobal => widget.useGlobal;
  NikkeDatabase get db => useGlobal ? global : cn;
  Map<int, int> get cubeLvs => widget.cubeLvs;

  static const sliderWidth = 80.0;

  @override
  Widget build(BuildContext context) {
    final groupedData = db.characterResourceGardeTable[option.nikkeResourceId];
    final characterData = groupedData?[option.coreLevel];
    final weapon = db.characterShotTable[characterData?.shotId];
    final List<Widget> children = [
      Align(
        child: FilledButton(
          onPressed: () {
            if (characterData != null && weapon != null) {
              option.coreLevel = groupedData!.keys.fold(0, max);
              option.attractLevel = groupedData[option.coreLevel]!.maxAttractLv;
              option.skillLevels = [10, 10, 10];
              if (option.cube != null) {
                final cube = db.harmonyCubeTable[option.cube?.cubeId];
                final cubeEnhanceData = db.harmonyCubeEnhanceLvTable[cube?.levelEnhanceId];
                if (cubeEnhanceData != null) {
                  option.cube!.cubeLevel = cubeEnhanceData.keys.fold(1, max);
                }
              }
              final dollRare = db.nameCodeFavItemTable.containsKey(characterData.nameCode) ? Rarity.ssr : Rarity.sr;
              final dollLv = maxDollLv(dollRare);
              final nameCode = dollRare == Rarity.ssr ? characterData.nameCode : 0;
              option.favoriteItem = FavoriteItemOption(
                weaponType: weapon.weaponType,
                rarity: dollRare,
                level: dollLv,
                nameCode: nameCode,
              );
              for (int idx = 0; idx < NikkeOptions.equipTypes.length; idx += 1) {
                option.equips[idx] = EquipmentOption(
                  type: NikkeOptions.equipTypes[idx],
                  equipClass: characterData.characterClass,
                  rarity: EquipRarity.t10,
                  level: 5,
                );
              }

              setState(() {});
            }
          },
          child: Text('Maximize Setup'),
        ),
      ),
      NikkeBasicSetupWidgets(option: option, useGlobal: useGlobal),
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
        ...List.generate(NikkeOptions.equipTypes.length, (index) => _buildEquipmentOption(characterData, index)),
      ]);

      if (advanced) {
        children.addAll([
          const Divider(),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 5,
            children: [
              Text('Set Core Hit Rate'),
              Checkbox(
                value: option.coreHitRate != null,
                onChanged: (v) {
                  setState(() {
                    if (v == true) {
                      option.coreHitRate = 100;
                    } else if (v == false) {
                      option.coreHitRate = null;
                    }
                  });
                },
              ),
              SliderWithPrefix(
                constraint: false,
                titled: false,
                leadingWidth: sliderWidth,
                label: 'Core %',
                min: 0,
                max: 100,
                value: option.coreHitRate?.round() ?? 100,
                valueFormatter: (v) => '$v%',
                onChange:
                    option.coreHitRate == null
                        ? null
                        : (newValue) {
                          option.coreHitRate = newValue;
                          if (mounted) setState(() {});
                        },
              ),
            ],
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 5,
            children: [
              Text('Set Hit Rate Threshold'),
              Checkbox(
                value: option.customHitRateThreshold != null,
                onChanged: (v) {
                  setState(() {
                    if (v == true) {
                      option.customHitRateThreshold = weapon.startAccuracyCircleScale;
                    } else if (v == false) {
                      option.customHitRateThreshold = null;
                    }
                  });
                },
              ),
              Text(
                'If accuracy is above this threshold, make some pellets miss',
                style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 14),
              ),
              Tooltip(
                richMessage: WidgetSpan(
                  child: Container(
                    height: max(1, (option.customHitRateThreshold ?? weapon.startAccuracyCircleScale) * 0.75),
                    width: max(1, (option.customHitRateThreshold ?? weapon.startAccuracyCircleScale) * 0.75),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 3),
                      color: null,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                child: Icon(Icons.info_outline, size: 16),
              ),
              SliderWithPrefix(
                constraint: false,
                titled: false,
                leadingWidth: sliderWidth,
                label: 'Accuracy',
                min: 1,
                max: weapon.startAccuracyCircleScale,
                value: option.customHitRateThreshold ?? weapon.startAccuracyCircleScale,
                valueFormatter: (v) => '$v',
                onChange:
                    option.customHitRateThreshold == null
                        ? null
                        : (newValue) {
                          option.customHitRateThreshold = newValue.round();
                          if (mounted) setState(() {});
                        },
              ),
            ],
          ),
          if (option.customHitRateThreshold != null)
            SliderWithPrefix(
              constraint: false,
              titled: false,
              leadingWidth: sliderWidth,
              label: 'Hit %',
              min: 0,
              max: 100,
              value: option.customHitRate?.round() ?? 100,
              valueFormatter: (v) => '$v%',
              onChange: (newValue) {
                option.customHitRate = newValue;
                if (mounted) setState(() {});
              },
            ),
        ]);
        if (weapon.weaponType.isCharge) {
          children.addAll([const Divider(), _chargeWeaponAdvancedOptionColumn()]);
        }
      }
    }
    return Container(
      padding: const EdgeInsets.all(8.0),
      constraints: const BoxConstraints(maxWidth: 700),
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
            final newNameCode = newRare == Rarity.ssr ? nameCode : 0;
            if (newRare == null) {
              option.favoriteItem = null;
            } else if (doll != null) {
              doll.rarity = newRare;
              doll.level = doll.level.clamp(0, maxDollLv(newRare));
              doll.nameCode = newNameCode;
            } else {
              option.favoriteItem = FavoriteItemOption(
                weaponType: weaponType,
                rarity: newRare,
                level: 0,
                nameCode: newNameCode,
              );
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
                option.cube = HarmonyCubeOption(value, cubeLvs[value] ?? 1);
              } else {
                cubeOption.cubeId = value;
                cubeOption.cubeLevel = cubeLvs[value] ?? cubeOption.cubeLevel;
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
          max: cubeEnhanceData.keys.fold(1, max),
          value: cubeOption.cubeLevel,
          valueFormatter: (v) => 'Lv${cubeOption.cubeLevel}',
          preferColor: colorCode != null ? Color(colorCode) : null,
          onChange: (newValue) {
            cubeOption.cubeLevel = newValue.round();
            if (mounted) setState(() {});
          },
        ),
      );

      final List<Widget> wrapChildren = [];
      for (final tuple in cubeOption.getValidCubeSkills(db)) {
        final skillGroupId = tuple.$1;
        final skillLv = tuple.$2;

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
            label: '${NikkeOptions.equipTypes[equipListIndex].name.pascal} Gear',
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
                option.equips[equipListIndex] = EquipmentOption(
                  type: NikkeOptions.equipTypes[equipListIndex],
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
                  while (equipOption.equipLines.length < 3) {
                    equipOption.equipLines.add(EquipLine.none());
                  }
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
                            if (value == EquipLineType.none) {
                              equipLine.level = 1;
                            } else if (equipLine.type == EquipLineType.none) {
                              equipLine.level = 11;
                            }
                            equipLine.type = value!;
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

class NikkeBasicSetupWidgets extends StatefulWidget {
  final NikkeOptions option;
  final bool useGlobal;
  final void Function()? onChange;

  const NikkeBasicSetupWidgets({super.key, required this.option, this.useGlobal = true, this.onChange});

  @override
  State<NikkeBasicSetupWidgets> createState() => _NikkeBasicSetupWidgetsState();
}

class _NikkeBasicSetupWidgetsState extends State<NikkeBasicSetupWidgets> {
  NikkeOptions get option => widget.option;
  NikkeDatabase get db => widget.useGlobal ? global : cn;
  void Function()? get onChange => widget.onChange;

  static const sliderWidth = 80.0;
  @override
  Widget build(BuildContext context) {
    final groupedData = db.characterResourceGardeTable[option.nikkeResourceId];
    final characterData = groupedData?[option.coreLevel];
    final List<Widget> children = [
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

          if (onChange != null) onChange!();
          if (mounted) setState(() {});
        },
      ),
    ];

    final showCoreAndAttract = characterData != null && characterData.originalRare != Rarity.r;
    if (showCoreAndAttract) {
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
            if (onChange != null) onChange!();
            if (mounted) setState(() {});
          },
        ),
        SliderWithPrefix(
          constraint: false,
          titled: false,
          label: 'Bond',
          leadingWidth: sliderWidth,
          min: 1,
          max: characterData.maxAttractLv,
          value: option.attractLevel,
          valueFormatter: (v) => 'Lv$v',
          onChange: (newValue) {
            option.attractLevel = newValue.round();
            if (onChange != null) onChange!();
            if (mounted) setState(() {});
          },
        ),
      ]);
    }

    return Column(spacing: 5, crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }
}
