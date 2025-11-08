import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';
import 'package:nikke_einkk/model/rollsim/position_first_strategy.dart';
import 'package:nikke_einkk/model/rollsim/strategy.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';
import 'package:nikke_einkk/module/common/slider.dart';

class RollSimulatorPage extends StatefulWidget {
  const RollSimulatorPage({super.key});

  @override
  State<RollSimulatorPage> createState() => _RollSimulatorPageState();
}

class _RollSimulatorPageState extends State<RollSimulatorPage> {
  bool get useGlobal => userDb.useGlobal;
  NikkeDatabase get db => userDb.gameDb;

  int rollCount = 10000;
  List<EquipLine> initialState = [
    EquipLine(EquipLineType.statDef, 11),
    EquipLine(EquipLineType.none, 1),
    EquipLine(EquipLineType.none, 1),
  ];

  List<EquipLineExpectation> targets = [];
  RollStrategyResult? result;

  String? initialStateError;
  String? targetError;

  void setInitialState() {
    final nonNoneTypes = initialState.where((line) => line.type != EquipLineType.none).toList();
    final typeSet = nonNoneTypes.map((e) => e.type).toSet();
    if (typeSet.length != nonNoneTypes.length) {
      initialStateError = 'Duplicate equip line types are not allowed.';
    } else {
      initialStateError = null;
    }
    setState(() {});
  }

  void setTargetState() {
    final uniqueTypes = targets.map((e) => e.type).toSet();
    if (uniqueTypes.length != targets.length) {
      targetError = 'Duplicate target types are not allowed.';
    } else {
      targetError = null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    children.add(
      Container(
        constraints: BoxConstraints(maxWidth: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Text('Current State', style: TextStyle(fontSize: 20)),
            if (initialStateError != null) Text(initialStateError!, style: TextStyle(color: Colors.red)),
            ...List.generate(initialState.length, (index) {
              final equipLine = initialState[index];
              final level = initialState[index].level;
              final lineRare =
                  level > 10
                      ? Colors.orange
                      : level > 5
                      ? Colors.purple
                      : Colors.blue;
              final levelTextColor = level >= 12 ? Colors.blue : null;
              return Container(
                padding: const EdgeInsets.all(8.0),
                constraints: BoxConstraints(maxWidth: 700),
                decoration: BoxDecoration(
                  border: Border.all(color: lineRare, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 5,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Equip Line Type: '),
                        DropdownMenu<EquipLineType>(
                          textStyle: TextStyle(fontSize: 14),
                          initialSelection: equipLine.type,
                          onSelected: (EquipLineType? value) {
                            if (value == EquipLineType.none) {
                              equipLine.level = 1;
                            } else if (equipLine.type == EquipLineType.none) {
                              equipLine.level = 11;
                            }
                            equipLine.type = value!;
                            setInitialState();
                          },
                          dropdownMenuEntries:
                              EquipLineType.values
                                  .map((type) => DropdownMenuEntry(value: type, label: type.toString()))
                                  .toList(),
                        ),
                      ],
                    ),
                    if (equipLine.type != EquipLineType.none)
                      SliderWithPrefix(
                        constraint: false,
                        titled: false,
                        leadingWidth: 80.0,
                        label: 'Lv$level',
                        valueFormatter: (level) => equipLine.getValue(db).percentString,
                        min: 1,
                        max: 15,
                        value: level,
                        preferColor: lineRare,
                        preferLabelColor: levelTextColor,
                        onChange: (newValue) {
                          equipLine.level = newValue.round();
                          if (mounted) setInitialState();
                        },
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );

    children.add(
      Container(
        constraints: BoxConstraints(maxWidth: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Text('Targets - Ordered by priority', style: TextStyle(fontSize: 20)),
            Text('Lock on Lv14 means whenever a lv14 line of that type is rolled, immediately lock it'),
            Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: () {
                    targets.add(EquipLineExpectation(type: EquipLineType.statAtk, lineCount: 1));
                    setTargetState();
                  },
                  label: Text('Add Target'),
                  icon: Icon(Icons.add),
                ),
                FilledButton.icon(
                  onPressed: () {
                    targets.clear();
                    setTargetState();
                  },
                  label: Text('Clear All'),
                  icon: Icon(Icons.remove_circle),
                ),
              ],
            ),
            if (targetError != null) Text(targetError!, style: TextStyle(color: Colors.red)),
            ...List.generate(targets.length, (index) {
              final expectation = targets[index];
              final minValue = expectation.minValue ?? 0;
              final minValueLv = minValue != 0 ? EquipLine.onValue(expectation.type, minValue, db).level : 0;
              final lockThreshold = expectation.lockThreshold ?? 0;
              Color lineRare(int level) =>
                  level > 10
                      ? Colors.orange
                      : level > 5
                      ? Colors.purple
                      : Colors.blue;
              Color? levelTextColor(int level) => level >= 12 ? Colors.blue : null;
              return Container(
                padding: const EdgeInsets.all(8.0),
                constraints: BoxConstraints(maxWidth: 700),
                decoration: BoxDecoration(
                  border: Border.all(color: expectation.lineCount == 1 ? Colors.green : Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      spacing: 5,
                      children: [
                        Text('Target ${index + 1}:'),
                        DropdownMenu<EquipLineType>(
                          textStyle: TextStyle(fontSize: 14),
                          initialSelection: expectation.type,
                          onSelected: (EquipLineType? value) {
                            final curMinValueLv =
                                expectation.minValue != null
                                    ? EquipLine.onValue(expectation.type, expectation.minValue!, db).level
                                    : null;
                            expectation.type = value!;
                            expectation.minValue =
                                curMinValueLv != null ? EquipLine(value, curMinValueLv).getValue(db) : null;
                            setTargetState();
                          },
                          dropdownMenuEntries:
                              EquipLineType.values
                                  .where((type) => type != EquipLineType.none)
                                  .map((type) => DropdownMenuEntry(value: type, label: type.toString()))
                                  .toList(),
                        ),
                        Text(expectation.lineCount == 0 ? 'Will Exclude' : 'Will Include'),
                        Checkbox(
                          value: expectation.lineCount == 0,
                          onChanged: (v) {
                            expectation.lineCount = v ?? false ? 0 : 1;
                            setTargetState();
                          },
                        ),
                        IconButton(
                          onPressed:
                              index == 0
                                  ? null
                                  : () {
                                    if (index > 0) {
                                      final temp = targets[index - 1];
                                      targets[index - 1] = expectation;
                                      targets[index] = temp;
                                      setTargetState();
                                    }
                                  },
                          icon: Icon(Icons.arrow_upward),
                        ),
                        IconButton(
                          onPressed:
                              index == targets.length - 1
                                  ? null
                                  : () {
                                    if (index < targets.length - 1) {
                                      final temp = targets[index + 1];
                                      targets[index + 1] = expectation;
                                      targets[index] = temp;
                                      setTargetState();
                                    }
                                  },
                          icon: Icon(Icons.arrow_downward),
                        ),
                        IconButton(
                          onPressed: () {
                            targets.remove(expectation);
                            setTargetState();
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                    if (expectation.lineCount == 1)
                      SliderWithPrefix(
                        constraint: false,
                        titled: false,
                        leadingWidth: 80.0,
                        label: minValueLv == 0 ? 'No min lv' : 'Min Lv$minValueLv',
                        valueFormatter: (level) {
                          final round = level.round();
                          return round == 0 ? '' : EquipLine(expectation.type, round).getValue(db).percentString;
                        },
                        min: 0,
                        max: 15,
                        value: minValueLv,
                        preferColor: lineRare(minValueLv),
                        preferLabelColor: levelTextColor(minValueLv),
                        onChange: (newValue) {
                          final roundValue = newValue.round();
                          if (roundValue == 0) {
                            expectation.minValue = null;
                          } else {
                            expectation.minValue = EquipLine(expectation.type, roundValue).getValue(db);
                            if (expectation.lockThreshold != null) {
                              expectation.lockThreshold = max(expectation.lockThreshold!, roundValue);
                            }
                          }
                          if (mounted) setTargetState();
                        },
                      ),
                    if (expectation.lineCount == 1)
                      SliderWithPrefix(
                        constraint: false,
                        titled: false,
                        leadingWidth: 80.0,
                        label: lockThreshold == 0 ? 'No lock' : 'Lock on Lv$lockThreshold',
                        valueFormatter: (level) {
                          final round = level.round();
                          return round == 0 ? '' : EquipLine(expectation.type, round).getValue(db).percentString;
                        },
                        min: 0,
                        max: 15,
                        value: lockThreshold,
                        preferColor: lineRare(lockThreshold),
                        preferLabelColor: levelTextColor(lockThreshold),
                        onChange: (newValue) {
                          final roundValue = newValue.round();
                          if (roundValue == 0) {
                            expectation.lockThreshold = null;
                          } else if (minValueLv > 0) {
                            expectation.lockThreshold = max(minValueLv, roundValue);
                          } else {
                            expectation.lockThreshold = roundValue;
                          }
                          if (mounted) setTargetState();
                        },
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );

    final rollResult = result;
    children.add(
      Container(
        constraints: BoxConstraints(maxWidth: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            if (rollResult != null) ...[
              Text('Results after ${rollResult.testNum} tests:', style: TextStyle(fontSize: 20)),
              Text('Avg: ${rollResult.avgRocksUsed} rocks in ${rollResult.avgRollsUsed} rolls'),
              Text('Min: ${rollResult.minRocksUsed} rocks in ${rollResult.minRollsUsed} rolls'),
              Text('Max: ${rollResult.maxRocksUsed} rocks in ${rollResult.maxRollsUsed} rolls'),
              Text('Avg Equip Line Values:', style: TextStyle(fontSize: 20)),
              ...rollResult.equipLineValues.keys.map((type) {
                return Text('$type : ${(rollResult.equipLineValues[type]! / rollResult.testNum).percentString}');
              }),
            ],
            FilledButton.icon(
              onPressed:
                  initialStateError != null || targetError != null
                      ? null
                      : () {
                        final strategy = SingleEquipPositionFirstStrategy.instance;
                        result = strategy.run(rollCount, db, initialState, targets);
                        setState(() {});
                      },
              label: Text('Roll $rollCount!'),
              icon: Icon(Icons.casino),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Roll Simulator')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemBuilder: (ctx, idx) => children[idx],
          separatorBuilder: (ctx, idx) => SizedBox(height: 10),
          itemCount: children.length,
        ),
      ),
      bottomNavigationBar: commonBottomNavigationBar(() => setState(() {})),
    );
  }
}
