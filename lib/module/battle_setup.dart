import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/module/nikke_list.dart';

class BattleSetupPage extends StatefulWidget {
  const BattleSetupPage({super.key});

  @override
  State<BattleSetupPage> createState() => _BattleSetupPageState();
}

class _BattleSetupPageState extends State<BattleSetupPage> {
  final RaptureDisplay raptureDisplay = RaptureDisplay();
  final List<NikkeDisplay> nikkeDisplays = List.generate(5, (_) => NikkeDisplay());

  // List of colors for the containers (optional)
  final List<Color> containerColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Battle Simulation')),
      body: SingleChildScrollView(
        // Vertical scrolling
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: raptureDisplay),
                  ...List.generate(5, (index) {
                    return Expanded(child: nikkeDisplays[index]);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RaptureDisplay extends StatefulWidget {
  final BattleRaptureOptions options = BattleRaptureOptions();

  RaptureDisplay({super.key});

  @override
  State<RaptureDisplay> createState() => _RaptureDisplayState();
}

class _RaptureDisplayState extends State<RaptureDisplay> {
  static const avatarSize = 100.0;

  BattleRaptureOptions get options => widget.options;

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
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(4)),
            child: Center(child: Text('${options.name}.png')),
          ),
          Text(options.name, maxLines: 1),
          Text('HP: ${format.format(options.startHp)}'),
          Text('ATK: ${format.format(options.startAttack)}'),
          Text('DEF: ${format.format(options.startDefence)}'),
          Text('Distance: ${format.format(options.startDistance)}'),
        ],
      ),
    );
  }
}

class NikkeDisplay extends StatefulWidget {
  final BattleNikkeOptions options = BattleNikkeOptions(nikkeResourceId: -1);

  NikkeDisplay({super.key});

  @override
  State<NikkeDisplay> createState() => _NikkeDisplayState();
}

class _NikkeDisplayState extends State<NikkeDisplay> {
  static const avatarSize = 100.0;

  BattleNikkeOptions get options => widget.options;

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
          InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NikkeSelectorPage(option: options)),
              );
              if (mounted) setState(() {});
            },
            child: Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(child: Text('${options.nikkeResourceId}.png')),
            ),
          ),
          Text(options.nikkeResourceId.toString(), maxLines: 1),
          if (options.nikkeResourceId != -1) Text('Sync: ${format.format(options.syncLevel)}'),
        ],
      ),
    );
  }
}
