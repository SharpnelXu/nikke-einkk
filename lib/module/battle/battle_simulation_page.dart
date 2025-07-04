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
      bottomNavigationBar: commonBottomNavigationBar(() => setState(() {})),
      body: ListView(
        children: [
          Align(child: Text('Nikkes', style: TextStyle(fontSize: 20))),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: simulation.battleNikkes.mapIndexed(_buildNikke).toList(),
          ),
        ],
      ),
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

    if (nikke != null) {
      final currentCoverHp = nikke.cover.currentHp;
      final maxCoverHp = nikke.cover.getMaxHp(simulation);

      final currentHp = nikke.currentHp;
      final maxHp = nikke.getMaxHp(simulation);
      children.addAll([
        Text('${nikke.currentAmmo} / ${nikke.getMaxAmmo(simulation)}'),
        const Divider(height: 2),
        Text('Cover: ${(currentCoverHp / maxCoverHp * 100).round()}%'),
        Text(currentCoverHp.decimalPattern),
        const Divider(height: 2),
        Text('HP: ${(currentHp / maxHp * 100).round()}%'),
        Text(currentHp.decimalPattern),
        const Divider(height: 2),
        Text('ATK: ${(nikke.getAttackBuffValues(simulation) + nikke.baseAttack).decimalPattern}'),
        Text('DEF: ${(nikke.getDefenceBuffValues(simulation) + nikke.baseDefence).decimalPattern}'),
      ]);
    }

    return Expanded(child: Column(spacing: 5, children: children));
  }
}
