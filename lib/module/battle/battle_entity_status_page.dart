import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/user_data.dart';
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
    // ('Info', () => buildStatTab()),
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
    final skillId = skill.skillId;
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
