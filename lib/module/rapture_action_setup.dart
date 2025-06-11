import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';
import 'package:nikke_einkk/module/common/simple_dialog.dart';
import 'package:nikke_einkk/module/common/slider.dart';

class RaptureActionSetupDialog extends StatefulWidget {
  final int maxFrame;
  final int fps;
  final List<int> validParts;

  const RaptureActionSetupDialog({super.key, required this.maxFrame, required this.fps, required this.validParts});

  @override
  State<RaptureActionSetupDialog> createState() => _RaptureActionSetupDialogState();
}

class _RaptureActionSetupDialogState extends State<RaptureActionSetupDialog> {
  int get maxFrame => widget.maxFrame;
  String get maxSeconds => (maxFrame / fps).toStringAsFixed(3);
  int get fps => widget.fps;

  int frame = 0;
  int setParam = 0;
  bool boolParam = false;
  int duration = 0;
  DurationType durationType = DurationType.timeSec;
  int barrierHp = 1;
  NikkeElement codeBarrierElement = NikkeElement.electric;
  int partId = 0;
  BattleRaptureActionTarget actionTarget = BattleRaptureActionTarget.allNikkes;
  int damageRate = 0;
  BattleRaptureActionTargetSubtype targetSubtype = BattleRaptureActionTargetSubtype.position;
  int targetCount = 1;
  bool highToLow = false;
  int position = 1;
  FunctionType buffType = FunctionType.statDef;
  TextEditingController buffValueController = TextEditingController();
  bool isBuff = false;
  BattleRaptureActionType actionType = BattleRaptureActionType.setAtk;
  String? errorText;

  static List<BattleRaptureActionType> validActionTypes = [
    BattleRaptureActionType.setAtk,
    BattleRaptureActionType.setDef,
    BattleRaptureActionType.setDistance,
    BattleRaptureActionType.setCoreSize,
    BattleRaptureActionType.setCorePierce,
    BattleRaptureActionType.jump,
    BattleRaptureActionType.invincible,
    BattleRaptureActionType.redCircle,
    BattleRaptureActionType.elementalShield,
    BattleRaptureActionType.generateBarrier,
    BattleRaptureActionType.generateParts,
    BattleRaptureActionType.attack,
    BattleRaptureActionType.setBuff,
    BattleRaptureActionType.clearBuff,
  ];

  static List<BattleRaptureActionType> setIntActionTypes = [
    BattleRaptureActionType.setAtk,
    BattleRaptureActionType.setDef,
    BattleRaptureActionType.setDistance,
  ];

  static List<BattleRaptureActionType> setBoolActionTypes = [
    BattleRaptureActionType.setCoreSize,
    BattleRaptureActionType.setCorePierce,
  ];

  static List<BattleRaptureActionType> timedActionTypes = [
    BattleRaptureActionType.jump,
    BattleRaptureActionType.invincible,
    BattleRaptureActionType.redCircle,
  ];

  static final List<DropdownMenuEntry<BattleRaptureActionType>> actionTypeEntries =
      UnmodifiableListView<DropdownMenuEntry<BattleRaptureActionType>>(
        validActionTypes.map<DropdownMenuEntry<BattleRaptureActionType>>(
          (BattleRaptureActionType type) => DropdownMenuEntry<BattleRaptureActionType>(value: type, label: '$type'),
        ),
      );

  static final List<DropdownMenuEntry<NikkeElement>> codeBarrierElementEntries =
      UnmodifiableListView<DropdownMenuEntry<NikkeElement>>(
        [
          NikkeElement.fire,
          NikkeElement.water,
          NikkeElement.electric,
          NikkeElement.iron,
          NikkeElement.wind,
        ].map<DropdownMenuEntry<NikkeElement>>(
          (NikkeElement type) => DropdownMenuEntry<NikkeElement>(value: type, label: type.name.toUpperCase()),
        ),
      );

  static final List<DropdownMenuEntry<BattleRaptureActionTarget>> actionTargetEntries =
      UnmodifiableListView<DropdownMenuEntry<BattleRaptureActionTarget>>(
        BattleRaptureActionTarget.values.map<DropdownMenuEntry<BattleRaptureActionTarget>>(
          (BattleRaptureActionTarget type) =>
              DropdownMenuEntry<BattleRaptureActionTarget>(value: type, label: type.name),
        ),
      );

  static final List<DropdownMenuEntry<BattleRaptureActionTargetSubtype>> actionTargetSubtypeEntries =
      UnmodifiableListView<DropdownMenuEntry<BattleRaptureActionTargetSubtype>>(
        BattleRaptureActionTargetSubtype.values.map<DropdownMenuEntry<BattleRaptureActionTargetSubtype>>(
          (BattleRaptureActionTargetSubtype type) =>
              DropdownMenuEntry<BattleRaptureActionTargetSubtype>(value: type, label: type.name),
        ),
      );

  @override
  void initState() {
    super.initState();
    buffValueController.text = '0';
  }

  @override
  void dispose() {
    super.dispose();

    buffValueController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [
      if (errorText != null) Text(errorText!, style: TextStyle(color: Colors.red)),
      TextButton(
        child: Text('Cancel'),
        onPressed: () {
          Navigator.of(context).pop(null);
        },
      ),
      TextButton(
        child: Text('Confirm'),
        onPressed: () {
          BattleRaptureAction? action;
          switch (actionType) {
            case BattleRaptureActionType.setAtk:
            case BattleRaptureActionType.setDef:
            case BattleRaptureActionType.setDistance:
              action = BattleRaptureAction.set(actionType, frame, setParam);
              break;
            case BattleRaptureActionType.setCoreSize:
            case BattleRaptureActionType.setCorePierce:
              action = BattleRaptureAction.set(actionType, frame, boolParam ? 10 : 0);
              break;
            case BattleRaptureActionType.jump:
            case BattleRaptureActionType.invincible:
            case BattleRaptureActionType.redCircle:
              action = BattleRaptureAction.timed(actionType, frame, duration);
              break;
            case BattleRaptureActionType.elementalShield:
              action = BattleRaptureAction.eleShield(frame, [codeBarrierElement], duration);
              break;
            case BattleRaptureActionType.generateBarrier:
              action = BattleRaptureAction.barrier(frame, barrierHp, DurationType.timeSec, duration);
              break;
            case BattleRaptureActionType.generateParts:
              action = BattleRaptureAction.parts(frame, partId);
              break;
            case BattleRaptureActionType.attack:
              action = BattleRaptureAction.attack(
                frame: frame,
                targetType: actionTarget,
                damageRate: damageRate,
                targetSubtype: targetSubtype,
                targetCount: targetCount,
                sortHighToLow: highToLow,
                position: position,
              );
              break;
            case BattleRaptureActionType.setBuff:
              final buffValue = int.tryParse(buffValueController.text);
              if (buffValue != null) {
                action = BattleRaptureAction.setBuff(
                  frame: frame,
                  targetType: actionTarget,
                  buffType: buffType,
                  treatAsBuff: isBuff,
                  buffValue: buffValue,
                  durationType: durationType,
                  duration: duration,
                  targetSubtype: targetSubtype,
                  targetCount: targetCount,
                  sortHighToLow: highToLow,
                  position: position,
                );
              } else {
                errorText = 'Not a number';
              }
              break;
            case BattleRaptureActionType.clearBuff:
              action = BattleRaptureAction.clearBuff(
                frame: frame,
                targetType: actionTarget,
                isClearBuff: isBuff,
                targetSubtype: targetSubtype,
                targetCount: targetCount,
                sortHighToLow: highToLow,
                position: position,
              );
              break;
            case BattleRaptureActionType.jumpEnd:
            case BattleRaptureActionType.invincibleEnd:
            case BattleRaptureActionType.redCircleEnd:
            case BattleRaptureActionType.elementalShieldEnd:
              break;
          }
          if (action != null) {
            Navigator.of(context).pop(action);
          }
        },
      ),
    ];

    return AlertDialog(
      title: Text('Edit Rapture Action'),
      content: Column(
        spacing: 3,
        mainAxisSize: MainAxisSize.min,
        children: [
          // timestamp
          Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Timestamp: '),
              Text(
                'Frame $frame,'
                ' Time: ${frameDataToNiceTimeString(frame, fps)}'
                ' (Elapsed time: ${frameDataToNiceTimeString(maxFrame - frame, fps)})',
              ),
              IconButton.filled(
                onPressed: () async {
                  final newTimeframe = await showDialog<int?>(
                    barrierDismissible: false,
                    context: context,
                    builder: (ctx) {
                      return TimeframeSetupDialog(maxFrame: maxFrame, fps: fps, defaultFrame: frame);
                    },
                  );
                  if (newTimeframe != null) {
                    frame = newTimeframe;
                    setState(() {});
                  }
                },
                icon: Icon(Icons.settings),
              ),
            ],
          ),
          Divider(),
          Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Action Type'),
              DropdownMenu<BattleRaptureActionType>(
                width: 300,
                textStyle: TextStyle(fontSize: 12),
                initialSelection: actionType,
                onSelected: (BattleRaptureActionType? value) {
                  actionType = value!;
                  setState(() {});
                },
                dropdownMenuEntries: actionTypeEntries,
              ),
            ],
          ),
          if (setIntActionTypes.contains(actionType))
            Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Set to'),
                SizedBox(
                  width: 300,
                  child: RangedNumberTextField(
                    minValue: 0,
                    defaultValue: setParam,
                    onChangeFunction: (value) {
                      setParam = value;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          if (setBoolActionTypes.contains(actionType))
            Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Set to $boolParam'),
                Switch(
                  value: boolParam,
                  onChanged: (v) {
                    boolParam = v;
                    setState(() {});
                  },
                ),
              ],
            ),
          if (timedActionTypes.contains(actionType))
            Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Duration: $duration frames, ${(duration / fps).toStringAsFixed(3)} seconds'),
                IconButton.filled(
                  onPressed: () async {
                    final newDuration = await showDialog<int?>(
                      barrierDismissible: false,
                      context: context,
                      builder: (ctx) {
                        return TimeframeSetupDialog(
                          maxFrame: maxFrame,
                          fps: fps,
                          defaultFrame: duration,
                          timestampMode: false,
                        );
                      },
                    );
                    if (newDuration != null) {
                      duration = newDuration;
                      setState(() {});
                    }
                  },
                  icon: Icon(Icons.settings),
                ),
              ],
            ),
          if (actionType == BattleRaptureActionType.generateBarrier) ...generateBarrierRows(),
          if (actionType == BattleRaptureActionType.elementalShield) ...generateCodeBarrierRows(),
          if (actionType == BattleRaptureActionType.generateParts) ...partRows(),
          if (actionType == BattleRaptureActionType.attack) ...attackRows(),
          if (actionType == BattleRaptureActionType.setBuff) ...setBuffRows(),
          if (actionType == BattleRaptureActionType.clearBuff) ...clearBuffRows(),
        ],
      ),
      contentPadding: const EdgeInsetsDirectional.fromSTEB(24.0, 20.0, 24.0, 24.0),
      scrollable: true,
      actions: actions,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
    );
  }

  List<Widget> generateBarrierRows() {
    return [
      Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Barrier Duration: $duration frames, ${(duration / fps).toStringAsFixed(3)} seconds'),
          IconButton.filled(
            onPressed: () async {
              final newDuration = await showDialog<int?>(
                barrierDismissible: false,
                context: context,
                builder: (ctx) {
                  return TimeframeSetupDialog(
                    maxFrame: maxFrame,
                    fps: fps,
                    defaultFrame: duration,
                    timestampMode: false,
                  );
                },
              );
              if (newDuration != null) {
                duration = newDuration;
                setState(() {});
              }
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Barrier HP'),
          SizedBox(
            width: 300,
            child: RangedNumberTextField(
              minValue: 1,
              defaultValue: barrierHp,
              onChangeFunction: (value) {
                barrierHp = value;
                setState(() {});
              },
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> generateCodeBarrierRows() {
    return [
      Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Code Barrier Duration: $duration frames, ${(duration / fps).toStringAsFixed(3)} seconds'),
          IconButton.filled(
            onPressed: () async {
              final newDuration = await showDialog<int?>(
                barrierDismissible: false,
                context: context,
                builder: (ctx) {
                  return TimeframeSetupDialog(
                    maxFrame: maxFrame,
                    fps: fps,
                    defaultFrame: duration,
                    timestampMode: false,
                  );
                },
              );
              if (newDuration != null) {
                duration = newDuration;
                setState(() {});
              }
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Code Barrier Element'),
          DropdownMenu<NikkeElement>(
            width: 120,
            textStyle: TextStyle(fontSize: 12),
            initialSelection: codeBarrierElement,
            onSelected: (NikkeElement? value) {
              codeBarrierElement = value!;
              setState(() {});
            },
            dropdownMenuEntries: codeBarrierElementEntries,
          ),
        ],
      ),
    ];
  }

  List<Widget> partRows() {
    return [
      Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Selected partId: $partId'),
          DropdownMenu<int>(
            width: 120,
            textStyle: TextStyle(fontSize: 12),
            initialSelection: partId,
            onSelected: (int? value) {
              partId = value!;
              setState(() {});
            },
            dropdownMenuEntries: UnmodifiableListView<DropdownMenuEntry<int>>(
              widget.validParts.map<DropdownMenuEntry<int>>(
                (int type) => DropdownMenuEntry<int>(value: type, label: 'Part $type'),
              ),
            ),
          ),
        ],
      ),
      if (!widget.validParts.contains(partId))
        Text('Note: this is an invalid part ID!', style: TextStyle(color: Colors.red)),
    ];
  }

  List<Widget> attackRows() {
    final List<Widget> children = [
      Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Target:'),
          DropdownMenu<BattleRaptureActionTarget>(
            width: 300,
            textStyle: TextStyle(fontSize: 12),
            initialSelection: actionTarget,
            onSelected: (BattleRaptureActionTarget? value) {
              actionTarget = value!;
              setState(() {});
            },
            dropdownMenuEntries: actionTargetEntries,
          ),
        ],
      ),
      Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Damage Rate'),
          SizedBox(
            width: 300,
            child: RangedNumberTextField(
              minValue: 1,
              defaultValue: damageRate,
              onChangeFunction: (value) {
                damageRate = value;
                setState(() {});
              },
            ),
          ),
        ],
      ),
    ];

    if (actionTarget == BattleRaptureActionTarget.targetedNikkes) {
      children.add(
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Target subtype:'),
            DropdownMenu<BattleRaptureActionTargetSubtype>(
              width: 300,
              textStyle: TextStyle(fontSize: 12),
              initialSelection: targetSubtype,
              onSelected: (BattleRaptureActionTargetSubtype? value) {
                targetSubtype = value!;
                setState(() {});
              },
              dropdownMenuEntries: actionTargetSubtypeEntries,
            ),
          ],
        ),
      );
      if (targetSubtype == BattleRaptureActionTargetSubtype.position) {
        children.add(
          Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SliderWithPrefix(
                titled: true,
                label: 'Position',
                min: 1,
                max: 5,
                value: position,
                onChange: (newValue) {
                  position = newValue.round();
                  if (mounted) setState(() {});
                },
                constraint: false,
              ),
            ],
          ),
        );
      } else {
        children.add(
          Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sort ${highToLow ? 'High to Low' : 'Low to High'}'),
              Switch(
                value: highToLow,
                onChanged: (v) {
                  highToLow = v;
                  setState(() {});
                },
              ),
              SliderWithPrefix(
                titled: true,
                label: 'Target count',
                min: 1,
                max: 5,
                value: targetCount,
                onChange: (newValue) {
                  targetCount = newValue.round();
                  if (mounted) setState(() {});
                },
                constraint: false,
              ),
            ],
          ),
        );
      }
    }

    return children;
  }

  static List<FunctionType> allowedBuffs = [
    FunctionType.damageReduction,
    FunctionType.statAccuracyCircle,
    FunctionType.statAmmo,
    FunctionType.statAtk,
    FunctionType.statChargeDamage,
    FunctionType.statChargeTime,
    FunctionType.statCritical,
    FunctionType.statCriticalDamage,
    FunctionType.statDef,
    FunctionType.statRateOfFire,
    FunctionType.statReloadTime,
  ];

  static final List<DropdownMenuEntry<FunctionType>> allowedBuffsEntries =
      UnmodifiableListView<DropdownMenuEntry<FunctionType>>(
        allowedBuffs.map<DropdownMenuEntry<FunctionType>>(
          (FunctionType type) => DropdownMenuEntry<FunctionType>(value: type, label: type.name),
        ),
      );

  static final List<DropdownMenuEntry<DurationType>> durationTypeEntries = UnmodifiableListView(
    [
      DurationType.timeSec,
      DurationType.battles,
    ].map((DurationType type) => DropdownMenuEntry(value: type, label: type.name)),
  );

  List<Widget> setBuffRows() {
    final List<Widget> children = [
      Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Buff Type'),
          DropdownMenu<FunctionType>(
            width: 300,
            textStyle: TextStyle(fontSize: 12),
            initialSelection: buffType,
            onSelected: (FunctionType? value) {
              buffType = value!;
              setState(() {});
            },
            dropdownMenuEntries: allowedBuffsEntries,
          ),
        ],
      ),
      Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Buff Value'),
          SizedBox(
            width: 300,
            child: TextField(
              decoration: InputDecoration(border: const OutlineInputBorder()),
              controller: buffValueController,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'-?\d*'))],
            ),
          ),
        ],
      ),
      Text('Input buff value as 100 * percentage. E.g. 3000 = 30%.'),
      Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Treat as buff: $isBuff'),
          Switch(
            value: isBuff,
            onChanged: (v) {
              isBuff = v;
              setState(() {});
            },
          ),
        ],
      ),
      if ([
        FunctionType.statChargeTime,
        FunctionType.statAccuracyCircle,
        FunctionType.statReloadTime,
      ].contains(buffType))
        Text('Use negative values for this buff for positive effects.'),
      Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Duration Type'),
          DropdownMenu<DurationType>(
            width: 300,
            textStyle: TextStyle(fontSize: 12),
            initialSelection: durationType,
            onSelected: (DurationType? value) {
              durationType = value!;
              setState(() {});
            },
            dropdownMenuEntries: durationTypeEntries,
          ),
        ],
      ),
      if (durationType == DurationType.timeSec)
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Duration: $duration frames, ${(duration / fps).toStringAsFixed(3)} seconds'),
            IconButton.filled(
              onPressed: () async {
                final newDuration = await showDialog<int?>(
                  barrierDismissible: false,
                  context: context,
                  builder: (ctx) {
                    return TimeframeSetupDialog(
                      maxFrame: maxFrame,
                      fps: fps,
                      defaultFrame: duration,
                      timestampMode: false,
                    );
                  },
                );
                if (newDuration != null) {
                  duration = newDuration;
                  setState(() {});
                }
              },
              icon: Icon(Icons.settings),
            ),
          ],
        ),
      Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Target:'),
          DropdownMenu<BattleRaptureActionTarget>(
            width: 300,
            textStyle: TextStyle(fontSize: 12),
            initialSelection: actionTarget,
            onSelected: (BattleRaptureActionTarget? value) {
              actionTarget = value!;
              setState(() {});
            },
            dropdownMenuEntries: actionTargetEntries,
          ),
        ],
      ),
    ];

    if (actionTarget == BattleRaptureActionTarget.targetedNikkes) {
      children.add(
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Target subtype:'),
            DropdownMenu<BattleRaptureActionTargetSubtype>(
              width: 300,
              textStyle: TextStyle(fontSize: 12),
              initialSelection: targetSubtype,
              onSelected: (BattleRaptureActionTargetSubtype? value) {
                targetSubtype = value!;
                setState(() {});
              },
              dropdownMenuEntries: actionTargetSubtypeEntries,
            ),
          ],
        ),
      );
      if (targetSubtype == BattleRaptureActionTargetSubtype.position) {
        children.add(
          Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SliderWithPrefix(
                titled: true,
                label: 'Position',
                min: 1,
                max: 5,
                value: position,
                onChange: (newValue) {
                  position = newValue.round();
                  if (mounted) setState(() {});
                },
                constraint: false,
              ),
            ],
          ),
        );
      } else {
        children.add(
          Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sort ${highToLow ? 'High to Low' : 'Low to High'}'),
              Switch(
                value: highToLow,
                onChanged: (v) {
                  highToLow = v;
                  setState(() {});
                },
              ),
              SliderWithPrefix(
                titled: true,
                label: 'Target count',
                min: 1,
                max: 5,
                value: targetCount,
                onChange: (newValue) {
                  targetCount = newValue.round();
                  if (mounted) setState(() {});
                },
                constraint: false,
              ),
            ],
          ),
        );
      }
    }

    return children;
  }

  List<Widget> clearBuffRows() {
    final List<Widget> children = [
      Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Clear ${isBuff ? 'Buffs' : 'Debuffs'}'),
          Switch(
            value: isBuff,
            onChanged: (v) {
              isBuff = v;
              setState(() {});
            },
          ),
        ],
      ),
      Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Target:'),
          DropdownMenu<BattleRaptureActionTarget>(
            width: 300,
            textStyle: TextStyle(fontSize: 12),
            initialSelection: actionTarget,
            onSelected: (BattleRaptureActionTarget? value) {
              actionTarget = value!;
              setState(() {});
            },
            dropdownMenuEntries: actionTargetEntries,
          ),
        ],
      ),
    ];

    if (actionTarget == BattleRaptureActionTarget.targetedNikkes) {
      children.add(
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Target subtype:'),
            DropdownMenu<BattleRaptureActionTargetSubtype>(
              width: 300,
              textStyle: TextStyle(fontSize: 12),
              initialSelection: targetSubtype,
              onSelected: (BattleRaptureActionTargetSubtype? value) {
                targetSubtype = value!;
                setState(() {});
              },
              dropdownMenuEntries: actionTargetSubtypeEntries,
            ),
          ],
        ),
      );
      if (targetSubtype == BattleRaptureActionTargetSubtype.position) {
        children.add(
          Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SliderWithPrefix(
                titled: true,
                label: 'Position',
                min: 1,
                max: 5,
                value: position,
                onChange: (newValue) {
                  position = newValue.round();
                  if (mounted) setState(() {});
                },
                constraint: false,
              ),
            ],
          ),
        );
      } else {
        children.add(
          Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sort ${highToLow ? 'High to Low' : 'Low to High'}'),
              Switch(
                value: highToLow,
                onChanged: (v) {
                  highToLow = v;
                  setState(() {});
                },
              ),
              SliderWithPrefix(
                titled: true,
                label: 'Target count',
                min: 1,
                max: 5,
                value: targetCount,
                onChange: (newValue) {
                  targetCount = newValue.round();
                  if (mounted) setState(() {});
                },
                constraint: false,
              ),
            ],
          ),
        );
      }
    }

    return children;
  }
}
