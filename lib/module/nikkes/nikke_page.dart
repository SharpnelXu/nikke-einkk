import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';
import 'package:nikke_einkk/module/common/skill_display.dart';
import 'package:nikke_einkk/module/common/slider.dart';
import 'package:nikke_einkk/module/nikkes/nikke_widgets.dart';

class NikkeCharacterPage extends StatefulWidget {
  final bool useGlobal;
  final NikkeCharacterData data;

  const NikkeCharacterPage({super.key, required this.useGlobal, required this.data});

  @override
  State<NikkeCharacterPage> createState() => _NikkeCharacterPageState();
}

class _NikkeCharacterPageState extends State<NikkeCharacterPage> {
  int tab = 0;
  NikkeDatabaseV2 get db => widget.useGlobal ? global : cn;
  NikkeCharacterData get data => widget.data;
  WeaponData? get weapon => db.characterShotTable[data.shotId];
  List<int> skillLevels = [10, 10, 10];

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: [
          Text(locale.getTranslation(data.nameLocalkey) ?? data.nameLocalkey, style: TextStyle(fontSize: 20)),
          if (!data.isVisible) Text('NonPlayableCharacter or Unreleased'),
          Tooltip(
            textStyle: TextStyle(fontSize: 14),
            message: locale.getTranslation(data.descriptionLocalkey) ?? data.descriptionLocalkey,
            child: Icon(Icons.info_outline),
          ),
        ],
      ),
      Wrap(
        spacing: 15,
        alignment: WrapAlignment.center,
        children: [
          Text('Resource ID: ${data.resourceId}'),
          Text('Name Code: ${data.nameCode}'),
          Text('Rarity: ${data.rawOriginalRare}'),
          Text('Element: ${data.elementId.map((eleId) => NikkeElement.fromId(eleId).name.toUpperCase()).join(', ')}'),
        ],
      ),
      Wrap(
        spacing: 15,
        alignment: WrapAlignment.center,
        children: [
          Text('Class: ${data.rawCharacterClass}'),
          Text('Burst: ${data.rawUseBurstSkill}'),
          Text('Weapon: ${weapon?.rawWeaponType}'),
          Text('Corporation: ${data.rawCorporation} ${data.rawCorporationSubType ?? ''}'),
        ],
      ),
      Wrap(
        spacing: 15,
        alignment: WrapAlignment.center,
        children: [
          Text('Squad: ${locale.getTranslation('Locale_Character:${data.squad.toLowerCase()}_name') ?? data.squad}'),
          Text(
            '${locale.getTranslation('${data.cvLocalkey}_en') ?? data.cvLocalkey} (EN)'
            ' / ${locale.getTranslation('${data.cvLocalkey}_ko') ?? data.cvLocalkey} (KR)'
            ' / ${locale.getTranslation('${data.cvLocalkey}_ja') ?? data.cvLocalkey} (JP)',
          ),
        ],
      ),
      buildTabs(),
      Divider(),
      getTab(),
    ];
    return Scaffold(
      appBar: AppBar(title: Text('Nikke Data')),
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

  List<String> get tabTitle => ['Weapon', 'Skill 1', 'Skill 2', 'Burst'];

  Widget buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(tabTitle.length, (idx) {
        return TextButton(
          onPressed: () {
            tab = idx;
            setState(() {});
          },
          child: Text(tabTitle[idx], style: TextStyle(fontWeight: tab == idx ? FontWeight.bold : null)),
        );
      }),
    );
  }

  Widget getTab() {
    switch (tab) {
      case 0:
        return WeaponDataDisplay(character: data, weaponId: data.shotId, useGlobal: widget.useGlobal);
      case 1:
        return buildSkillTab(data.skill1Id, data.skill1Table, 0);
      case 2:
        return buildSkillTab(data.skill2Id, data.skill2Table, 1);
      case 3:
        return buildSkillTab(data.ultiSkillId, SkillType.characterSkill, 2);
      default:
        return Text('Not implemented');
    }
  }

  Widget buildSkillTab(int skillId, SkillType skillType, int index) {
    final level = skillLevels[index];
    final actualSkillId = skillId + level - 1;

    final skillInfo = db.skillInfoTable[actualSkillId];

    final List<Widget> children = [
      Text(
        '${skillInfo == null ? 'Skill Info Not Found!' : locale.getTranslation(skillInfo.nameLocalkey)} Lv $level',
        style: TextStyle(fontSize: 20),
      ),
      Text('Skill ID: $actualSkillId, type: ${skillType == SkillType.characterSkill ? 'Active' : 'Passive'}'),
      if (skillInfo != null) DescriptionTextWidget(skillInfo, widget.useGlobal),
      SliderWithPrefix(
        titled: true,
        label: 'Skill ${index + 1}',
        min: 1,
        max: 10,
        value: level,
        valueFormatter: (v) => 'Lv$v',
        onChange: (newValue) {
          skillLevels[index] = newValue.round();
          if (mounted) setState(() {});
        },
      ),
    ];
    if (skillType == SkillType.stateEffect) {
      final data = db.stateEffectTable[actualSkillId];
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
            child: StateEffectDataDisplay(data: data, useGlobal: widget.useGlobal),
          ),
        );
      }
    } else if (skillType == SkillType.characterSkill) {
      final data = db.characterSkillTable[actualSkillId];
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
            child: CharacterSkillDataDisplay(data: data, useGlobal: widget.useGlobal),
          ),
        );
      }
    }
    return Column(mainAxisSize: MainAxisSize.min, spacing: 3, children: children);
  }
}
