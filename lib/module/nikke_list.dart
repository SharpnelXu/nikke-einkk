import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';

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
                child: Text(buttonStep.name.toUpperCase()),
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
                backgroundColor: enabled ? Colors.blue : Colors.white,
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
                backgroundColor: enabled ? Colors.blue : Colors.white,
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
          if (extraFilters) cropFilterRow,
          if (extraFilters) elementsFilterRow,
          if (extraFilters) weaponTypeFilterRow,
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

    return Scaffold(
      appBar: AppBar(title: const Text('Nikke Options')),
      body: Row(
        children: [
          filterList,
          SizedBox(width: 200, child: Column(children: [Text('data')])),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context, Map<int, NikkeCharacterData> groupedData) {
    final characterData = groupedData.values.last;
    final name = gameData.getTranslation(characterData.nameLocalkey)?.zhCN ?? characterData.resourceId;
    final weapon = gameData.characterShotTable[characterData.shotId]!;

    return InkWell(
      onTap: () {
        option.nikkeResourceId = characterData.resourceId;
      },
      child: Container(
        width: 100,
        height: 150,
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5),
          color: weapon.spotFirstDelay != 20 || weapon.spotLastDelay != 20 ? Colors.red : null,
        ),
        child: Center(
          child: Text(
            '$name / ${weapon.weaponType}',
            style: TextStyle(color: characterData.hasUnknownEnum ? Colors.red : Colors.black, fontSize: 15),
          ),
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
