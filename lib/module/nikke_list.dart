import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
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
                      gameData.characterResourceGardeTable.values
                          .where((groupedData) => filterData.shouldInclude(groupedData))
                          .map((groupedData) => _buildGrid(context, groupedData))
                          .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final characterData = gameData.characterResourceGardeTable[option.nikkeResourceId]?[option.coreLevel];
    final maxAttract = characterData?.corporationSubType == CorporationSubType.overspec ? 40 : 30;
    final weapon = gameData.characterShotTable[characterData?.shotId];
    if (option.attractLevel > maxAttract) {
      option.attractLevel = maxAttract;
    }
    final name = gameData.getTranslation(characterData?.nameLocalkey)?.zhCN;
    final optionColumn = Column(
      spacing: 3,
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          [
            Text(name != null ? '$name / ${weapon?.weaponType}' : 'Tap to select Nikke'),
            Row(
              spacing: 5,
              children: [
                Text('Sync'),
                Expanded(
                  child: RangedNumberTextField(
                    maxValue: gameData.maxSyncLevel,
                    onChangeFunction:
                        (newValue) => setState(() {
                          option.syncLevel = newValue;
                        }),
                  ),
                ),
              ],
            ),
            SliderWithPrefix(
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
          ].map((widget) => Padding(padding: const EdgeInsets.all(5), child: widget)).toList(),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Nikke Options')),
      body: Row(children: [filterList, SizedBox(width: 250, child: optionColumn)]),
    );
  }

  Widget _buildGrid(BuildContext context, Map<int, NikkeCharacterData> groupedData) {
    final characterData = groupedData.values.last;
    final name = gameData.getTranslation(characterData.nameLocalkey)?.zhCN ?? characterData.resourceId;
    final weapon = gameData.characterShotTable[characterData.shotId]!;

    final isSelected = option.nikkeResourceId == characterData.resourceId;
    final colors =
        characterData.elementId
            .map((eleId) => NikkeElement.fromId(eleId).color.withAlpha(isSelected ? 255 : 50))
            .toList();

    final textStyle = TextStyle(fontSize: 15, color: isSelected ? Colors.white : Colors.black);
    return InkWell(
      onTap: () {
        option.nikkeResourceId = characterData.resourceId;
        if (mounted) setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          border: Border.all(color: characterData.originalRare.color, width: 3),
          borderRadius: BorderRadius.circular(5),
          gradient: colors.length > 1 ? LinearGradient(colors: colors) : null,
          color: colors.length == 1 ? colors.first : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.loose,
          children: [
            Text('$name', style: textStyle),
            Positioned(top: 2, left: 2, child: Text(characterData.corporation.name.toUpperCase(), style: textStyle)),
            Positioned(
              bottom: 2,
              left: 2,
              child: Text(characterData.characterClass.name.toUpperCase(), style: textStyle),
            ),
            Positioned(top: 2, right: 2, child: Text(weapon.weaponType.toString(), style: textStyle)),
            Positioned(bottom: 2, right: 2, child: Text(characterData.useBurstSkill.toString(), style: textStyle)),
          ],
        ),
      ),
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
    final weapon = gameData.characterShotTable[characterData.shotId];
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
