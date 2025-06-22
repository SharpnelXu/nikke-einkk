import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';

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

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: [
          Text(locale.getTranslation(data.nameLocalkey) ?? data.nameLocalkey, style: TextStyle(fontSize: 20)),
          if (!data.isVisible) Text('NonPlayableCharacter'),
          Tooltip(
            message: locale.getTranslation(data.descriptionLocalkey) ?? data.descriptionLocalkey,
            child: Icon(Icons.info_outline),
          ),
        ],
      ),
      Text(
        'Resource ID: ${data.resourceId}   '
        'Name Code: ${data.nameCode}   '
        'Rarity: ${data.rawOriginalRare}   '
        'Element: ${data.elementId.map((eleId) => NikkeElement.fromId(eleId).name.toUpperCase()).join(', ')}',
      ),
      Text(
        'Class: ${data.rawCharacterClass}   '
        'Burst: ${data.rawUseBurstSkill}   '
        'Weapon: ${weapon?.rawWeaponType}   '
        'Corporation: ${data.rawCorporation} ${data.rawCorporationSubType ?? ''}',
      ),
      Text(
        'Squad: ${locale.getTranslation('Locale_Character:${data.squad.toLowerCase()}_name') ?? data.squad}   '
        '${locale.getTranslation('${data.cvLocalkey}_en') ?? data.cvLocalkey} (EN)'
        ' / ${locale.getTranslation('${data.cvLocalkey}_ko') ?? data.cvLocalkey} (KR)'
        ' / ${locale.getTranslation('${data.cvLocalkey}_ja') ?? data.cvLocalkey} (JP)'
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
        return buildWeaponTab();
      case 1:
        return buildSkillTab(data.skill1Id, data.skill1Table);
      case 2:
        return buildSkillTab(data.skill2Id, data.skill2Table);
      case 3:
        return buildSkillTab(data.ultiSkillId, SkillType.characterSkill);
      default:
        return Text('Not implemented');
    }
  }

  Widget buildWeaponTab() {
    return Text('Weapon ID: ${data.shotId}');
  }

  Widget buildSkillTab(int skillId, SkillType skillType) {
    return Text('Skill ID: $skillId, type: ${skillType == SkillType.characterSkill ? 'Active' : 'Passive'}');
  }
}
