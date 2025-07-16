import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/monster.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';
import 'package:nikke_einkk/module/common/simple_dialog.dart';
import 'package:nikke_einkk/module/common/slider.dart';
import 'package:nikke_einkk/module/monsters/monster_list.dart';

class RaptureSetupPage extends StatefulWidget {
  final bool useGlobal;
  final BattleRaptureOptions option;
  final int fps;
  final int maxSeconds;

  const RaptureSetupPage({
    super.key,
    required this.option,
    required this.useGlobal,
    required this.maxSeconds,
    required this.fps,
  });

  @override
  State<RaptureSetupPage> createState() => _RaptureSetupPageState();
}

class _RaptureSetupPageState extends State<RaptureSetupPage> {
  bool get useGlobal => widget.useGlobal;
  NikkeDatabase get db => useGlobal ? global : cn;
  BattleRaptureOptions get option => widget.option;
  final TextEditingController nameController = TextEditingController();
  final ScrollController partScrollController = ScrollController();
  int nextPartId = 1;

  int get fps => widget.fps;
  int get maxSeconds => widget.maxSeconds;

  MonsterData? get data => db.raptureData[option.monsterId];
  Map<int, MonsterStatEnhanceData>? get levelDataGroup => db.monsterStatEnhanceData[data?.statEnhanceId];
  MonsterStatEnhanceData? get levelData => db.monsterStatEnhanceData[data?.statEnhanceId]?[option.level];

  @override
  void initState() {
    super.initState();
    nameController.text = option.name;
    for (final partId in option.parts.keys) {
      if (partId >= nextPartId) {
        nextPartId = partId + 1;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    partScrollController.dispose();
  }

  Future<void> selectRaptureFromList() async {
    final MonsterData? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => MonsterListPage(onSelect: true, forceRegion: useGlobal)),
    );

    if (result != null) {
      option.monsterId = result.id;
      option.name = result.nameKey;
      option.element = NikkeElement.fromId(result.elementIds.firstOrNull);
      if (levelData == null) {
        final levelDataGroup = db.monsterStatEnhanceData[result.statEnhanceId];
        if (levelDataGroup != null) {
          final firstLv = levelDataGroup.keys.first;
          final minLv = levelDataGroup.keys.fold(firstLv, min);
          final maxLv = levelDataGroup.keys.fold(firstLv, max);
          option.level = option.level == null ? minLv : option.level!.clamp(minLv, maxLv);
        }
      }
      setOptionsByLevelData(levelData);
      setState(() {});
    }
  }

  void setOptionsByLevelData(MonsterStatEnhanceData? levelData) {
    if (levelData == null) return;

    option.level = levelData.lv;
    option.startHp = levelData.levelHp;
    option.startAttack = levelData.levelAttack;
    option.startDefence = levelData.levelDefence;
    option.brokenHp = levelData.levelBrokenHp;
    option.projectileHp = levelData.levelProjectileHp;
    option.damageRatio = levelData.levelStatDamageRatio;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      Align(child: buildRaptureIcon(option)),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: [FilledButton(onPressed: selectRaptureFromList, child: Text('Select From List'))],
      ),
    ];
    final levelDataGroup = db.monsterStatEnhanceData[data?.statEnhanceId];
    if (levelDataGroup != null) {
      final levels = levelDataGroup.keys.toList();
      levels.sort();
      children.addAll([
        SliderWithPrefix(
          constraint: false,
          titled: false,
          leadingWidth: 80,
          label: 'Level',
          min: 0,
          max: levels.length - 1,
          value: levels.indexOf(option.level ?? levels.first),
          valueFormatter: (v) => 'Lv${levels[v]}',
          onChange: (newValue) {
            final idx = newValue.round();
            option.level = levels[idx];
            setOptionsByLevelData(levelDataGroup[option.level!]);
            if (mounted) setState(() {});
          },
        ),
      ]);
    }
    children.addAll([
      Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 15,
        children: [
          Text('HP: ${(option.startHp * toModifier(data?.hpRatio ?? 10000)).decimalPattern}'),
          Text('ATK: ${(option.startAttack * toModifier(data?.attackRatio ?? 10000)).decimalPattern}'),
          Text('DEF: ${(option.startDefence * toModifier(data?.defenceRatio ?? 10000)).decimalPattern}'),
          Text('Damage Ratio: ${option.damageRatio.percentString}'),
          Text('Projectile HP: ${option.projectileHp.decimalPattern}'),
          Text('Part Broken Bonus HP: ${option.brokenHp.decimalPattern}'),
          Text('Distance: ${option.startDistance}'),
        ],
      ),
    ]);

    return Scaffold(
      appBar: AppBar(title: const Text('Rapture Setup')),
      bottomNavigationBar: commonBottomNavigationBar(() => setState(() {})),
      body: ListView(padding: EdgeInsets.all(10), children: children),
    );

    // return Scaffold(
    //   appBar: AppBar(title: const Text('Rapture Options')),
    //   body: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       spacing: 3,
    //       children: [
    //         buildSettingRow(),
    //         Divider(),
    //         Row(
    //           spacing: 5,
    //           children: [
    //             Text('Parts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
    //             FilledButton.icon(
    //               onPressed: () {
    //                 option.parts[nextPartId] = BattleRaptureParts(id: nextPartId);
    //                 nextPartId += 1;
    //                 setState(() {});
    //               },
    //               label: Text('Add Part'),
    //               icon: Icon(Icons.add_circle),
    //             ),
    //           ],
    //         ),
    //         Scrollbar(
    //           thumbVisibility: true,
    //           trackVisibility: true,
    //           interactive: true,
    //           controller: partScrollController,
    //           scrollbarOrientation: ScrollbarOrientation.bottom,
    //           child: Padding(
    //             padding: const EdgeInsets.all(16.0),
    //             child: SingleChildScrollView(
    //               controller: partScrollController,
    //               scrollDirection: Axis.horizontal,
    //               child: Row(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 spacing: 5,
    //                 children: option.parts.keys.map((partId) => buildPart(partId)).toList(),
    //               ),
    //             ),
    //           ),
    //         ),
    //         Divider(),
    //         Row(
    //           spacing: 5,
    //           children: [
    //             Text('Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
    //             // remove All button
    //             // shift all timestamps button
    //             // clear selection button
    //             // copy button
    //             // add new action button
    //             IconButton.filled(
    //               onPressed: () async {
    //                 final action = await showDialog<BattleRaptureAction?>(
    //                   context: context,
    //                   barrierDismissible: false,
    //                   builder: (ctx) {
    //                     return RaptureActionSetupDialog(
    //                       maxFrame: maxSeconds * fps,
    //                       fps: fps,
    //                       validParts: option.parts.keys.toList(),
    //                     );
    //                   },
    //                 );
    //                 if (action != null) {
    //                   option.actions.putIfAbsent(action.frame, () => []);
    //                   option.actions[action.frame]!.add(action);
    //                   setState(() {});
    //                 }
    //               },
    //               icon: Icon(Icons.add),
    //             ),
    //           ],
    //         ),
    //         Expanded(child: ListView(children: buildActionWidgets())),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget buildPart(int partId) {
    final part = option.parts[partId]!;
    return Container(
      width: 200,
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        spacing: 3,
        children: [
          Row(
            spacing: 5,
            children: [
              Text('Part ${part.id}'),
              IconButton(
                color: Colors.red,
                onPressed: () {
                  option.parts.remove(partId);
                  setState(() {});
                },
                icon: Icon(Icons.remove_circle, size: 16),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 5,
            children: [
              Text('Part HP'),
              FilledButton(
                onPressed: () async {
                  int newHp = part.maxHp;
                  final changed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) {
                      return SimpleConfirmDialog(
                        title: Text('Configure Part HP'),
                        showCancel: true,
                        showOk: true,
                        content: RangedNumberTextField(
                          minValue: 1,
                          defaultValue: part.maxHp,
                          onChangeFunction: (newValue) {
                            newHp = newValue;
                          },
                        ),
                      );
                    },
                  );

                  if (changed == true) {
                    part.maxHp = newHp;
                  }
                  setState(() {});
                },
                child: Text('${part.maxHp}'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 5,
            children: [
              Text('Is core'),
              Switch(
                value: part.isCore,
                onChanged: (v) {
                  part.isCore = v;
                  if (mounted) setState(() {});
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 5,
            children: [
              Text('Behind boss'),
              Switch(
                value: part.isBehindBoss,
                onChanged: (v) {
                  part.isBehindBoss = v;
                  if (mounted) setState(() {});
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> buildActionWidgets() {
    final List<Widget> widgets = [];

    for (final frame in option.actions.keys) {
      widgets.add(
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Timestamp: ${frameDataToNiceTimeString(frame, fps)} (frame $frame)'),
                ...option.actions[frame]!.map((action) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(padding: const EdgeInsets.all(8.0), child: convertActionToWidget(action)),
                  );
                }),
              ],
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  Widget convertActionToWidget(BattleRaptureAction action) {
    switch (action.type) {
      case BattleRaptureActionType.setAtk:
      case BattleRaptureActionType.setDef:
      case BattleRaptureActionType.setDistance:
        return Text('${action.type} - ${action.setParameter}');
      case BattleRaptureActionType.setCoreSize:
        return Text('${action.type} - ${action.setParameter != 0}');
      case BattleRaptureActionType.jump:
      case BattleRaptureActionType.invincible:
      case BattleRaptureActionType.redCircle:
        return Text(
          '${action.type} - '
          'Duration: ${action.frameDuration} frames,'
          ' ${(action.frameDuration! / fps).toStringAsFixed(3)} seconds',
        );
      case BattleRaptureActionType.elementalShield:
        return Text(
          '${action.type} - '
          'Elements: ${action.eleShields!.map((ele) => ele.name.toUpperCase()).toList()} - '
          'Duration: ${action.frameDuration} frames,'
          ' ${(action.frameDuration! / fps).toStringAsFixed(3)} seconds',
        );
      case BattleRaptureActionType.generateBarrier:
        return Text(
          '${action.type} - '
          'HP: ${action.barrierHp} - '
          'Duration: ${action.frameDuration} frames,'
          ' ${(action.frameDuration! / fps).toStringAsFixed(3)} seconds',
        );
      case BattleRaptureActionType.generateParts:
        return Text(
          '${action.type} - Part ID: ${action.partId}'
          '${!option.parts.keys.contains(action.partId) ? ' Invalid' : ''}',
          style: TextStyle(color: option.parts.keys.contains(action.partId) ? Colors.black : Colors.red),
        );
      case BattleRaptureActionType.attack:
        String text =
            '${action.type} - '
            'Damage Rate: ${action.damageRate} - '
            'Target Type: ${action.targetType!.name}';
        if (action.targetType == BattleRaptureActionTarget.targetedNikkes) {
          text += ' - Subtype: ${action.targetSubtype!.name}';
          if (action.targetSubtype == BattleRaptureActionTargetSubtype.position) {
            text += ', Position ${action.position}';
          } else {
            text += ', ${action.targetCount} Nikkes Sort ${action.sortHighToLow! ? 'High to Low' : 'Low to High'}';
          }
        }
        return Text(text);
      case BattleRaptureActionType.setBuff:
        String text =
            '${action.type} - '
            'Buff Type: ${action.buffType!.name} - '
            'Buff Value: ${action.buffValue} '
            '(Treat as ${action.isBuff! ? 'Buff' : 'Debuff'}) - '
            'Duration Type: ${action.durationType!.name} ';
        if (action.durationType == DurationType.timeSec) {
          text +=
              'Duration: ${action.frameDuration} frames,'
              ' ${(action.frameDuration! / fps).toStringAsFixed(3)} seconds ';
        }
        text += '- Target Type: ${action.targetType!.name}';
        if (action.targetType == BattleRaptureActionTarget.targetedNikkes) {
          text += ' - Subtype: ${action.targetSubtype!.name}';
          if (action.targetSubtype == BattleRaptureActionTargetSubtype.position) {
            text += ', Position ${action.position}';
          } else {
            text += ', ${action.targetCount} Nikkes Sort ${action.sortHighToLow! ? 'High to Low' : 'Low to High'}';
          }
        }
        return Text(text);
      case BattleRaptureActionType.clearBuff:
        String text =
            '${action.type} - '
            'Clear ${action.isBuff! ? 'Buff' : 'Debuff'} - '
            'Target Type: ${action.targetType!.name}';
        if (action.targetType == BattleRaptureActionTarget.targetedNikkes) {
          text += ' - Subtype: ${action.targetSubtype!.name}';
          if (action.targetSubtype == BattleRaptureActionTargetSubtype.position) {
            text += ', Position ${action.position}';
          } else {
            text += ', ${action.targetCount} Nikkes Sort ${action.sortHighToLow! ? 'High to Low' : 'Low to High'}';
          }
        }
        return Text(text);
      case BattleRaptureActionType.jumpEnd:
      case BattleRaptureActionType.invincibleEnd:
      case BattleRaptureActionType.redCircleEnd:
      case BattleRaptureActionType.elementalShieldEnd:
        return Text('${action.type} - invalid');
    }
  }

  Widget buildSettingRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        buildRaptureIcon(option),
        SizedBox(
          width: 200,
          child: Column(
            spacing: 3,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 5,
                children: [
                  Text('Start HP'),
                  SizedBox(
                    width: 100,
                    child: RangedNumberTextField(
                      minValue: 1,
                      defaultValue: option.startHp,
                      onChangeFunction: (value) {
                        option.startHp = value;
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 5,
                children: [
                  Text('Start ATK'),
                  SizedBox(
                    width: 100,
                    child: RangedNumberTextField(
                      minValue: 0,
                      defaultValue: option.startAttack,
                      onChangeFunction: (value) {
                        option.startAttack = value;
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 5,
                children: [
                  Text('Start DEF'),
                  SizedBox(
                    width: 100,
                    child: RangedNumberTextField(
                      minValue: 0,
                      defaultValue: option.startDefence,
                      onChangeFunction: (value) {
                        option.startDefence = value;
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: 200,
          child: Column(
            spacing: 3,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 5,
                children: [
                  Text('Start Distance'),
                  SizedBox(
                    width: 100,
                    child: RangedNumberTextField(
                      minValue: 0,
                      defaultValue: option.startDistance,
                      onChangeFunction: (value) {
                        option.startDistance = value;
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 5,
                children: [
                  Text('Name'),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(border: const OutlineInputBorder()),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          option.name = value;
                          setState(() {});
                        }
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 5,
                children: [
                  Text('Element'),
                  DropdownMenu<NikkeElement>(
                    width: 100,
                    textStyle: TextStyle(fontSize: 12),
                    initialSelection: option.element,
                    onSelected: (NikkeElement? value) {
                      option.element = value!;
                      setState(() {});
                    },
                    dropdownMenuEntries: UnmodifiableListView<DropdownMenuEntry<NikkeElement>>(
                      NikkeElement.values.map<DropdownMenuEntry<NikkeElement>>(
                        (NikkeElement type) => DropdownMenuEntry<NikkeElement>(
                          value: type,
                          label: type == NikkeElement.unknown ? 'None' : type.name.toUpperCase(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: 200,
          child: Column(
            spacing: 3,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 3,
                children: [
                  Text('Core'),
                  Switch(
                    value: option.coreSize != 0,
                    onChanged: (v) {
                      option.coreSize = v ? 10 : 0;
                      if (mounted) setState(() {});
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
