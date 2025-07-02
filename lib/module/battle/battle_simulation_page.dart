import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/user_data.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';
import 'package:nikke_einkk/module/nikkes/nikke_widgets.dart';

class BattleSimulationPage extends StatefulWidget {
  final List<NikkeOptions> nikkeOptions;
  final List<BattleRaptureOptions> raptureOptions;
  final PlayerOptions playerOptions;
  final bool useGlobal;
  final BattleSimulation simulation;

  BattleSimulationPage({
    super.key,
    required this.nikkeOptions,
    required this.raptureOptions,
    required this.playerOptions,
    required this.useGlobal,
  }) : simulation = BattleSimulation(
         playerOptions: playerOptions,
         nikkeOptions: nikkeOptions,
         raptureOptions: raptureOptions,
       );

  @override
  State<BattleSimulationPage> createState() => _BattleSimulationPageState();
}

class _BattleSimulationPageState extends State<BattleSimulationPage> {
  BattleSimulation get simulation => widget.simulation;

  @override
  void initState() {
    super.initState();

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children:
                simulation.nikkes.mapIndexed((idx, nikke) {
                  return Align(
                    child: NikkeIcon(
                      characterData: nikke.data,
                      weapon: nikke.weaponData,
                      defaultText: 'None',
                      isSelected: simulation.currentNikke == idx + 1,
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
