import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/equipment.dart';
import 'package:nikke_einkk/model/battle/favorite_item.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';
import 'package:nikke_einkk/module/common/slider.dart';
import 'package:nikke_einkk/module/nikkes/nikke_list.dart';

class NikkeSelectorPage extends StatefulWidget {
  final BattleNikkeOptions option;

  const NikkeSelectorPage({super.key, required this.option});

  @override
  State<NikkeSelectorPage> createState() => _NikkeSelectorPageState();
}

class _NikkeSelectorPageState extends State<NikkeSelectorPage> {
  BattleNikkeOptions get option => widget.option;

  @override
  Widget build(BuildContext context) {
    option.errorCorrection();

    final characterData = db.characterResourceGardeTable[option.nikkeResourceId]?[option.coreLevel];
    final weapon = db.characterShotTable[characterData?.shotId];
    final name = db.getTranslation(characterData?.nameLocalkey)?.zhCN;
    final List<Widget> chargeWeaponAdditionalSettings = [
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
    ];
    final optionColumn = Column(
      spacing: 3,
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 5,
              children: [
                Text(name != null ? '$name / ${weapon?.weaponType}' : 'Tap to select Nikke'),
                IconButton(
                  onPressed: () {
                    option.nikkeResourceId = -1;
                    if (mounted) setState(() {});
                  },
                  icon: Icon(Icons.remove_circle, color: Colors.red),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 5,
              children: [
                Text('Sync'),
                SizedBox(
                  width: 100,
                  child: RangedNumberTextField(
                    minValue: 1,
                    maxValue: db.maxSyncLevel,
                    defaultValue: option.syncLevel,
                    onChangeFunction:
                        (newValue) => setState(() {
                          option.syncLevel = newValue;
                        }),
                  ),
                ),
              ],
            ),
            SliderWithPrefix(
              titled: true,
              label: 'Core',
              min: 1,
              max: 11,
              value: option.coreLevel,
              valueFormatter: (v) => coreString(v),
              onChange: (newValue) {
                option.coreLevel = newValue.round();
                if (mounted) setState(() {});
              },
            ),
            SliderWithPrefix(
              titled: true,
              label: 'Attract',
              min: 1,
              max:
                  characterData?.corporationSubType == CorporationSubType.overspec ||
                          characterData?.corporation == Corporation.pilgrim
                      ? 40
                      : 30,
              value: option.attractLevel,
              valueFormatter: (v) => 'Lv$v',
              onChange: (newValue) {
                option.attractLevel = newValue.round();
                if (mounted) setState(() {});
              },
            ),
            ...List.generate(
              3,
              (index) => SliderWithPrefix(
                titled: true,
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
            _buildDollColumn(characterData?.nameCode, weapon?.weaponType),
            ...List.generate(4, (index) => _buildEquipmentOption(characterData, EquipType.values[index + 1])),
            if (WeaponType.chargeWeaponTypes.contains(weapon?.weaponType)) ...chargeWeaponAdditionalSettings,
          ].map((widget) => Padding(padding: const EdgeInsets.all(5), child: widget)).toList(),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Nikke Options')),
      body: Row(
        children: [
          Expanded(
            child: NikkeGrids(
              useGlobal: true,
              onCall: (data) {
                option.nikkeResourceId = data.resourceId;
                if (db.userData.nikkeOptions.containsKey(option.nikkeResourceId)) {
                  option.copyFrom(db.userData.nikkeOptions[option.nikkeResourceId]!);
                }
                if (mounted) setState(() {});
              },
              isSelected: (data) => option.nikkeResourceId == data.resourceId,
            ),
          ),
          Container(width: 250, alignment: Alignment.topLeft, child: SingleChildScrollView(child: optionColumn)),
        ],
      ),
    );
  }

  Widget _buildDollColumn(int? nameCode, WeaponType? weaponType) {
    final doll = option.favoriteItem;
    final allowedRare = [Rarity.unknown, Rarity.r, Rarity.sr];
    if (nameCode != null && db.nameCodeFavItemTable.containsKey(nameCode)) {
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
                        if (nameCode != null && db.nameCodeFavItemTable.containsKey(nameCode)) {
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
                    option.equips[equipListIndex] = BattleEquipment(
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
                                return '$level (${(function.functionValue / 100).toStringAsFixed(2)}%)';
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
