import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/data_path.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';
import 'package:nikke_einkk/model/user_data.dart';
import 'package:nikke_einkk/module/battle/battle_simulation_page.dart';
import 'package:nikke_einkk/module/battle/nikke_setup.dart';
import 'package:nikke_einkk/module/battle/rapture_setup.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';
import 'package:nikke_einkk/module/nikkes/global_nikke_settings.dart';
import 'package:nikke_einkk/module/nikkes/nikke_widgets.dart';

class BattleSetupPage extends StatefulWidget {
  const BattleSetupPage({super.key});

  @override
  State<BattleSetupPage> createState() => _BattleSetupPageState();
}

class _BattleSetupPageState extends State<BattleSetupPage> {
  bool useGlobal = true;
  NikkeDatabase get db => useGlobal ? global : cn;
  BattleSetup setup = BattleSetup(
    playerOptions: PlayerOptions(),
    nikkeOptions: List.generate(5, (_) => NikkeOptions(nikkeResourceId: -1)),
    raptureOptions: BattleRaptureOptions(),
  );
  BattleRaptureOptions get raptureOption => setup.raptureOptions;
  List<NikkeOptions> get nikkeOptions => setup.nikkeOptions;
  PlayerOptions get playerOptions => setup.playerOptions;
  final Map<int, int> cubeLvs = {};

  @override
  void initState() {
    super.initState();
    useGlobal = userDb.useGlobal;
    setup.playerOptions = userDb.playerOptions.copy();
    cubeLvs.clear();
    cubeLvs.addAll(userDb.cubeLvs);
  }

  void serverRadioChange(bool? v) {
    useGlobal = v ?? useGlobal;
    for (final nikkeOption in nikkeOptions) {
      nikkeOption.errorCorrection(db);
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5,
          children: [
            Text('Battle Simulation Setup'),
            Radio(value: true, groupValue: useGlobal, onChanged: serverRadioChange),
            Text('Global', style: TextStyle(fontWeight: useGlobal ? FontWeight.bold : null)),
            Radio(value: false, groupValue: useGlobal, onChanged: serverRadioChange),
            Text('CN', style: TextStyle(fontWeight: !useGlobal ? FontWeight.bold : null)),
          ],
        ),
      ),
      bottomNavigationBar: commonBottomNavigationBar(
        () => setState(() {}),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (ctx) => BattleSimulationPage(
                        nikkeOptions: nikkeOptions,
                        raptureOptions: [raptureOption],
                        playerOptions: playerOptions,
                        useGlobal: useGlobal,
                      ),
                ),
              );
            },
            child: Text('Simulate'),
          ),
          FilledButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (ctx) => GlobalSettingPage(
                        playerOptions: playerOptions,
                        cubeLvs: cubeLvs,
                        db: db,
                        maxSync: db.maxSyncLevel,
                        onGlobalSyncChange: (v) {
                          for (final option in nikkeOptions) {
                            option.syncLevel = v;
                          }
                          setState(() {});
                        },
                        onCubeLvChangeChange: (id, v) {
                          for (final option in nikkeOptions) {
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
          FilledButton.icon(
            onPressed: () async {
              String? outputFile = await FilePicker.platform.saveFile(
                dialogTitle: 'Save battle setup',
                fileName: 'battleSetup.json',
                initialDirectory: userDataPath,
                type: FileType.custom,
                allowedExtensions: ['json'],
              );
              if (outputFile != null) {
                final file = File(outputFile);
                await file.writeAsString(jsonEncode(setup.toJson()), encoding: utf8);
                EasyLoading.showSuccess('Saved setup!');
              }
              if (mounted) setState(() {});
            },
            icon: Icon(Icons.save),
            label: Text('Save'),
          ),
          FilledButton.icon(
            onPressed: () async {
              final selectResult = await FilePicker.platform.pickFiles(
                dialogTitle: 'Load battle setup',
                initialDirectory: userDataPath,
                type: FileType.custom,
                allowedExtensions: ['json'],
                allowMultiple: false,
                withData: true,
              );
              final bytes = selectResult?.files.firstOrNull?.bytes;
              if (bytes != null) {
                try {
                  setup = BattleSetup.fromJson(jsonDecode(utf8.decode(bytes)));
                  while (nikkeOptions.length < 5) {
                    nikkeOptions.add(NikkeOptions(nikkeResourceId: -1));
                  }
                  setup.nikkeOptions = nikkeOptions.sublist(0, 5);
                  EasyLoading.showSuccess('Loaded setup!');
                } catch (e) {
                  EasyLoading.showError('Invalid file!');
                }
                if (mounted) setState(() {});
              }
            },
            icon: Icon(Icons.file_open),
            label: Text('Load'),
          ),
        ],
      ),
      body: ListView(
        children: [
          Align(child: Text('Nikkes', style: TextStyle(fontSize: 20))),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(5, (index) {
              return Expanded(
                child: NikkeDisplay(
                  useGlobal: useGlobal,
                  option: nikkeOptions[index],
                  playerOptions: playerOptions,
                  cubeLvs: cubeLvs,
                ),
              );
            }),
          ),
          Divider(),
          Align(child: Text('Rapture', style: TextStyle(fontSize: 20))),
          Align(child: RaptureDisplay(option: raptureOption)),
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
  final NikkeOptions option;
  final PlayerOptions playerOptions;
  final bool useGlobal;
  final Map<int, int> cubeLvs;

  const NikkeDisplay({
    super.key,
    required this.useGlobal,
    required this.option,
    required this.playerOptions,
    required this.cubeLvs,
  });

  @override
  State<NikkeDisplay> createState() => _NikkeDisplayState();
}

class _NikkeDisplayState extends State<NikkeDisplay> {
  NikkeOptions get option => widget.option;
  bool get useGlobal => widget.useGlobal;
  NikkeDatabase get db => useGlobal ? global : cn;

  @override
  Widget build(BuildContext context) {
    final characterData = db.characterResourceGardeTable[option.nikkeResourceId]?[option.coreLevel];
    final weapon = db.characterShotTable[characterData?.shotId];

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

      statDisplays.addAll([
        Text('Lv ${option.syncLevel} ${coreString(option.coreLevel)}'),
        Text('Attract Lv${option.attractLevel}'),
        Text(option.skillLevels.map((lv) => lv.toString()).join('/')),
      ]);

      final cube = option.cube;
      if (cube != null) {
        final cubeData = db.harmonyCubeTable[cube.cubeId];
        final localeKey = cubeData?.nameLocalkey;
        final colorCode = int.tryParse('0xFF${cubeData?.bgColor}');

        statDisplays.add(
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 5,
            children: [
              Icon(Icons.square, color: colorCode != null ? Color(colorCode) : null, size: 14),
              AutoSizeText('${locale.getTranslation(localeKey) ?? localeKey ?? 'Not Found'} Lv${cube.cubeLevel}'),
            ],
          ),
        );
      } else {
        statDisplays.add(Text('No Cube'));
      }

      final doll = option.favoriteItem;
      if (doll != null) {
        statDisplays.add(
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 5,
            children: [
              Icon(Icons.person, color: doll.rarity.color, size: 14),
              Text(dollLvString(doll.rarity, doll.level)),
            ],
          ),
        );
      } else {
        statDisplays.add(Text('No Doll'));
      }

      statDisplays.add(
        Wrap(
          spacing: 5,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (equipLineVals.isNotEmpty)
              Tooltip(
                message: equipLineVals.keys
                    .map(
                      (equipLineType) =>
                          '$equipLineType:'
                          ' ${(equipLineVals[equipLineType]! / 100).toStringAsFixed(2)}%',
                    )
                    .join('\n'),
                child: Icon(Icons.info_outline, size: 14),
              ),
            ...NikkeOptions.equipTypes.mapIndexed((idx, type) {
              final equip = option.equips[idx];
              final equipText =
                  equip == null
                      ? '-'
                      : '${equip.rarity.name.toUpperCase()}${equip.rarity.canHaveCorp && equip.corporation == characterData.corporation ? 'C' : ''} Lv${equip.level}';
              return Text('${type.name}: $equipText');
            }),
          ],
        ),
      );

      if (WeaponType.chargeWeaponTypes.contains(weapon?.weaponType)) {
        statDisplays.addAll([
          Divider(),
          Wrap(
            spacing: 5,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [Text('Always Focus:'), Text('${option.alwaysFocus}')],
          ),
          Wrap(
            spacing: 5,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [Text('Cancel Charge Delay:'), Text('${option.forceCancelShootDelay}')],
          ),
          Wrap(
            spacing: 5,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [Text('Charge Mode:'), Text(option.chargeMode.name)],
          ),
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
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => NikkeEditorPage(option: option, cubeLvs: widget.cubeLvs, useGlobal: useGlobal),
                ),
              );
              if (mounted) setState(() {});
            },
            child: NikkeIcon(
              isSelected: true,
              characterData: characterData,
              weapon: weapon,
              defaultText: 'Tap to Edit',
            ),
          ),
          ...statDisplays,
        ],
      ),
    );
  }
}
