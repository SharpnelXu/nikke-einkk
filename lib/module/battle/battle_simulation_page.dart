import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/user_data.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';
import 'package:nikke_einkk/module/nikkes/nikke_widgets.dart';

class BattleSimulationPage extends StatefulWidget {
  final List<NikkeOptions> nikkeOptions;
  final List<BattleRaptureOptions> raptureOptions;
  final PlayerOptions playerOptions;
  final bool useGlobal;

  const BattleSimulationPage({
    super.key,
    required this.nikkeOptions,
    required this.raptureOptions,
    required this.playerOptions,
    required this.useGlobal,
  });

  @override
  State<BattleSimulationPage> createState() => _BattleSimulationPageState();
}

class _BattleSimulationPageState extends State<BattleSimulationPage> {
  late BattleSimulation simulation;

  @override
  void initState() {
    super.initState();
    simulation = BattleSimulation(
      playerOptions: widget.playerOptions,
      nikkeOptions: widget.nikkeOptions,
      raptureOptions: widget.raptureOptions,
    );
    simulation.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Battle Simulation')),
      bottomNavigationBar: commonBottomNavigationBar(
        () => setState(() {}),
        actions: [
          IconButton.filled(
            onPressed:
                simulation.currentFrame <= 0
                    ? null
                    : () {
                      simulation.proceedOneFrame();
                      setState(() {});
                    },
            icon: Icon(Icons.play_arrow),
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildMiscColumn(),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: simulation.battleNikkes.mapIndexed(_buildNikke).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMiscColumn() {
    return Column(
      spacing: 3,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Time: ${frameDataToNiceTimeString(simulation.currentFrame, simulation.fps)}s'
          ' (Frame ${simulation.currentFrame})',
        ),
        Text('Burst: ${(simulation.burstMeter / 100).percentString}'),
        SimplePercentBar(percent: simulation.burstMeter / BattleSimulation.burstMeterCap),
      ],
    );
  }

  Widget _buildNikke(int idx, BattleNikke? nikke) {
    final List<Widget> children = [
      NikkeIcon(
        characterData: nikke?.characterData,
        weapon: nikke?.currentWeaponData,
        defaultText: 'None',
        isSelected: simulation.currentNikke == idx + 1,
      ),
    ];

    final divider = const Divider(height: 2, indent: 10, endIndent: 10);
    if (nikke != null) {
      final currentCoverHp = nikke.cover.currentHp;
      final maxCoverHp = nikke.cover.getMaxHp(simulation);

      final currentHp = nikke.currentHp;
      final maxHp = nikke.getMaxHp(simulation);
      children.addAll([
        Text('${nikke.currentAmmo} / ${nikke.getMaxAmmo(simulation)}'),
        divider,
        SimplePercentBar(percent: currentCoverHp / maxCoverHp, color: Colors.blue[200]),
        Text(currentCoverHp.decimalPattern),
        SimplePercentBar(percent: currentHp / maxHp, color: Colors.white),
        Text(currentHp.decimalPattern),
        divider,
        Text('ATK: ${(nikke.getAttackBuffValues(simulation) + nikke.baseAttack).decimalPattern}'),
        Text('DEF: ${(nikke.getDefenceBuffValues(simulation) + nikke.baseDefence).decimalPattern}'),
      ]);
    }

    return Expanded(child: Column(spacing: 5, children: children));
  }
}

class SimplePercentBar extends StatelessWidget {
  final double size;
  final double percent;
  final Color? color;

  const SimplePercentBar({super.key, this.size = avatarSize, required this.percent, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2), color: Colors.grey),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(height: 12, width: size * percent, decoration: BoxDecoration(color: color)),
      ),
    );
  }
}
