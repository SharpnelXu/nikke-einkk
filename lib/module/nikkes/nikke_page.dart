import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';
import 'package:nikke_einkk/module/common/skill_display.dart';
import 'package:nikke_einkk/module/common/slider.dart';
import 'package:nikke_einkk/module/nikkes/global_nikke_settings.dart';
import 'package:nikke_einkk/module/nikkes/nikke_setup_widgets.dart';
import 'package:nikke_einkk/module/nikkes/nikke_widgets.dart';

class NikkeCharacterPage extends StatefulWidget {
  final NikkeCharacterData data;

  const NikkeCharacterPage({super.key, required this.data});

  @override
  State<NikkeCharacterPage> createState() => _NikkeCharacterPageState();
}

class _NikkeCharacterPageState extends State<NikkeCharacterPage> {
  int tab = 0;
  NikkeDatabaseV2 get db => userDb.gameDb;
  NikkeCharacterData get data => widget.data;
  WeaponData? get weapon => db.characterShotTable[data.shotId];
  bool favoriteItemSkill = true;
  BattleNikkeOptions option = BattleNikkeOptions(nikkeResourceId: -1);

  @override
  void initState() {
    super.initState();
    final resourceId = data.resourceId;
    if (userDb.nikkeOptions[resourceId] != null) {
      option = userDb.nikkeOptions[resourceId]!;
    } else {
      userDb.nikkeOptions[resourceId] = option;
      option.nikkeResourceId = resourceId;
      option.coreLevel = data.gradeCoreId;
      option.syncLevel = userDb.playerOptions.globalSync;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: [
          Text(locale.getTranslation(data.nameLocalkey) ?? data.nameLocalkey, style: TextStyle(fontSize: 20)),
          if (!data.isVisible) Text('NonPlayableCharacter or Unreleased'),
          Tooltip(
            textStyle: TextStyle(fontSize: 14),
            message: locale.getTranslation(data.descriptionLocalkey) ?? data.descriptionLocalkey,
            child: Icon(Icons.info_outline),
          ),
        ],
      ),
      Wrap(
        spacing: 15,
        alignment: WrapAlignment.center,
        children: [
          Text('Resource ID: ${data.resourceId}'),
          Text('Name Code: ${data.nameCode}'),
          Text('Rarity: ${data.rawOriginalRare}'),
          Text('Element: ${data.elementId.map((eleId) => NikkeElement.fromId(eleId).name.toUpperCase()).join(', ')}'),
        ],
      ),
      Wrap(
        spacing: 15,
        alignment: WrapAlignment.center,
        children: [
          Text('Class: ${data.rawCharacterClass}'),
          Text('Burst: ${data.rawUseBurstSkill}'),
          Text('Weapon: ${weapon?.rawWeaponType}'),
          Text('Corporation: ${data.rawCorporation} ${data.rawCorporationSubType ?? ''}'),
        ],
      ),
      Wrap(
        spacing: 15,
        alignment: WrapAlignment.center,
        children: [
          Text('Squad: ${locale.getTranslation('Locale_Character:${data.squad.toLowerCase()}_name') ?? data.squad}'),
          Text(
            '${locale.getTranslation('${data.cvLocalkey}_en') ?? data.cvLocalkey} (EN)'
            ' / ${locale.getTranslation('${data.cvLocalkey}_ko') ?? data.cvLocalkey} (KR)'
            ' / ${locale.getTranslation('${data.cvLocalkey}_ja') ?? data.cvLocalkey} (JP)',
          ),
        ],
      ),
      buildTabs(),
      Divider(),
      tabs[tab].$2(),
    ];
    return Scaffold(
      appBar: AppBar(title: Text('Nikke Data')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemBuilder: (ctx, idx) => Align(child: Padding(padding: const EdgeInsets.all(2.0), child: children[idx])),
          itemCount: children.length,
        ),
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
                        maxSync: db.maxSyncLevel,
                        onGlobalSyncChange: (v) {
                          for (final option in userDb.nikkeOptions.values) {
                            option.syncLevel = v;
                          }
                          setState(() {});
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

  Widget buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(tabs.length, (idx) {
        return TextButton(
          onPressed: () {
            tab = idx;
            setState(() {});
          },
          child: Text(tabs[idx].$1, style: TextStyle(fontWeight: tab == idx ? FontWeight.bold : null)),
        );
      }),
    );
  }

  List<(String, Widget Function())> get tabs => [
    ('Info', () => buildStatTab()),
    ('Setup', () => NikkeSetupColumn(option: option, useGlobal: userDb.useGlobal)),
    ('Weapon', () => WeaponDataDisplay(character: data, weaponId: data.shotId)),
    ('Skill 1', () => buildSkillTab(data.skill1Id, data.skill1Table, 0)),
    ('Skill 2', () => buildSkillTab(data.skill2Id, data.skill2Table, 1)),
    ('Burst', () => buildSkillTab(data.ultiSkillId, SkillType.characterSkill, 2)),
  ];

  Widget buildStatTab() {
    final cubeOption = option.cube;
    final children = [
      NikkeBaseStatColumn(option: option),
      const Divider(),
      Text(
        'Cube: ${locale.getTranslation(db.harmonyCubeTable[cubeOption?.cubeId]?.nameLocalkey) ?? 'None'}',
        style: TextStyle(fontSize: 18),
      ),
    ];
    final cube = db.harmonyCubeTable[cubeOption?.cubeId];
    final cubeEnhanceData = db.harmonyCubeEnhanceLvTable[cube?.levelEnhanceId];
    if (cubeOption != null && cube != null && cubeEnhanceData != null) {}
    return Container(
      padding: const EdgeInsets.all(8.0),
      constraints: const BoxConstraints(maxWidth: 700),
      child: Column(mainAxisSize: MainAxisSize.min, spacing: 5, children: children),
    );
  }

  Widget buildSkillTab(int skillId, SkillType skillType, int index) {
    final level = option.skillLevels[index];

    final dollData = db.nameCodeFavItemTable[data.nameCode];
    int dollGrade = 0;
    FavoriteItemSkillGroup? dollSkill;

    for (int i = 0; i < (dollData?.favoriteItemSkills.length ?? 0); i += 1) {
      final substituteSkillData = dollData!.favoriteItemSkills[i];
      if (substituteSkillData.skillId == 0) continue;

      if (substituteSkillData.skillChangeSlot == index + 1) {
        dollGrade = i;
        dollSkill = substituteSkillData;
      }
    }

    final actualSkillId = dollSkill != null && favoriteItemSkill ? dollSkill.skillId + level - 1 : skillId + level - 1;
    final actualSkillType = dollSkill != null && favoriteItemSkill ? dollSkill.skillTable : skillType;

    final skillInfo = db.skillInfoTable[actualSkillId];

    final List<Widget> children = [
      Text(
        '${skillInfo == null ? 'Skill Info Not Found!' : locale.getTranslation(skillInfo.nameLocalkey)} Lv $level',
        style: TextStyle(fontSize: 20),
      ),
      Wrap(
        spacing: 5,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (dollData != null) Text('Favorite Item Skill: ${dollLvString(dollData.favoriteRare, dollGrade)}'),
          if (dollData != null)
            Checkbox(
              value: favoriteItemSkill,
              onChanged: (v) {
                favoriteItemSkill = v!;
                setState(() {});
              },
            ),
          Text('Skill ID: $actualSkillId, type: ${actualSkillType == SkillType.characterSkill ? 'Active' : 'Passive'}'),
        ],
      ),
      if (skillInfo != null) DescriptionTextWidget(formatSkillInfoDescription(skillInfo)),
      SliderWithPrefix(
        titled: true,
        label: 'Skill ${index + 1}',
        min: 1,
        max: 10,
        value: level,
        valueFormatter: (v) => 'Lv$v',
        onChange: (newValue) {
          option.skillLevels[index] = newValue.round();
          if (mounted) setState(() {});
        },
      ),
    ];
    if (actualSkillType == SkillType.stateEffect) {
      final data = db.stateEffectTable[actualSkillId];
      if (data == null) {
        children.add(Text('Not Found!'));
      } else {
        children.add(
          Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: StateEffectDataDisplay(data: data),
          ),
        );
      }
    } else if (actualSkillType == SkillType.characterSkill) {
      final data = db.characterSkillTable[actualSkillId];
      if (data == null) {
        children.add(Text('Not Found!'));
      } else {
        children.add(
          Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: CharacterSkillDataDisplay(data: data),
          ),
        );
      }
    }
    return Column(mainAxisSize: MainAxisSize.min, spacing: 3, children: children);
  }
}

class NikkeBaseStatColumn extends StatefulWidget {
  final BattleNikkeOptions option;
  const NikkeBaseStatColumn({super.key, required this.option});

  @override
  State<NikkeBaseStatColumn> createState() => _NikkeBaseStatColumnState();
}

class _NikkeBaseStatColumnState extends State<NikkeBaseStatColumn> {
  BattleNikkeOptions get option => widget.option;
  NikkeDatabaseV2 get db => userDb.gameDb;

  @override
  Widget build(BuildContext context) {
    final groupedData = db.characterResourceGardeTable[option.nikkeResourceId];
    final characterData = groupedData?[option.coreLevel];
    if (characterData == null) {
      return Text('Nikke ${option.nikkeResourceId} Core ${option.coreLevel} not found');
    }

    final baseStatData =
        db.groupedCharacterStatTable[characterData.statEnhanceId]?[option.syncLevel] ?? CharacterStatData.emptyData;
    final statEnhanceData =
        db.characterStatEnhanceTable[characterData.statEnhanceId] ?? CharacterStatEnhanceData.emptyData;
    final attractiveStatData =
        db.attractiveStatTable[option.attractLevel]?.getStatData(characterData.characterClass) ??
        ClassAttractiveStatData.emptyData;
    final playerOption = userDb.playerOptions;
    final statTypes = [StatType.hp, StatType.atk, StatType.defence];
    final baseStat = [baseStatData.hp, baseStatData.attack, baseStatData.defence];
    final gradeStat = [statEnhanceData.gradeHp, statEnhanceData.gradeAttack, statEnhanceData.gradeDefence];
    final coreRatio = [statEnhanceData.coreHp, statEnhanceData.coreAttack, statEnhanceData.coreDefence];
    final attractiveStat = [attractiveStatData.hpRate, attractiveStatData.attackRate, attractiveStatData.defenceRate];
    final consoleStat = [
      playerOption.getRecycleHp(characterData.characterClass),
      playerOption.getRecycleAttack(characterData.corporation),
      playerOption.getRecycleDefence(characterData.characterClass, characterData.corporation),
    ];
    final cubeStat = statTypes.map((type) => option.cube?.getCubeStat(type, db)).toList();
    final dollStat = statTypes.map((type) => option.favoriteItem?.getDollStat(type, db)).toList();
    final Map<EquipType, List<int?>> equipStats = {};
    for (int idx = 0; idx < BattleNikkeOptions.equipTypes.length; idx += 1) {
      final equipType = BattleNikkeOptions.equipTypes[idx];
      final equipStat = statTypes.map((type) => option.equips[idx]?.getEquipStat(type, db, characterData.corporation));
      equipStats[equipType] = equipStat.toList();
    }

    final totalStat = List.generate(statTypes.length, (idx) {
      return BattleUtils.getBaseStat(
        coreLevel: option.coreLevel,
        baseStat: baseStat[idx],
        gradeRatio: statEnhanceData.gradeRatio,
        gradeEnhanceBase: gradeStat[idx],
        coreEnhanceBaseRatio: coreRatio[idx],
        consoleStat: consoleStat[idx],
        bondStat: attractiveStat[idx],
        equipStat: equipStats.values.fold(0, (prev, equip) => prev + (equip[idx] ?? 0)),
        cubeStat: cubeStat[idx] ?? 0,
        dollStat: dollStat[idx] ?? 0,
      );
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 5,
      children: [
        Text('Base Stat', style: TextStyle(fontSize: 18)),
        DataTable(
          columns: [
            DataColumn(label: Text(' ')),
            ...statTypes.map(
              (type) => DataColumn(label: Text(type.name.toUpperCase()), headingRowAlignment: MainAxisAlignment.center),
            ),
          ],
          rows: [
            DataRow(cells: [DataCell(Text('Total')), ..._statArrayToDataCell(totalStat)]),
            DataRow(cells: [DataCell(Text('Bond')), ..._statArrayToDataCell(attractiveStat)]),
            DataRow(cells: [DataCell(Text('Console')), ..._statArrayToDataCell(consoleStat)]),
            DataRow(cells: [DataCell(Text('Cube')), ..._statArrayToDataCell(cubeStat)]),
            DataRow(cells: [DataCell(Text('Doll')), ..._statArrayToDataCell(dollStat)]),
            ...BattleNikkeOptions.equipTypes.map((type) {
              return DataRow(
                cells: [DataCell(Text('${type.name.pascal} Gear')), ..._statArrayToDataCell(equipStats[type]!)],
              );
            }),
          ],
        ),
        NikkeBasicSetupWidgets(option: option, useGlobal: userDb.useGlobal, onChange: () => setState(() {})),
      ],
    );
  }

  Iterable<DataCell> _statArrayToDataCell(Iterable<int?> stats) {
    return stats.map((stat) => DataCell(Text(stat?.decimalPattern ?? 'None')));
  }
}
