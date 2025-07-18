import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';
import 'package:nikke_einkk/module/nikkes/global_nikke_settings.dart';
import 'package:nikke_einkk/module/nikkes/nikke_page.dart';
import 'package:nikke_einkk/module/nikkes/nikke_widgets.dart';

class NikkeListPage extends StatefulWidget {
  const NikkeListPage({super.key});

  @override
  State<NikkeListPage> createState() => _NikkeListPageState();
}

class _NikkeListPageState extends State<NikkeListPage> {
  bool get useGlobal => userDb.useGlobal;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5,
          children: [
            Text('Nikkes'),
            Radio(value: true, groupValue: useGlobal, onChanged: serverRadioChange),
            Text('Global', style: TextStyle(fontWeight: useGlobal ? FontWeight.bold : null)),
            Radio(value: false, groupValue: useGlobal, onChanged: serverRadioChange),
            Text('CN', style: TextStyle(fontWeight: !useGlobal ? FontWeight.bold : null)),
          ],
        ),
      ),
      body: NikkeGrids(
        includeInvisible: true,
        onCall: (data) {
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => NikkeCharacterPage(data: data)));
        },
      ),
      bottomNavigationBar: commonBottomNavigationBar(
        () => setState(() {}),
        actions: [
          FilledButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (ctx) => GlobalSettingPage(
                        playerOptions: userDb.playerOptions,
                        maxSync: userDb.gameDb.maxSyncLevel,
                        cubeLvs: userDb.cubeLvs,
                        db: userDb.gameDb,
                        onGlobalSyncChange: (v) {
                          for (final option in userDb.nikkeOptions.values) {
                            option.syncLevel = v;
                          }
                        },
                        onCubeLvChangeChange: (id, v) {
                          for (final option in userDb.nikkeOptions.values) {
                            final cube = option.cube;
                            if (cube != null && cube.cubeId == id) {
                              cube.cubeLevel = v;
                            }
                          }
                        },
                      ),
                ),
              );
              if (mounted) setState(() {});
            },
            icon: Icon(Icons.recycling),
            label: Text('Global Settings'),
          ),
        ],
      ),
    );
  }

  void serverRadioChange(bool? v) {
    userDb.useGlobal = v ?? useGlobal;
    if (mounted) setState(() {});
  }
}

class NikkeGrids extends StatefulWidget {
  final bool includeInvisible;
  final void Function(NikkeCharacterData)? onCall;
  final bool Function(NikkeCharacterData)? isSelected;

  const NikkeGrids({super.key, this.onCall, this.isSelected, this.includeInvisible = false});

  @override
  State<NikkeGrids> createState() => _NikkeGridsState();
}

class _NikkeGridsState extends State<NikkeGrids> {
  NikkeFilterData filterData = NikkeFilterData();
  ScrollController scrollController = ScrollController();
  bool extraFilters = false;

  NikkeDatabase get db => userDb.gameDb;

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

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
            const VerticalDivider(width: 5, color: Colors.grey),
            FilledButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (ctx) {
                    return NikkeAdvancedFilterDialog(filterData: filterData);
                  },
                );
                setState(() {});
              },
              child: Text('Advanced Filter'),
            ),
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

    return Column(
      children: [
        defaultFilterButtonRow,
        if (extraFilters) ...[elementsFilterRow, weaponTypeFilterRow, cropFilterRow, classFilterRow, rarityRow],
        Expanded(
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverGrid.extent(
                maxCrossAxisExtent: 144,
                children:
                    db.characterResourceGardeTable.values
                        .map((groupedData) => groupedData.values.last)
                        .where((data) => filterData.shouldInclude(data, db.characterShotTable[data.shotId]))
                        .where((data) => data.isVisible || widget.includeInvisible)
                        .map((data) => _buildGrid(data, db.characterShotTable[data.shotId]))
                        .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(NikkeCharacterData data, WeaponData? weapon) {
    final isSelected = widget.isSelected == null ? false : widget.isSelected!(data);
    return InkWell(
      onTap: () {
        if (widget.onCall != null) {
          widget.onCall!(data);
          setState(() {});
        }
      },
      child: NikkeIcon(isSelected: isSelected, characterData: data, weapon: weapon),
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
  List<CharacterSkillType> skillTypes = [];
  List<FunctionType> funcTypes = [];
  List<TimingTriggerType> timingTypes = [];
  List<StatusTriggerType> statusTypes = [];
  bool skillOr = true;
  bool funcOr = true;

  NikkeDatabase get db => userDb.gameDb;

  bool shouldInclude(NikkeCharacterData characterData, WeaponData? weapon) {
    return _burstCheck(characterData) &&
        (corps.isEmpty || corps.contains(characterData.corporation)) &&
        _elementCheck(characterData) &&
        (classes.isEmpty || classes.contains(characterData.characterClass)) &&
        (weaponTypes.isEmpty || weaponTypes.contains(weapon?.weaponType)) &&
        (rarity.isEmpty || rarity.contains(characterData.originalRare)) &&
        _skillTypeCheck(characterData) &&
        _funcTypeCheck(characterData) &&
        _timingTypeCheck(characterData) &&
        _statusTypeCheck(characterData);
  }

  bool _elementCheck(NikkeCharacterData characterData) {
    if (elements.isEmpty || characterData.elementId.any((eleId) => elements.contains(NikkeElement.fromId(eleId)))) {
      return true;
    }
    final rapiRedHoodCheck = characterData.resourceId == 16 && elements.contains(NikkeElement.iron);
    return rapiRedHoodCheck;
  }

  bool _burstCheck(NikkeCharacterData characterData) {
    if (burstSteps.isEmpty || burstSteps.contains(characterData.useBurstSkill)) return true;
    final redHoodCheck = characterData.useBurstSkill == BurstStep.allStep;
    final rapiRedHoodCheck = burstSteps.contains(BurstStep.step1) && characterData.resourceId == 16;
    return redHoodCheck || rapiRedHoodCheck;
  }

  bool _skillTypeCheck(NikkeCharacterData characterData) {
    if (skillTypes.isEmpty) return true;

    final Set<CharacterSkillType> characterSkillTypes = db.nameCodeSkillTypes[characterData.nameCode] ?? {};

    if (skillOr) {
      for (final requiredType in skillTypes) {
        if (characterSkillTypes.contains(requiredType)) {
          return true;
        }
      }
      return false;
    } else {
      return characterSkillTypes.containsAll(skillTypes);
    }
  }

  bool _funcTypeCheck(NikkeCharacterData characterData) {
    if (funcTypes.isEmpty) return true;

    final Set<FunctionType> characterFuncTypes = db.nameCodeFuncTypes[characterData.nameCode] ?? {};

    if (funcOr) {
      for (final requiredType in funcTypes) {
        if (characterFuncTypes.contains(requiredType)) {
          return true;
        }
      }
      return false;
    } else {
      return characterFuncTypes.containsAll(funcTypes);
    }
  }

  bool _timingTypeCheck(NikkeCharacterData characterData) {
    if (timingTypes.isEmpty) return true;

    final Set<TimingTriggerType> types = db.nameCodeTimingTypes[characterData.nameCode] ?? {};
    return types.containsAll(timingTypes);
  }

  bool _statusTypeCheck(NikkeCharacterData characterData) {
    if (statusTypes.isEmpty) return true;

    final Set<StatusTriggerType> types = db.nameCodeStatusTypes[characterData.nameCode] ?? {};
    return types.containsAll(statusTypes);
  }

  void reset() {
    burstSteps.clear();
    corps.clear();
    elements.clear();
    classes.clear();
    weaponTypes.clear();
    rarity.clear();
    rarity.add(Rarity.ssr);
    skillTypes.clear();
    funcTypes.clear();
    timingTypes.clear();
    statusTypes.clear();
    skillOr = true;
    funcOr = true;
  }
}
