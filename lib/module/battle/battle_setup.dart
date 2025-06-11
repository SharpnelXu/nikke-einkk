import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/harmony_cube.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';
import 'package:nikke_einkk/model/user_data.dart';
import 'package:nikke_einkk/module/battle/nikke_list.dart';
import 'package:nikke_einkk/module/battle/rapture_setup.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';
import 'package:nikke_einkk/module/common/simple_dialog.dart';
import 'package:nikke_einkk/module/common/slider.dart';

class BattleSetupPage extends StatefulWidget {
  const BattleSetupPage({super.key});

  @override
  State<BattleSetupPage> createState() => _BattleSetupPageState();
}

class _BattleSetupPageState extends State<BattleSetupPage> {
  BattleRaptureOptions raptureOption = BattleRaptureOptions();
  List<BattleNikkeOptions> nikkeOptions = List.generate(5, (_) => BattleNikkeOptions(nikkeResourceId: -1));
  BattlePlayerOptions playerOptions = BattlePlayerOptions();
  List<BattleHarmonyCube> cubes = List.generate(HarmonyCubeType.values.length, (index) {
    return BattleHarmonyCube(HarmonyCubeType.values[index], 1);
  });
  int globalSyncLevel = 1;

  @override
  void initState() {
    super.initState();

    playerOptions = db.userData.playerOptions.copy();
    final Map<HarmonyCubeType, int> storedCubeLevel = {};
    for (final cube in db.userData.cubes) {
      storedCubeLevel[cube.type] = cube.cubeLevel;
    }
    for (final cube in cubes) {
      if (storedCubeLevel.containsKey(cube.type)) {
        cube.cubeLevel = storedCubeLevel[cube.type]!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Battle Simulation')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              // Vertical scrolling
              scrollDirection: Axis.vertical,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: RaptureDisplay(option: raptureOption)),
                  ...List.generate(5, (index) {
                    return Expanded(
                      child: NikkeDisplay(option: nikkeOptions[index], cubes: cubes, playerOptions: playerOptions),
                    );
                  }),
                ],
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              spacing: 5,
              children: [
                FilledButton.icon(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      useRootNavigator: false,
                      builder: (ctx) {
                        return SimpleConfirmDialog(
                          title: Text('Global Settings'),
                          showCancel: false,
                          showOk: true,
                          content: GlobalSettingDialog(
                            playerOptions: playerOptions,
                            defaultGlobalSync: globalSyncLevel,
                            onGlobalSyncChange: (v) {
                              globalSyncLevel = v;
                              for (final option in nikkeOptions) {
                                option.syncLevel = v;
                              }
                              setState(() {});
                            },
                          ),
                        );
                      },
                    );
                    if (mounted) setState(() {});
                  },
                  icon: Icon(Icons.recycling),
                  label: Text('Global Settings'),
                ),
                FilledButton.icon(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      useRootNavigator: false,
                      builder: (ctx) {
                        return SimpleConfirmDialog(
                          title: Text('Cube Settings'),
                          showCancel: false,
                          showOk: true,
                          content: CubeSettingDialog(cubes: cubes),
                        );
                      },
                    );
                    if (mounted) setState(() {});
                  },
                  icon: Icon(Icons.grid_view_sharp),
                  label: Text('Cube Settings'),
                ),
                FilledButton.icon(
                  onPressed: () async {
                    String? outputFile = await FilePicker.platform.saveFile(
                      dialogTitle: 'Save battle setup',
                      fileName: 'battleSetup.json',
                      initialDirectory: db.userDataPath,
                      type: FileType.custom,
                      allowedExtensions: ['json'],
                    );
                    if (outputFile != null) {
                      final battleSetup = BattleSetup(
                        nikkeOptions: nikkeOptions,
                        raptureOptions: raptureOption,
                        playerOptions: playerOptions,
                      );
                      final file = File(outputFile);
                      await file.writeAsString(jsonEncode(battleSetup.toJson()), encoding: utf8);

                      final userData = db.userData;
                      userData.cubes.clear();
                      userData.cubes.addAll(cubes);

                      userData.playerOptions = playerOptions.copy();
                      for (final nikkeOption in nikkeOptions) {
                        if (nikkeOption.nikkeResourceId != -1) {
                          userData.nikkeOptions[nikkeOption.nikkeResourceId] = nikkeOption.copy()..cube = null;
                        }
                      }
                      db.writeUserData();
                    }

                    if (mounted) setState(() {});
                  },
                  icon: Icon(Icons.save),
                  label: Text('Save Settings'),
                ),
                FilledButton.icon(
                  onPressed: () async {
                    final selectResult = await FilePicker.platform.pickFiles(
                      dialogTitle: 'Load battle setup',
                      initialDirectory: db.userDataPath,
                      type: FileType.custom,
                      allowedExtensions: ['json'],
                      allowMultiple: false,
                      withData: true,
                    );
                    final bytes = selectResult?.files.firstOrNull?.bytes;
                    if (bytes != null) {
                      final battleSetup = BattleSetup.fromJson(jsonDecode(utf8.decode(bytes)));
                      playerOptions = battleSetup.playerOptions;
                      raptureOption = battleSetup.raptureOptions;
                      nikkeOptions = battleSetup.nikkeOptions;
                      while (nikkeOptions.length < 5) {
                        nikkeOptions.add(BattleNikkeOptions(nikkeResourceId: -1));
                      }
                      nikkeOptions = nikkeOptions.sublist(0, 5);
                    }
                    if (mounted) setState(() {});
                  },
                  icon: Icon(Icons.file_open),
                  label: Text('Load Settings'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RaptureDisplay extends StatefulWidget {
  final BattleRaptureOptions option;

  const RaptureDisplay({super.key, required this.option});

  @override
  State<RaptureDisplay> createState() => _RaptureDisplayState();
}

class _RaptureDisplayState extends State<RaptureDisplay> {
  BattleRaptureOptions get option => widget.option;

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat.decimalPattern();

    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        verticalDirection: VerticalDirection.down,
        spacing: 5,
        children: [
          buildRaptureIcon(option),
          Text(option.name, maxLines: 1),
          Text('HP: ${format.format(option.startHp)}'),
          Text('ATK: ${format.format(option.startAttack)}'),
          Text('DEF: ${format.format(option.startDefence)}'),
          Text('Distance: ${format.format(option.startDistance)}'),
          FilledButton.icon(
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (ctx) => RaptureSetupPage(option: option)));
              if (mounted) setState(() {});
            },
            label: Text('Configure'),
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}

class NikkeDisplay extends StatefulWidget {
  final BattleNikkeOptions option;
  final BattlePlayerOptions playerOptions;
  final List<BattleHarmonyCube> cubes;

  const NikkeDisplay({super.key, required this.option, required this.cubes, required this.playerOptions});

  @override
  State<NikkeDisplay> createState() => _NikkeDisplayState();
}

class _NikkeDisplayState extends State<NikkeDisplay> {
  BattleNikkeOptions get option => widget.option;

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat.decimalPattern();
    final characterData = db.characterResourceGardeTable[option.nikkeResourceId]?[option.coreLevel];
    final name = db.getTranslation(characterData?.nameLocalkey)?.zhCN ?? characterData?.resourceId;
    final weapon = db.characterShotTable[characterData?.shotId];

    final doll = option.favoriteItem;
    final dollString =
        doll == null
            ? 'None'
            : '${doll.rarity.name.toUpperCase()} (Lv ${doll.rarity == Rarity.ssr ? dollLvString(doll, doll.level) : doll.level})';

    final List<Widget> statDisplays = [];

    if (characterData != null) {
      final Map<EquipLineType, int> equipLineVals = {};
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
              equipLineVals.putIfAbsent(equipLine.type, () => 0);
              equipLineVals[equipLine.type] = equipLineVals[equipLine.type]! + function.functionValue;
            }
          }
        }
      }

      final baseStat =
          db.groupedCharacterStatTable[characterData.statEnhanceId]?[option.syncLevel] ?? CharacterStatData.emptyData;
      final statEnhanceData =
          db.characterStatEnhanceTable[characterData.statEnhanceId] ?? CharacterStatEnhanceData.emptyData;
      final attractiveStat =
          db.attractiveStatTable[option.attractLevel]?.getStatData(characterData.characterClass) ??
          ClassAttractiveStatData.emptyData;

      final baseHp = BattleUtils.getBaseStat(
        coreLevel: option.coreLevel,
        baseStat: baseStat.hp,
        gradeRatio: statEnhanceData.gradeRatio,
        gradeEnhanceBase: statEnhanceData.gradeHp,
        coreEnhanceBaseRatio: statEnhanceData.coreHp,
        consoleStat: widget.playerOptions.getRecycleHp(characterData.characterClass),
        bondStat: attractiveStat.hpRate,
        equipStat: option.equips.fold(
          0,
          (sum, equip) => sum + (equip?.getStat(StatType.hp, characterData.corporation) ?? 0),
        ),
        cubeStat: option.cube?.getStat(StatType.hp) ?? 0,
        dollStat: option.favoriteItem?.getStat(StatType.hp) ?? 0,
      );
      final baseAtk = BattleUtils.getBaseStat(
        coreLevel: option.coreLevel,
        baseStat: baseStat.attack,
        gradeRatio: statEnhanceData.gradeRatio,
        gradeEnhanceBase: statEnhanceData.gradeAttack,
        coreEnhanceBaseRatio: statEnhanceData.coreAttack,
        consoleStat: widget.playerOptions.getRecycleAttack(characterData.corporation),
        bondStat: attractiveStat.attackRate,
        equipStat: option.equips.fold(
          0,
          (sum, equip) => sum + (equip?.getStat(StatType.atk, characterData.corporation) ?? 0),
        ),
        cubeStat: option.cube?.getStat(StatType.atk) ?? 0,
        dollStat: option.favoriteItem?.getStat(StatType.atk) ?? 0,
      );
      final baseDef = BattleUtils.getBaseStat(
        coreLevel: option.coreLevel,
        baseStat: baseStat.defence,
        gradeRatio: statEnhanceData.gradeRatio,
        gradeEnhanceBase: statEnhanceData.gradeDefence,
        coreEnhanceBaseRatio: statEnhanceData.coreDefence,
        consoleStat: widget.playerOptions.getRecycleDefence(characterData.characterClass, characterData.corporation),
        bondStat: attractiveStat.defenceRate,
        equipStat: option.equips.fold(
          0,
          (sum, equip) => sum + (equip?.getStat(StatType.defence, characterData.corporation) ?? 0),
        ),
        cubeStat: option.cube?.getStat(StatType.defence) ?? 0,
        dollStat: option.favoriteItem?.getStat(StatType.defence) ?? 0,
      );

      statDisplays.addAll([
        Text('Base HP: ${format.format(baseHp)}'),
        Text('Base ATK: ${format.format(baseAtk)}'),
        Text('Base DEF: ${format.format(baseDef)}'),
        Divider(),
        Text('Sync: ${option.syncLevel}'),
        Text('Core: ${coreString(option.coreLevel)}'),
        Text('Attract: ${option.attractLevel}'),
        Text('Skill: ${option.skillLevels.map((lv) => lv.toString()).join('/')}'),
        Text('Doll: $dollString'),
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 16,
              constraints: BoxConstraints(maxHeight: 16),
              padding: EdgeInsets.zero,
              icon: Icon(Icons.info),
              onPressed: () {},
              tooltip:
                  equipLineVals.isEmpty
                      ? 'No Lines Set'
                      : equipLineVals.keys
                          .map(
                            (equipLineType) =>
                                '$equipLineType:'
                                ' ${(equipLineVals[equipLineType]! / 100).toStringAsFixed(2)}%',
                          )
                          .join('\n'),
            ),
            Text(
              'Gear: ${option.equips.map((equip) {
                if (equip == null || equip.rarity == EquipRarity.unknown) return '-';

                return '${equip.rarity.name.toUpperCase()}'
                    '${equip.rarity.canHaveCorp && equip.corporation == characterData.corporation ? 'C' : ''}';
              }).join('/')}',
            ),
          ],
        ),
        Text(
          'Gear Lv: ${option.equips.map((equip) {
            if (equip == null || equip.rarity == EquipRarity.unknown) return '-';

            return '${equip.level}';
          }).join('/')}',
        ),
        TextButton.icon(
          onPressed: () async {
            final result = await showDialog<BattleHarmonyCube?>(
              context: context,
              builder: (ctx) {
                return SimpleConfirmDialog(
                  title: Text('Select Cube'),
                  showCancel: false,
                  showOk: false,
                  content: CubeSettingDialog(cubes: widget.cubes, selectMode: true, currentSelection: option.cube),
                );
              },
            );

            option.cube = result == option.cube ? null : result ?? option.cube;
            setState(() {});
          },
          icon: Icon(Icons.grid_view_sharp, size: 12),
          label: Text('Cube: ${option.cube != null ? '${option.cube!.type} Lv ${option.cube!.cubeLevel}' : 'None'}'),
        ),
      ]);

      if (WeaponType.chargeWeaponTypes.contains(weapon?.weaponType)) {
        statDisplays.addAll([
          Divider(),
          Text('Always Focus: ${option.alwaysFocus}'),
          Text('Cancel Charge Delay: ${option.forceCancelShootDelay}'),
          Text('Charge Mode: ${option.chargeMode.name}'),
        ]);
      }
    }

    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        verticalDirection: VerticalDirection.down,
        spacing: 5,
        children: [
          InkWell(
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (ctx) => NikkeSelectorPage(option: option)));
              if (mounted) setState(() {});
            },
            child: buildNikkeIcon(characterData, true, 'Tap to select'),
          ),
          Text(name == null ? 'None' : '$name / ${weapon?.weaponType}', maxLines: 1),
          ...statDisplays,
        ],
      ),
    );
  }
}

class CubeSettingDialog extends StatefulWidget {
  final List<BattleHarmonyCube> cubes;
  final BattleHarmonyCube? currentSelection;
  final bool selectMode;
  const CubeSettingDialog({super.key, required this.cubes, this.selectMode = false, this.currentSelection});

  @override
  State<CubeSettingDialog> createState() => _CubeSettingDialogState();
}

class _CubeSettingDialogState extends State<CubeSettingDialog> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 3,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.cubes.length, (index) {
          final cube = widget.cubes[index];
          final isSelected = cube == widget.currentSelection;
          return Row(
            children: [
              if (widget.selectMode)
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(cube);
                    setState(() {});
                  },
                  icon: Icon(isSelected ? Icons.remove_circle_outline : Icons.check),
                ),
              Flexible(
                child: SliderWithPrefix(
                  titled: true,
                  label: cube.type.toString(),
                  min: 1,
                  max: 15,
                  valueFormatter: (v) => 'Lv $v',
                  value: cube.cubeLevel,
                  onChange: (newValue) {
                    cube.cubeLevel = newValue.round();
                    if (mounted) setState(() {});
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class GlobalSettingDialog extends StatefulWidget {
  final BattlePlayerOptions playerOptions;
  final int defaultGlobalSync;
  final void Function(int) onGlobalSyncChange;
  const GlobalSettingDialog({
    super.key,
    required this.playerOptions,
    required this.defaultGlobalSync,
    required this.onGlobalSyncChange,
  });

  @override
  State<GlobalSettingDialog> createState() => _GlobalSettingDialogState();
}

class _GlobalSettingDialogState extends State<GlobalSettingDialog> {
  BattlePlayerOptions get option => widget.playerOptions;
  int globalSync = 0;

  @override
  void initState() {
    super.initState();

    globalSync = widget.defaultGlobalSync;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 3,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 5,
            children: [
              Text('Global Sync'),
              SizedBox(
                width: 100,
                child: RangedNumberTextField(
                  minValue: 1,
                  maxValue: db.maxSyncLevel,
                  defaultValue: globalSync,
                  onChangeFunction: (newValue) {
                    globalSync = newValue;
                    widget.onGlobalSyncChange(newValue);
                    if (mounted) setState(() {});
                  },
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 5,
            children: [
              Text('Personal Research'),
              SizedBox(
                width: 100,
                child: RangedNumberTextField(
                  minValue: 1,
                  maxValue: maxResearchLevel(db.maxSyncLevel),
                  defaultValue: option.personalRecycleLevel,
                  onChangeFunction: (newValue) {
                    option.personalRecycleLevel = newValue;
                    if (mounted) setState(() {});
                  },
                ),
              ),
            ],
          ),
          Row(
            spacing: 5,
            children: [
              Icon(Icons.info, size: 12),
              Text('Max research level for current global sync is ${maxResearchLevel(globalSync)}'),
            ],
          ),
          Divider(),
          ...List.generate(3, (index) {
            final type = [NikkeClass.attacker, NikkeClass.defender, NikkeClass.supporter][index];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 5,
              children: [
                Text(type.name.toUpperCase()),
                SizedBox(
                  width: 100,
                  child: RangedNumberTextField(
                    minValue: 1,
                    maxValue: maxResearchLevel(db.maxSyncLevel),
                    defaultValue: option.classRecycleLevels[type] ?? 0,
                    onChangeFunction: (newValue) {
                      option.classRecycleLevels[type] = newValue;
                      if (mounted) setState(() {});
                    },
                  ),
                ),
              ],
            );
          }),
          Divider(),
          ...List.generate(5, (index) {
            final type =
                [
                  Corporation.elysion,
                  Corporation.missilis,
                  Corporation.tetra,
                  Corporation.pilgrim,
                  Corporation.abnormal,
                ][index];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 5,
              children: [
                Text(type.name.toUpperCase()),
                SizedBox(
                  width: 100,
                  child: RangedNumberTextField(
                    maxValue: maxResearchLevel(db.maxSyncLevel),
                    defaultValue: option.corpRecycleLevels[type] ?? 0,
                    onChangeFunction: (newValue) {
                      option.corpRecycleLevels[type] = newValue;
                      if (mounted) setState(() {});
                    },
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
