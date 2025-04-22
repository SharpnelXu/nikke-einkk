import 'package:flutter/widgets.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';

class BattleSimulationPage extends StatefulWidget {
  final BattlePlayerOptions playerOptions;

  const BattleSimulationPage({super.key, required this.playerOptions});

  @override
  State<BattleSimulationPage> createState() => _BattleSimulationPageState();
}

class _BattleSimulationPageState extends State<BattleSimulationPage> {
  late final BattleSimulationData simulationData = BattleSimulationData(
    playerOptions: widget.playerOptions,
    nikkeOptions: [],
  );

  _BattleSimulationPageState();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
