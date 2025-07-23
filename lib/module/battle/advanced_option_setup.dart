import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/user_data.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';

class AdvancedOptionPage extends StatefulWidget {
  final List<NikkeOptions> nikkes;
  final bool useGlobal;
  final BattleAdvancedOption option;

  const AdvancedOptionPage({super.key, required this.option, required this.nikkes, required this.useGlobal});

  @override
  State<AdvancedOptionPage> createState() => _AdvancedOptionPageState();
}

class _AdvancedOptionPageState extends State<AdvancedOptionPage> {
  BattleAdvancedOption get option => widget.option;
  List<NikkeOptions> get nikkes => widget.nikkes;
  NikkeDatabase get db => widget.useGlobal ? global : cn;

  static final divider = const Divider();
  static final titleStyle = const TextStyle(fontSize: 20);

  @override
  Widget build(BuildContext context) {
    final secondary = TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 14);
    final List<Widget> children = [
      Text('Advanced Setups', style: titleStyle),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 15,
        children: [
          Text('Automatically Fill Burst'),
          Switch(
            value: option.forceFillBurst,
            onChanged: (v) {
              option.forceFillBurst = v;
              if (mounted) setState(() {});
            },
          ),
        ],
      ),
      divider,
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 5,
        children: [
          Text('Custom Burst Order', style: titleStyle),
          FilledButton.icon(
            onPressed: () {
              setState(() {
                option.burstOrders.clear();
              });
            },
            label: Text('Reset'),
            icon: Icon(Icons.delete_forever),
          ),
        ],
      ),
      Text(
        'If timed, then burst cycle will only start until the specified time, but will not shorten CD',
        style: secondary,
      ),
      Text('Also note that here this will not check if the burst cycle is valid', style: secondary),
    ];
    final burstOrderKeys = option.burstOrders.keys.sorted((a, b) => a.compareTo(b));
    children.addAll(burstOrderKeys.map((key) => _customBurstOrderList(key, option.burstOrders[key]!)));
    children.add(
      FilledButton.icon(
        onPressed: () {
          final lastKey = burstOrderKeys.lastOrNull;
          if (lastKey == null) {
            option.burstOrders[1] = BattleBurstSpecification();
          } else {
            option.burstOrders[lastKey + 1] = option.burstOrders[lastKey]!.copy();
          }
          setState(() {});
        },
        label: Text(burstOrderKeys.isEmpty ? 'Create New' : 'Copy Last'),
        icon: Icon(burstOrderKeys.isEmpty ? Icons.add_circle : Icons.copy),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Advanced Options')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemBuilder: (ctx, idx) => Align(child: Padding(padding: const EdgeInsets.all(2.0), child: children[idx])),
          itemCount: children.length,
        ),
      ),
      bottomNavigationBar: commonBottomNavigationBar(() => setState(() {})),
    );
  }

  Widget _customBurstOrderList(int order, BattleBurstSpecification specification) {
    final List<Widget> children = [
      IconButton(
        onPressed: () {
          option.burstOrders.remove(order);
          setState(() {});
        },
        icon: Icon(Icons.remove_circle, color: Colors.red),
      ),
      Text('Burst Cycle $order'),
      Text('Timed:'),
      Checkbox(
        value: specification.frame != null,
        onChanged: (v) {
          if (v == false) {
            specification.frame = null;
          } else if (v == true) {
            specification.frame = option.maxSeconds * option.fps;
          }
          setState(() {});
        },
      ),
      if (specification.frame != null)
        FilledButton(
          onPressed: () async {
            int? frame;
            await showDialog(
              context: context,
              useRootNavigator: false,
              builder: (ctx) {
                final max = option.maxSeconds * option.fps;
                return InputCancelOkDialog.number(
                  title: 'Select Time Frames',
                  initValue: specification.frame!,
                  helperText: '1~$max',
                  keyboardType: const TextInputType.numberWithOptions(signed: true),
                  validate: (v) => v >= 1 && v <= max,
                  onSubmit: (v) {
                    if (v >= 1 && v <= max) {
                      frame = v;
                    }
                  },
                  valueFormatter: (v) {
                    final frame = int.tryParse(v);
                    return frame == null ? 'Not valid frame' : frameDataToNiceTimeString(frame, option.fps);
                  },
                );
              },
            );

            if (frame != null) {
              specification.frame = frame!;
              setState(() {});
            }
          },
          child: Text(frameDataToNiceTimeString(specification.frame!, option.fps)),
        ),
    ];

    final List<DropdownMenuEntry<int>> nikkeDropdowns = [];
    for (final (idx, nikke) in nikkes.indexed) {
      final nameKey = db.characterResourceGardeTable[nikke.nikkeResourceId]?.values.first.nameLocalkey;
      nikkeDropdowns.add(
        DropdownMenuEntry(value: idx + 1, label: '${locale.getTranslation(nameKey) ?? 'Empty'} P${idx + 1}'),
      );
    }

    for (final (idx, position) in specification.order.indexed) {
      children.addAll([
        Text('${idx + 1}'),
        DropdownMenu(
          initialSelection: position,
          onSelected: (v) {
            specification.order[idx] = v!;
            setState(() {});
          },
          dropdownMenuEntries: nikkeDropdowns,
        ),
      ]);
    }
    children.add(
      IconButton(
        onPressed: () {
          specification.order.add(1);
          setState(() {});
        },
        icon: Icon(Icons.add_circle, color: Colors.green),
      ),
    );

    return Wrap(
      spacing: 10,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }
}
