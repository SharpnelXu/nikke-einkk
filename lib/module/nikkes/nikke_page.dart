import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/model/user_data.dart';
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
  NikkeDatabase get db => userDb.gameDb;
  NikkeCharacterData get data => widget.data;
  WeaponData? get weapon => db.characterShotTable[data.shotId];
  bool favoriteItemSkill = true;
  NikkeOptions option = NikkeOptions(nikkeResourceId: -1);

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
                        cubeLvs: userDb.cubeLvs,
                        db: userDb.gameDb,
                        maxSync: db.maxSyncLevel,
                        onGlobalSyncChange: (v) {
                          for (final option in userDb.nikkeOptions.values) {
                            option.syncLevel = v;
                          }
                          setState(() {});
                        },
                        onCubeLvChangeChange: (id, v) {
                          for (final option in userDb.nikkeOptions.values) {
                            final cube = option.cube;
                            if (cube != null && cube.cubeId == id) {
                              cube.cubeLevel = v;
                            }
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
    ('Setup', () => NikkeSetupColumn(option: option, cubeLvs: userDb.cubeLvs, useGlobal: userDb.useGlobal)),
    ('Weapon', () => WeaponDataDisplay(character: data, weaponId: data.shotId)),
    ('Skill 1', () => buildSkillTab(data.skill1Id, data.skill1Table, 0)),
    ('Skill 2', () => buildSkillTab(data.skill2Id, data.skill2Table, 1)),
    ('Burst', () => buildSkillTab(data.ultiSkillId, SkillType.characterSkill, 2)),
  ];

  Widget buildStatTab() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      constraints: const BoxConstraints(maxWidth: 700),
      child: NikkeBaseStatColumn(option: option),
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
        titled: false,
        constraint: false,
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
    return Container(
      padding: const EdgeInsets.all(8.0),
      constraints: const BoxConstraints(maxWidth: 700),
      child: Column(mainAxisSize: MainAxisSize.min, spacing: 3, children: children),
    );
  }
}

class NikkeBaseStatColumn extends StatefulWidget {
  final NikkeOptions option;
  const NikkeBaseStatColumn({super.key, required this.option});

  @override
  State<NikkeBaseStatColumn> createState() => _NikkeBaseStatColumnState();
}

class _NikkeBaseStatColumnState extends State<NikkeBaseStatColumn> {
  NikkeOptions get option => widget.option;
  NikkeDatabase get db => userDb.gameDb;

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
    for (int idx = 0; idx < NikkeOptions.equipTypes.length; idx += 1) {
      final equipType = NikkeOptions.equipTypes[idx];
      final equipStat = statTypes.map((type) => option.equips[idx]?.getEquipStat(type, db, characterData.corporation));
      equipStats[equipType] = equipStat.toList();
    }

    final totalStat = List.generate(statTypes.length, (idx) {
      return getBaseStat(
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

    final Map<EquipType, int> equipBpMultMap = {};
    int cubeBpMult = 0;
    int dollBpMult = 0;

    final Map<EquipLineType, List<FunctionData>> equipLineVals = {};
    for (final equip in option.equips) {
      if (equip == null) continue;

      for (final equipLine in equip.equipLines) {
        final stateEffectData = db.stateEffectTable[equipLine.getStateEffectId()];
        if (stateEffectData == null) {
          continue;
        }

        for (final functionId in stateEffectData.functions) {
          if (functionId.function != 0) {
            final function = db.functionTable[functionId.function]!;
            equipLineVals.putIfAbsent(equipLine.type, () => []);
            equipLineVals[equipLine.type]!.add(function);
            equipBpMultMap.putIfAbsent(equip.type, () => 0);
            equipBpMultMap[equip.type] = equipBpMultMap[equip.type]! + (function.functionBattlepower ?? 0);
          }
        }
      }
    }

    final coverStat = [
      db.coverStatTable[option.syncLevel]?.levelHp,
      null,
      db.coverStatTable[option.syncLevel]?.levelDefence,
    ];

    final children = [];
    if (equipLineVals.isEmpty) {
      children.add(Text('Equip Lines: None', style: TextStyle(fontSize: 18)));
    } else {
      children.add(Text('Equip Lines:', style: TextStyle(fontSize: 18)));
      children.add(
        DataTable(
          columns: [
            DataColumn(label: Text('Line Type'), headingRowAlignment: MainAxisAlignment.center),
            DataColumn(label: Text('Value'), headingRowAlignment: MainAxisAlignment.center),
            DataColumn(label: Text('BP Mult')),
          ],
          rows:
              equipLineVals.keys.map((type) {
                return DataRow(
                  cells: [
                    DataCell(Text(type.toString())),
                    DataCell(
                      Text(equipLineVals[type]!.fold(0, (prev, data) => prev + data.functionValue).percentString),
                    ),
                    DataCell(
                      Text('${equipLineVals[type]!.fold(0, (prev, data) => prev + (data.functionBattlepower ?? 0))}'),
                    ),
                  ],
                );
              }).toList(),
        ),
      );
    }

    children.add(const Divider());

    final cubeOption = option.cube;
    if (cubeOption != null) {
      final cubeData = db.harmonyCubeTable[cubeOption.cubeId];
      final localeKey = cubeData?.nameLocalkey;
      final colorCode = int.tryParse('0xFF${cubeData?.bgColor}');
      children.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5,
          children: [
            Icon(Icons.square, color: colorCode != null ? Color(colorCode) : null),
            Text(
              'Cube: ${locale.getTranslation(localeKey) ?? localeKey ?? 'Not Found'} Lv${cubeOption.cubeLevel}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
      if (cubeData != null) {
        children.add(Text(locale.getTranslation(cubeData.descriptionLocalkey) ?? cubeData.descriptionLocalkey));
      }
      for (final tuple in cubeOption.getValidCubeSkills(db)) {
        final skillGroupId = tuple.$1;
        final skillLv = tuple.$2;
        final skillInfo = db.groupedSkillInfoTable[skillGroupId]?[skillLv];
        final stateEffect = db.stateEffectTable[skillInfo?.id];

        final child =
            stateEffect != null
                ? StateEffectDataDisplay(data: stateEffect)
                : Text('Cube skill not found for group $skillGroupId & lv $skillLv');
        for (final funcId in stateEffect?.allValidFuncIds ?? []) {
          final func = db.functionTable[funcId];
          cubeBpMult += func?.functionBattlepower ?? 0;
        }

        children.add(child);
      }
    } else {
      children.add(Text('Cube: None', style: TextStyle(fontSize: 18)));
    }

    children.add(const Divider());

    final doll = option.favoriteItem;
    if (doll != null) {
      final dollData = doll.getData(db);
      final localeKey = dollData?.nameLocalkey;
      children.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5,
          children: [
            Icon(Icons.person, color: doll.rarity.color),
            Text(
              'Doll: ${locale.getTranslation(localeKey) ?? localeKey ?? 'Not Found'}'
              ' ${dollLvString(doll.rarity, doll.level)}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
      if (dollData != null) {
        children.add(Text(locale.getTranslation(dollData.descriptionLocalkey) ?? dollData.descriptionLocalkey));
      }
      for (final tuple in doll.getValidDollSkills(db)) {
        final skillGroupId = tuple.$1;
        final skillLv = tuple.$2;
        final skillInfo = db.groupedSkillInfoTable[skillGroupId]?[skillLv];
        final stateEffect = db.stateEffectTable[skillInfo?.id];

        final child =
            stateEffect != null
                ? StateEffectDataDisplay(data: stateEffect)
                : Text('Doll skill not found for group $skillGroupId & lv $skillLv');
        for (final funcId in stateEffect?.allValidFuncIds ?? []) {
          final func = db.functionTable[funcId];
          dollBpMult += func?.functionBattlepower ?? 0;
        }

        children.add(child);
      }
    } else {
      children.add(Text('Doll: None', style: TextStyle(fontSize: 18)));
    }

    final bp = getBattlePoint(
      hp: totalStat[0],
      atk: totalStat[1],
      def: totalStat[2],
      skillLvs: option.skillLevels,
      funcBpSum: equipBpMultMap.values.sum + cubeBpMult + dollBpMult,
    );
    final skillBp = getBattlePoint(
      hp: totalStat[0],
      atk: totalStat[1],
      def: totalStat[2],
      skillLvs: [0, 0, 0],
      funcBpSum: equipBpMultMap.values.sum + cubeBpMult + dollBpMult,
    );
    final cubeBp = getBattlePoint(
      hp: totalStat[0] - (cubeStat[0] ?? 0),
      atk: totalStat[1] - (cubeStat[1] ?? 0),
      def: totalStat[2] - (cubeStat[2] ?? 0),
      skillLvs: option.skillLevels,
      funcBpSum: equipBpMultMap.values.sum + dollBpMult,
    );
    final dollBp = getBattlePoint(
      hp: totalStat[0] - (dollStat[0] ?? 0),
      atk: totalStat[1] - (dollStat[1] ?? 0),
      def: totalStat[2] - (dollStat[2] ?? 0),
      skillLvs: option.skillLevels,
      funcBpSum: equipBpMultMap.values.sum + cubeBpMult,
    );
    final headBp = getBattlePoint(
      hp: totalStat[0] - (equipStats[EquipType.head]?[0] ?? 0),
      atk: totalStat[1] - (equipStats[EquipType.head]?[1] ?? 0),
      def: totalStat[2] - (equipStats[EquipType.head]?[2] ?? 0),
      skillLvs: option.skillLevels,
      funcBpSum: equipBpMultMap.values.sum - (equipBpMultMap[EquipType.head] ?? 0) + cubeBpMult + dollBpMult,
    );
    final bodyBp = getBattlePoint(
      hp: totalStat[0] - (equipStats[EquipType.body]?[0] ?? 0),
      atk: totalStat[1] - (equipStats[EquipType.body]?[1] ?? 0),
      def: totalStat[2] - (equipStats[EquipType.body]?[2] ?? 0),
      skillLvs: option.skillLevels,
      funcBpSum: equipBpMultMap.values.sum - (equipBpMultMap[EquipType.body] ?? 0) + cubeBpMult + dollBpMult,
    );
    final armBp = getBattlePoint(
      hp: totalStat[0] - (equipStats[EquipType.arm]?[0] ?? 0),
      atk: totalStat[1] - (equipStats[EquipType.arm]?[1] ?? 0),
      def: totalStat[2] - (equipStats[EquipType.arm]?[2] ?? 0),
      skillLvs: option.skillLevels,
      funcBpSum: equipBpMultMap.values.sum - (equipBpMultMap[EquipType.arm] ?? 0) + cubeBpMult + dollBpMult,
    );
    final legBp = getBattlePoint(
      hp: totalStat[0] - (equipStats[EquipType.leg]?[0] ?? 0),
      atk: totalStat[1] - (equipStats[EquipType.leg]?[1] ?? 0),
      def: totalStat[2] - (equipStats[EquipType.leg]?[2] ?? 0),
      skillLvs: option.skillLevels,
      funcBpSum: equipBpMultMap.values.sum - (equipBpMultMap[EquipType.leg] ?? 0) + cubeBpMult + dollBpMult,
    );

    final underline = TextStyle(decoration: TextDecoration.underline);
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 5,
      children: [
        Text('Battle Point: ${bp.decimalPattern}', style: TextStyle(fontSize: 18)),
        Wrap(
          spacing: 20,
          children: [
            DataTable(
              columns: [
                DataColumn(label: Text('')),
                ...statTypes.map(
                  (type) =>
                      DataColumn(label: Text(type.name.toUpperCase()), headingRowAlignment: MainAxisAlignment.center),
                ),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text('Cover', style: TextStyle(fontWeight: FontWeight.bold))),
                    ..._statArrayToDataCell(coverStat),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                    ..._statArrayToDataCell(totalStat),
                  ],
                ),
                DataRow(cells: [DataCell(Text('Bond')), ..._statArrayToDataCell(attractiveStat)]),
                DataRow(cells: [DataCell(Text('Console')), ..._statArrayToDataCell(consoleStat)]),
                DataRow(cells: [DataCell(Text('Cube')), ..._statArrayToDataCell(cubeStat)]),
                DataRow(cells: [DataCell(Text('Doll')), ..._statArrayToDataCell(dollStat)]),
                ...NikkeOptions.equipTypes.map((type) {
                  return DataRow(cells: [DataCell(Text(type.name.pascal)), ..._statArrayToDataCell(equipStats[type]!)]);
                }),
              ],
            ),
            DataTable(
              columns: [
                DataColumn(label: Text('')),
                DataColumn(
                  label: Text('BP'),
                  headingRowAlignment: MainAxisAlignment.center,
                  tooltip: 'Cube, doll, equips includes stats bp',
                ),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text(bp.decimalPattern)),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Skills')),
                    DataCell(
                      Tooltip(
                        message: 'BP if skills were 1/1/1: ${skillBp.decimalPattern}',
                        child: Text((bp - skillBp).decimalPattern, style: underline),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Cube')),
                    DataCell(
                      Tooltip(
                        message: 'BP if no cube: ${cubeBp.decimalPattern}',
                        child: Text((bp - cubeBp).decimalPattern, style: underline),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Doll')),
                    DataCell(
                      Tooltip(
                        message: 'BP if no doll: ${dollBp.decimalPattern}',
                        child: Text((bp - dollBp).decimalPattern, style: underline),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Head')),
                    DataCell(
                      Tooltip(
                        message: 'BP if no head gear: ${headBp.decimalPattern}',
                        child: Text((bp - headBp).decimalPattern, style: underline),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Body')),
                    DataCell(
                      Tooltip(
                        message: 'BP if no body gear: ${bodyBp.decimalPattern}',
                        child: Text((bp - bodyBp).decimalPattern, style: underline),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Arm')),
                    DataCell(
                      Tooltip(
                        message: 'BP if no arm gear: ${armBp.decimalPattern}',
                        child: Text((bp - armBp).decimalPattern, style: underline),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Leg')),
                    DataCell(
                      Tooltip(
                        message: 'BP if no leg gear: ${legBp.decimalPattern}',
                        child: Text((bp - legBp).decimalPattern, style: underline),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        NikkeBasicSetupWidgets(option: option, useGlobal: userDb.useGlobal, onChange: () => setState(() {})),
        const Divider(),
        ...children,
      ],
    );
  }

  Iterable<DataCell> _statArrayToDataCell(Iterable<int?> stats) {
    return stats.map((stat) => DataCell(Text(stat?.decimalPattern ?? 'None')));
  }
}
