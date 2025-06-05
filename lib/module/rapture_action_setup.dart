import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';
import 'package:nikke_einkk/module/common/simple_dialog.dart';

class RaptureActionSetupDialog extends StatefulWidget {
  final int maxFrame;
  final int fps;

  const RaptureActionSetupDialog({super.key, required this.maxFrame, required this.fps});

  @override
  State<RaptureActionSetupDialog> createState() => _RaptureActionSetupDialogState();
}

class _RaptureActionSetupDialogState extends State<RaptureActionSetupDialog> {
  int get maxFrame => widget.maxFrame;
  String get maxSeconds => (maxFrame / fps).toStringAsFixed(3);
  int get fps => widget.fps;

  bool useFrame = true;
  int frame = 0;
  int setParam = 0;
  bool boolParam = false;
  int duration = 0;
  DurationType durationType = DurationType.timeSec;
  int barrierHp = 1;
  NikkeElement codeBarrierElement = NikkeElement.electric;
  BattleRaptureActionType actionType = BattleRaptureActionType.setAtk;

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

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [
      TextButton(
        child: Text('Cancel'),
        onPressed: () {
          Navigator.of(context).pop(null);
        },
      ),
      TextButton(
        child: Text('Confirm'),
        onPressed: () {
          Navigator.of(context).pop(null);
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
}
