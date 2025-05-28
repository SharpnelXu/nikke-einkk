import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nikke_einkk/model/battle/equipment.dart';
import 'package:nikke_einkk/model/battle/favorite_item.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';
import 'package:nikke_einkk/module/common/slider.dart';

class NikkeSelectorPage extends StatefulWidget {
  final BattleNikkeOptions option;

  const NikkeSelectorPage({super.key, required this.option});

  @override
  State<NikkeSelectorPage> createState() => _NikkeSelectorPageState();
}

class _NikkeSelectorPageState extends State<NikkeSelectorPage> {
  BattleNikkeOptions get option => widget.option;
  NikkeFilterData filterData = NikkeFilterData();
  ScrollController scrollController = ScrollController();
  bool extraFilters = false;

  @override
  Widget build(BuildContext context) {
    option.errorCorrection();

    final defaultFilterButtonRow = IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 8,
          children: [
            IconButton(
              onPressed: () {
                filterData.reset();
                if (mounted) setState(() {});
              },
              icon: const Icon(Icons.refresh_outlined),
            ),
            IconButton(
              onPressed: () {
                extraFilters = !extraFilters;
                if (mounted) setState(() {});
              },
              icon: Icon(Icons.filter_alt, color: extraFilters ? Colors.black : Colors.grey),
            ),
            const VerticalDivider(width: 5, color: Colors.grey),
            Text('Burst: '),
            ...List.generate(NikkeFilterData.defaultBurstSteps.length, (index) {
              final buttonStep = NikkeFilterData.defaultBurstSteps[index];
              final enabled = filterData.burstSteps.contains(buttonStep);
              return FilledButton(
                style: FilledButton.styleFrom(
                  foregroundColor: enabled ? Colors.white : Colors.black,
                  backgroundColor: enabled ? Colors.blue : Colors.white,
                ),
                onPressed: () {
                  if (enabled) {
                    filterData.burstSteps.remove(buttonStep);
                  } else {
                    filterData.burstSteps.add(buttonStep);
                  }
                  if (mounted) setState(() {});
                },
                child: Text(buttonStep.toString()),
              );
            }),
          ],
        ),
      ),
    );

    final cropFilterRow = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 8,
        children: [
          Text('Corporation: '),
          ...List.generate(NikkeFilterData.defaultCorps.length, (index) {
            final buttonCorp = NikkeFilterData.defaultCorps[index];
            final enabled = filterData.corps.contains(buttonCorp);
            return FilledButton(
              style: FilledButton.styleFrom(
                foregroundColor: enabled ? Colors.white : Colors.black,
                backgroundColor: enabled ? Colors.blue : Colors.white,
              ),
              onPressed: () {
                if (enabled) {
                  filterData.corps.remove(buttonCorp);
                } else {
                  filterData.corps.add(buttonCorp);
                }
                if (mounted) setState(() {});
              },
              child: Text(buttonCorp.name.toUpperCase()),
            );
          }),
        ],
      ),
    );

    final elementsFilterRow = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 8,
        children: [
          Text('Element: '),
          ...List.generate(NikkeFilterData.defaultElements.length, (index) {
            final buttonEle = NikkeFilterData.defaultElements[index];
            final enabled = filterData.elements.contains(buttonEle);
            return FilledButton(
              style: FilledButton.styleFrom(
                foregroundColor: enabled ? Colors.white : Colors.black,
                backgroundColor: enabled ? buttonEle.color : Colors.white,
              ),
              onPressed: () {
                if (enabled) {
                  filterData.elements.remove(buttonEle);
                } else {
                  filterData.elements.add(buttonEle);
                }
                if (mounted) setState(() {});
              },
              child: Text(buttonEle.name.toUpperCase()),
            );
          }),
        ],
      ),
    );

    final weaponTypeFilterRow = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 8,
        children: [
          Text('Weapon Type: '),
          ...List.generate(NikkeFilterData.defaultWeaponTypes.length, (index) {
            final buttonType = NikkeFilterData.defaultWeaponTypes[index];
            final enabled = filterData.weaponTypes.contains(buttonType);
            return FilledButton(
              style: FilledButton.styleFrom(
                foregroundColor: enabled ? Colors.white : Colors.black,
                backgroundColor: enabled ? Colors.blue : Colors.white,
              ),
              onPressed: () {
                if (enabled) {
                  filterData.weaponTypes.remove(buttonType);
                } else {
                  filterData.weaponTypes.add(buttonType);
                }
                if (mounted) setState(() {});
              },
              child: Text(buttonType.name.toUpperCase()),
            );
          }),
        ],
      ),
    );

    final classFilterRow = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 8,
        children: [
          Text('Class: '),
          ...List.generate(NikkeFilterData.defaultClasses.length, (index) {
            final buttonType = NikkeFilterData.defaultClasses[index];
            final enabled = filterData.classes.contains(buttonType);
            return FilledButton(
              style: FilledButton.styleFrom(
                foregroundColor: enabled ? Colors.white : Colors.black,
                backgroundColor: enabled ? Colors.blue : Colors.white,
              ),
              onPressed: () {
                if (enabled) {
                  filterData.classes.remove(buttonType);
                } else {
                  filterData.classes.add(buttonType);
                }
                if (mounted) setState(() {});
              },
              child: Text(buttonType.name.toUpperCase()),
            );
          }),
        ],
      ),
    );

    final rarityRow = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 8,
        children: [
          Text('Rarity: '),
          ...List.generate(NikkeFilterData.defaultRarity.length, (index) {
            final buttonType = NikkeFilterData.defaultRarity[index];
            final enabled = filterData.rarity.contains(buttonType);
            return FilledButton(
              style: FilledButton.styleFrom(
                foregroundColor: enabled ? Colors.white : Colors.black,
                backgroundColor: enabled ? buttonType.color : Colors.white,
              ),
              onPressed: () {
                if (enabled) {
                  filterData.rarity.remove(buttonType);
                } else {
                  filterData.rarity.add(buttonType);
                }
                if (mounted) setState(() {});
              },
              child: Text(buttonType.name.toUpperCase()),
            );
          }),
        ],
      ),
    );

    final filterList = Expanded(
      child: Column(
        children: [
          defaultFilterButtonRow,
          if (extraFilters) elementsFilterRow,
          if (extraFilters) weaponTypeFilterRow,
          if (extraFilters) cropFilterRow,
          if (extraFilters) classFilterRow,
          if (extraFilters) rarityRow,
          Expanded(
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverGrid.extent(
                  maxCrossAxisExtent: 144,
                  children:
                      db.characterResourceGardeTable.values
                          .where((groupedData) => filterData.shouldInclude(groupedData))
                          .map((groupedData) => _buildGrid(groupedData))
                          .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );

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
              max: characterData?.corporationSubType == CorporationSubType.overspec ? 40 : 30,
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
          filterList,
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

  Widget _buildGrid(Map<int, NikkeCharacterData> groupedData) {
    final characterData = groupedData.values.last;
    final isSelected = option.nikkeResourceId == characterData.resourceId;
    return InkWell(
      onTap: () {
        option.nikkeResourceId = characterData.resourceId;
        if (db.userData.nikkeOptions.containsKey(option.nikkeResourceId)) {
          option.copyFrom(db.userData.nikkeOptions[option.nikkeResourceId]!);
        }
        if (mounted) setState(() {});
      },
      child: buildNikkeIcon(characterData, isSelected),
    );
  }
}

class NikkeFilterData {
  static List<BurstStep> defaultBurstSteps = [BurstStep.step1, BurstStep.step2, BurstStep.step3];
  static List<Corporation> defaultCorps = [
    Corporation.elysion,
    Corporation.missilis,
    Corporation.tetra,
    Corporation.pilgrim,
    Corporation.abnormal,
  ];
  static List<NikkeElement> defaultElements = NikkeElement.values.where((ele) => ele != NikkeElement.unknown).toList();
  static List<WeaponType> defaultWeaponTypes =
      WeaponType.values.where((type) => type != WeaponType.none && type != WeaponType.unknown).toList();
  static List<NikkeClass> defaultClasses = [NikkeClass.attacker, NikkeClass.defender, NikkeClass.supporter];
  static List<Rarity> defaultRarity = [Rarity.ssr, Rarity.sr, Rarity.r];

  List<BurstStep> burstSteps = [];
  List<Corporation> corps = [];
  List<NikkeElement> elements = [];
  List<NikkeClass> classes = [];
  List<WeaponType> weaponTypes = [];
  List<Rarity> rarity = [Rarity.ssr];

  bool shouldInclude(Map<int, NikkeCharacterData> gradeToCharData) {
    final characterData = gradeToCharData.values.last;
    final weapon = db.characterShotTable[characterData.shotId];
    return (burstSteps.isEmpty ||
            characterData.useBurstSkill == BurstStep.allStep ||
            burstSteps.contains(characterData.useBurstSkill)) &&
        (corps.isEmpty || corps.contains(characterData.corporation)) &&
        (elements.isEmpty || characterData.elementId.any((eleId) => elements.contains(NikkeElement.fromId(eleId)))) &&
        (classes.isEmpty || classes.contains(characterData.characterClass)) &&
        (weaponTypes.isEmpty || weaponTypes.contains(weapon?.weaponType)) &&
        (rarity.isEmpty || rarity.contains(characterData.originalRare));
  }

  void reset() {
    burstSteps.clear();
    corps.clear();
    elements.clear();
    classes.clear();
    weaponTypes.clear();
    rarity.clear();
    rarity.add(Rarity.ssr);
  }
}

class RangedNumberTextField extends StatefulWidget {
  final int defaultValue;
  final int minValue;
  final int maxValue;
  final void Function(int newValue)? onChangeFunction;

  const RangedNumberTextField({
    super.key,
    this.defaultValue = 1, // Default value when empty
    this.minValue = 1,
    required this.maxValue,
    this.onChangeFunction,
  });

  @override
  State<RangedNumberTextField> createState() => _RangedNumberTextFieldState();
}

class _RangedNumberTextFieldState extends State<RangedNumberTextField> {
  String? _errorText;
  final TextEditingController controller = TextEditingController();
  int get minLevel => widget.minValue;
  int get maxLevel => widget.maxValue;
  int get defaultValue => widget.defaultValue;

  @override
  void initState() {
    super.initState();
    // Initialize with default value if empty
    if (controller.text.isEmpty) {
      controller.text = defaultValue.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _NumberRangeInputFormatter(min: minLevel, max: maxLevel, defaultValue: defaultValue),
      ],
      decoration: InputDecoration(
        hintText: 'Enter a number ($minLevel-$maxLevel)',
        errorText: _errorText,
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        if (value.isEmpty) {
          // Immediately restore default value when empty
          controller.text = defaultValue.toString();
          controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
        }

        final numValue = int.tryParse(value);
        if (numValue == null || numValue < minLevel || numValue > maxLevel) {
          setState(() => _errorText = 'Number must be between $minLevel and $maxLevel');
        } else {
          setState(() {
            _errorText = null;
            if (widget.onChangeFunction != null) widget.onChangeFunction!(numValue);
          });
        }
      },
    );
  }
}

class _NumberRangeInputFormatter extends TextInputFormatter {
  final int min;
  final int max;
  final int defaultValue;

  _NumberRangeInputFormatter({required this.min, required this.max, this.defaultValue = 1});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // If text is empty, return default value
    if (newValue.text.isEmpty) {
      return TextEditingValue(
        text: defaultValue.toString(),
        selection: TextSelection.collapsed(offset: defaultValue.toString().length),
      );
    }

    final number = int.tryParse(newValue.text);
    if (number == null) {
      return oldValue;
    }

    if (number < min) {
      return TextEditingValue(text: min.toString(), selection: TextSelection.collapsed(offset: min.toString().length));
    } else if (number > max) {
      return TextEditingValue(text: max.toString(), selection: TextSelection.collapsed(offset: max.toString().length));
    }

    return newValue;
  }
}
