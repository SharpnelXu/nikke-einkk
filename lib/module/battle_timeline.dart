import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/utils.dart';

class BattleTimeline extends StatefulWidget {
  final BattleSimulationData simulation;

  const BattleTimeline({super.key, required this.simulation});

  @override
  State<BattleTimeline> createState() => _BattleTimelineState();
}

class _BattleTimelineState extends State<BattleTimeline> {
  BattleSimulationData get simulation => widget.simulation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timeline')),
      body: Column(
        children: [
          Expanded(child: buildTimeline()),
          const SizedBox(height: 4),
          Material(
            elevation: 8,
            color: Theme.of(context).cardColor,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: FilledButton(
                  onPressed: () {
                    simulation.simulate();
                    if (mounted) setState(() {});
                  },
                  child: const Text('Simulate'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTimeline() {
    final frames = simulation.timeline.keys.toList();
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final frame = frames[index];
            final timeData = BattleUtils.frameToTimeData(frame, simulation.fps);
            final events = simulation.timeline[frames[index]]!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${timeData ~/ 6000}:${(timeData % 6000 / 100).toStringAsFixed(2)} (Frame: $frame) ==>'),
                    ...events.map(
                      (event) => Padding(padding: const EdgeInsets.only(left: 8.0), child: event.buildDisplay()),
                    ),
                  ],
                ),
              ),
            );
          }, childCount: frames.length),
        ),
      ],
    );
  }
}
