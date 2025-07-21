import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/buff.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/model/user_data.dart';
import 'package:nikke_einkk/module/battle/battle_widgets.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';
import 'package:nikke_einkk/module/common/skill_display.dart';
import 'package:nikke_einkk/module/nikkes/nikke_widgets.dart';

class BattleNikkeStatusPage extends StatefulWidget {
  final BattleSimulation simulation;
  final BattleNikke nikke;
  const BattleNikkeStatusPage({super.key, required this.simulation, required this.nikke});

  @override
  State<BattleNikkeStatusPage> createState() => _BattleNikkeStatusPageState();
}

class _BattleNikkeStatusPageState extends State<BattleNikkeStatusPage> {
  BattleSimulation get simulation => widget.simulation;
  BattleNikke get nikke => widget.nikke;
  NikkeCharacterData get data => nikke.characterData;
  NikkeOptions get option => nikke.option;
  NikkeDatabase get db => simulation.db;

  int tab = 0;

  List<(String, Widget Function())> get tabs => [
    ('Buffs', () => buildBuffs()),
    ('Weapon', () => WeaponDataDisplay(character: data, weaponId: data.shotId)),
    ('Skill 1', () => buildSkillTab(0)),
    ('Skill 2', () => buildSkillTab(1)),
    ('Burst', () => buildSkillTab(2)),
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [buildTabs(), const Divider(), tabs[tab].$2()];
    return Scaffold(
      appBar: AppBar(title: Text('${simulation.getEntityName(nikke.uniqueId)} Status')),
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

  Widget buildBuffs() {
    final List<Widget> children = [];
    final passiveTypes = [Source.equip, Source.doll, Source.cube];
    children.add(Text('Active Buffs', style: boldStyle));
    final activeBuffs = nikke.buffs.whereNot((buff) => passiveTypes.contains(buff.source));
    children.addAll(activeBuffs.map(buildBuff));

    for (final type in passiveTypes) {
      final buffs = nikke.buffs.where((buff) => buff.source == type);
      if (buffs.isNotEmpty) {
        children.add(Text('${type.name.pascal} Buffs', style: boldStyle));
        children.addAll(buffs.map(buildBuff));
      }
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: children,
      ),
    );
  }

  Widget buildBuff(BattleBuff buff) {
    final func = buff.data;
    final name = locale.getTranslation(func.nameLocalkey);
    final description = formatFunctionDescription(func).replaceAll('\n', '');
    final secondaryStyle = TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.secondary);
    return Row(
      spacing: 8,
      children: [
        simpleBuffIcon(simulation, buff),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 3,
            children: [
              Text(
                '${name == null ? '' : '$name: '}'
                '${func.functionType.name.pascal}'
                ' by ${simulation.getEntityName(buff.buffGiverId)} ${buff.source.name.pascal}',
              ),
              if (description.isNotEmpty) Text(description, style: secondaryStyle),
              Text('${func.groupId}', style: secondaryStyle),
            ],
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 3,
          children: [
            Text(
              '${skillValueString(func.functionValue, func.functionValueType) ?? 'N/A'}'
              '${buff.count > 1 ? ' (${buff.count} stacks)' : ''}'
              '${func.functionStandard == StandardType.user && buff.buffReceiverId != buff.buffGiverId ? ' of Activator' : ''}',
            ),
            if ([DurationType.timeSec, DurationType.timeSecVer2].contains(func.durationType))
              Text(
                '${(buff.duration / simulation.fps).toStringAsFixed(3)} s (${buff.duration} frames)',
                style: secondaryStyle,
              ),
            if ([DurationType.hits, DurationType.hitsVer2].contains(func.durationType))
              Text('${buff.duration} shots', style: secondaryStyle),
          ],
        ),
      ],
    );
  }

  Widget buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(tabs.length, (idx) {
        return TextButton(
          onPressed: () {
            tab = idx;
            setState(() {});
          },
          child: Text(tabs[idx].$1, style: TextStyle(fontWeight: tab == idx ? FontWeight.bold : null)),
        );
      }),
    );
  }

  Widget buildSkillTab(int index) {
    final level = option.skillLevels[index];
    final skill = nikke.skills[index];
    final skillId = skill.levelSkillId;
    final skillType = skill.skillType;

    final skillInfo = db.skillInfoTable[skillId];

    final List<Widget> children = [
      Text(
        '${skillInfo == null ? 'Skill Info Not Found!' : locale.getTranslation(skillInfo.nameLocalkey)} Lv $level',
        style: TextStyle(fontSize: 20),
      ),
      Wrap(
        spacing: 5,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [Text('Skill ID: $skillId, type: ${skillType == SkillType.characterSkill ? 'Active' : 'Passive'}')],
      ),
      if (skillInfo != null) DescriptionTextWidget(formatSkillInfoDescription(skillInfo)),
    ];
    if (skillType == SkillType.stateEffect) {
      final data = db.stateEffectTable[skillId];
      if (data == null) {
        children.add(Text('Not Found!'));
      } else {
        children.add(
          Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: StateEffectDataDisplay(data: data),
          ),
        );
      }
    } else if (skillType == SkillType.characterSkill) {
      final data = db.characterSkillTable[skillId];
      if (data == null) {
        children.add(Text('Not Found!'));
      } else {
        children.add(
          Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: CharacterSkillDataDisplay(data: data),
          ),
        );
      }
    }
    return Container(
      padding: const EdgeInsets.all(8.0),
      constraints: const BoxConstraints(maxWidth: 700),
      child: Column(mainAxisSize: MainAxisSize.min, spacing: 3, children: children),
    );
  }
}
