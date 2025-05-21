import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/battle_event.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/utils.dart';

class BattleTimeline extends StatefulWidget {
  final BattleSimulation simulation;

  const BattleTimeline({super.key, required this.simulation});

  @override
  State<BattleTimeline> createState() => _BattleTimelineState();
}

class _BattleTimelineState extends State<BattleTimeline> {
  BattleSimulation get simulation => widget.simulation;

  @override
  Widget build(BuildContext context) {
    final damageMap = simulation.getDamageMap();
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
                child: Row(
                  spacing: 5,
                  children: [
                    ...damageMap.keys.map((pos) {
                      final nikke = simulation.nikkes.firstWhere((nikke) => nikke.uniqueId == pos);
                      return Text('${nikke.name} (Pos $pos) Total bullets: ${nikke.totalBulletsFired}');
                    }),
                    FilledButton(
                      onPressed: () {
                        simulation.simulate();
                        if (mounted) setState(() {});
                      },
                      child: const Text('Simulate'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTimeline() {
    final Map<int, List<Widget>> filteredTimeline = SplayTreeMap((a, b) => b.compareTo(a));
    for (final frame in simulation.timeline.keys) {
      final frameEvents = buildFrameEvents(simulation.timeline[frame]!);

      if (frameEvents.isNotEmpty) {
        filteredTimeline[frame] = frameEvents;
      }
    }

    final frames = filteredTimeline.keys.toList();
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final frame = frames[index];
            final timeData = BattleUtils.frameToTimeData(frame, simulation.fps);

            final seconds = timeData % 6000 / 100;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${timeData ~/ 6000}:'
                      '${seconds < 10 ? '0' : ''}'
                      '${(timeData % 6000 / 100).toStringAsFixed(2)}'
                      ' (Frame: $frame) ==>',
                    ),
                    Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: filteredTimeline[frame]!,
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

  List<Widget> buildFrameEvents(List<BattleEvent> events) {
    final List<Widget> result = [];
    final allowList = [ChangeBurstStepEvent, BuffEvent, ExitFullBurstEvent, UseSkillEvent, NikkeDamageEvent];
    for (final event in events) {
      if (!allowList.contains(event.runtimeType)) continue;

      if (event is NikkeDamageEvent && [2, 1].contains(event.attackerUniqueId)) continue;

      result.add(event.buildDisplay());
    }
    return result;
  }
}
