import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/events/nikke_damage_event.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
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
                      for (int i = 0; i < 60; i += 1) {
                        simulation.proceedOneFrame();
                      }
                      setState(() {});
                    },
            icon: Icon(Icons.fast_forward),
          ),
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
          const Divider(),
          _buildDpsChart(),
          const Divider(),
          _buildLastFrameEvents(),
        ],
      ),
    );
  }

  static List<Color> dpsColorChart = [Colors.red, Colors.blue, Colors.green, Colors.deepPurple, Colors.orange];

  Widget _buildDpsChart() {
    final Map<int, List<int>> dpsMap = {};
    for (final nikke in simulation.nonnullNikkes) {
      dpsMap[nikke.uniqueId] = [];
    }
    final secondsToCheck = ((simulation.maxFrames - simulation.currentFrame + 1) / simulation.fps).ceil();
    for (int sec = 0; sec < secondsToCheck; sec += 1) {
      final framesToCheckStart = simulation.maxFrames - sec * simulation.fps;
      final framesToCheckEnd = framesToCheckStart - simulation.fps;
      for (final damageList in dpsMap.values) {
        damageList.add(0);
      }
      for (int frame = framesToCheckStart; frame > framesToCheckEnd; frame -= 1) {
        final events = simulation.timeline[frame];
        if (events != null) {
          for (final event in events) {
            if (event is NikkeDamageEvent) {
              final nikkeDamageList = dpsMap[event.activatorId]!;
              final sum = nikkeDamageList[nikkeDamageList.length - 1];
              nikkeDamageList[nikkeDamageList.length - 1] = sum + event.damageParameter.calculateExpectedDamage();
            }
          }
        }
      }
    }
    return Container(
      padding: EdgeInsets.only(right: 15),
      constraints: BoxConstraints(maxWidth: 700, maxHeight: 400),
      child: Center(
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              show: true,
              topTitles: AxisTitles(axisNameWidget: Text('DPS', style: TextStyle(fontSize: 18)), axisNameSize: 30),
              leftTitles: AxisTitles(axisNameSize: 0, sideTitles: SideTitles(showTitles: true, reservedSize: 70)),
              rightTitles: AxisTitles(),
              bottomTitles: AxisTitles(
                axisNameSize: 50,
                axisNameWidget: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 5,
                  children: [
                    Text('Seconds since battle start'),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      children: List.generate(simulation.nonnullNikkes.length, (idx) {
                        final nikke = simulation.nonnullNikkes[idx];
                        final color = dpsColorChart[idx];
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 5,
                          children: [
                            Container(alignment: Alignment.center, width: 10, height: 10, color: color),
                            Text('${locale.getTranslation(nikke.characterData.nameLocalkey)} (P${nikke.uniqueId})'),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
                sideTitles: SideTitles(showTitles: true, reservedSize: 30),
              ),
            ),
            lineBarsData: List.generate(simulation.nonnullNikkes.length, (idx) {
              final nikke = simulation.nonnullNikkes[idx];
              final dpsList = dpsMap[nikke.uniqueId]!;
              return LineChartBarData(
                color: dpsColorChart[idx],
                spots: List.generate(dpsList.length, (idx) {
                  return FlSpot(idx.toDouble(), dpsList[idx].toDouble());
                }),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildLastFrameEvents() {
    final isBattleStartFrame = simulation.currentFrame == simulation.maxFrames;
    final List<Widget> result = [
      Text(
        isBattleStartFrame ? 'Events of Battle Start' : 'Events of Last Frame (${simulation.currentFrame + 1})',
        style: TextStyle(fontSize: 18),
      ),
    ];

    final events = simulation.timeline[simulation.currentFrame + 1];
    if (events == null || events.isEmpty) {
      result.add(Text('None'));
    } else {
      result.addAll(
        List.generate(
          events.length,
          (idx) => Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Wrap(
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 5,
              children: [
                Text('${idx + 1}.'),
                Container(constraints: BoxConstraints(maxWidth: 700), child: events[idx].buildDisplayV2(simulation)),
              ],
            ),
          ),
        ),
      );
    }
    return Column(mainAxisSize: MainAxisSize.min, spacing: 5, children: result);
  }

  Widget _buildMiscColumn() {
    final List<Widget> children = [
      Text(
        'Time: ${frameDataToNiceTimeString(simulation.currentFrame, simulation.fps)}s'
        ' (Frame ${simulation.currentFrame})',
      ),
    ];
    if (simulation.burstStage == 0) {
      children.addAll([
        Text('Burst: ${(simulation.burstMeter / 100).percentString}'),
        SimplePercentBar(percent: simulation.burstMeter / constData.burstMeterCap),
      ]);
    } else if (simulation.burstStage == 4) {
      children.addAll([
        Text('Full Burst: ${frameDataToNiceTimeString(simulation.burstStageFramesLeft, simulation.fps)}s'),
        SimplePercentBar(percent: simulation.burstStageFramesLeft / simulation.fullBurstDuration),
      ]);
    } else {
      children.add(Text('Burst Step: ${simulation.burstStage}'));
      if (simulation.reEnterBurstCd > 0) {
        children.addAll([
          Text('Re Enter CD: ${frameDataToNiceTimeString(simulation.reEnterBurstCd, simulation.fps)}s'),
          SimplePercentBar(
            percent: simulation.reEnterBurstCd / timeDataToFrame(constData.sameBurstStageCd, simulation.fps),
          ),
        ]);
      }
    }
    return Column(
      spacing: 3,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  static final divider = const Divider(height: 2, indent: 30, endIndent: 30);
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
        ...buildNikkeStatus(nikke),
        divider,
        SimplePercentBar(percent: nikke.currentAmmo / nikke.getMaxAmmo(simulation)),
        Text('${nikke.currentAmmo} / ${nikke.getMaxAmmo(simulation)}'),
        divider,
        SimplePercentBar(percent: currentCoverHp / maxCoverHp, color: Colors.blue[200]),
        Text(currentCoverHp.decimalPattern),
        SimplePercentBar(percent: currentHp / maxHp, color: Colors.white),
        Text(currentHp.decimalPattern),
        divider,
        Text('ATK: ${nikke.getFinalAttack(simulation).decimalPattern}'),
        Text('DEF: ${(nikke.getDefenceBuffValues(simulation) + nikke.baseDefence).decimalPattern}'),
      ]);
    }

    return Expanded(child: Column(spacing: 5, children: children));
  }

  List<Widget> buildNikkeStatus(BattleNikke nikke) {
    final status = nikke.status;
    int? cur, max;
    final List<Widget> list = [Text('Status:')];

    void addProgressBar(String statusText, int cur, int max) {
      list.addAll([Text(statusText), SimplePercentBar(percent: cur / max), Text('$cur / $max')]);
    }

    if (status == BattleNikkeStatus.shooting) {
      if (nikke.spotFirstDelayFrameCount >= 0 && nikke.spotLastDelayFrameCount <= 0) {
        max = timeDataToFrame(nikke.currentWeaponData.spotFirstDelay, nikke.fps);
        cur = max - nikke.spotFirstDelayFrameCount;
        addProgressBar('Exiting Cover', cur, max);
      }

      if (WeaponType.chargeWeaponTypes.contains(nikke.currentWeaponType)) {
        if (nikke.maintainFireStanceFrameCount > 0) {
          max = timeDataToFrame(
            nikke.currentWeaponData.spotFirstDelay + nikke.currentWeaponData.maintainFireStance,
            nikke.fps,
          );
          cur = nikke.maintainFireStanceFrameCount;
          addProgressBar('Forced Delay', cur, max);
        } else if (nikke.chargeFrames > 0) {
          max = nikke.previousFullChargeFrameCount;
          cur = nikke.chargeFrames;
          addProgressBar('Charging', cur, max);
        } else if (nikke.spotLastDelayFrameCount > 0) {
          max = timeDataToFrame(nikke.currentWeaponData.spotLastDelay, nikke.fps);
          cur = max - nikke.spotLastDelayFrameCount;
          addProgressBar('Entering Cover', cur, max);
        }
      } else if (nikke.shootCountdown > 0 && nikke.currentAmmo > 0) {
        max = nikke.shootThreshold;
        cur = max - nikke.shootCountdown;
        addProgressBar('Next Bullet', cur, max);
      }

      if (nikke.currentAmmo == 0) {
        list.add(Text('Start Reloading'));
      }
    } else if (status == BattleNikkeStatus.behindCover) {
      if (nikke.spotLastDelayFrameCount > 0) {
        max = timeDataToFrame(nikke.currentWeaponData.spotLastDelay, nikke.fps);
        cur = max - nikke.spotLastDelayFrameCount;
        addProgressBar('Entering Cover', cur, max);
      } else {
        list.add(Text('Covered'));
      }
    } else {
      max = nikke.fullReloadFrameCount;
      cur = nikke.reloadingFrameCount == 0 ? max : nikke.reloadingFrameCount;
      addProgressBar('Reloading', cur, max);
    }

    return list;
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
      decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1), color: Colors.grey),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(height: 12, width: size * percent, decoration: BoxDecoration(color: color)),
      ),
    );
  }
}
