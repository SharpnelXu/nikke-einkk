import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';
import 'package:nikke_einkk/module/common/skill_display.dart';
import 'package:nikke_einkk/module/common/slider.dart';

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
        ' / ${locale.getTranslation('${data.cvLocalkey}_ja') ?? data.cvLocalkey} (JP)',
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
        return buildSkillTab(data.skill1Id, data.skill1Table, 0);
      case 2:
        return buildSkillTab(data.skill2Id, data.skill2Table, 1);
      case 3:
        return buildSkillTab(data.ultiSkillId, SkillType.characterSkill, 2);
      default:
        return Text('Not implemented');
    }
  }

  Widget buildWeaponTab() {
    final weapon = this.weapon;
    final List<Widget> children = [
      Text('Weapon ID: ${data.shotId} - ${weapon == null ? 'Not Found' : 'Found'}', style: TextStyle(fontSize: 20)),
    ];
    if (weapon != null) {
      children.addAll([
        Wrap(
          spacing: 15,
          alignment: WrapAlignment.center,
          children: [
            Text('Weapon Type: ${weapon.rawWeaponType}'),
            Text('Bonus Range: ${data.bonusRangeMin} - ${data.bonusRangeMax}'),
            Text('Shot Timing: ${weapon.rawShotTiming}'),
            Text('Fire Type: ${weapon.rawFireType}'),
          ],
        ),
        Text('Damage', style: TextStyle(fontSize: 20)),
        Wrap(
          spacing: 15,
          alignment: WrapAlignment.center,
          children: [
            Text('Base: ${toPercentString(weapon.damage)}'),
            Text(
              'Critical: ${toPercentString(data.criticalDamage)} '
              '(${toPercentString(data.criticalRatio)} chance)',
            ),
            Text('Core: ${toPercentString(weapon.coreDamageRate)}'),
            if (weapon.fullChargeDamage != 10000)
              Text('Full Charge: ${toPercentString(weapon.fullChargeDamage)} (${timeString(weapon.chargeTime)})'),
          ],
        ),
        Text('Burst', style: TextStyle(fontSize: 20)),
        Wrap(
          spacing: 15,
          alignment: WrapAlignment.center,
          children: [
            Text('Base: ${toPercentString(weapon.burstEnergyPerShot / 100)}'),
            Text('Target: ${toPercentString(weapon.targetBurstEnergyPerShot / 100)}'),
            if (weapon.fullChargeBurstEnergy != 10000)
              Text('Full Charge: ${toPercentString(weapon.fullChargeBurstEnergy)}'),
            Text('Shot Count: ${weapon.shotCount} x ${weapon.muzzleCount}'),
          ],
        ),
        Text('Ammo', style: TextStyle(fontSize: 20)),
        Wrap(
          spacing: 15,
          alignment: WrapAlignment.center,
          children: [
            Text('Max Ammo: ${weapon.maxAmmo}'),
            Text('Reload Time: ${timeString(weapon.reloadTime)} (${toPercentString(weapon.reloadBullet)})'),
            Text('Time Exit Cover: ${timeString(weapon.spotFirstDelay)}'),
            Text('Time Enter Cover: ${timeString(weapon.spotLastDelay)}'),
          ],
        ),
        if (weapon.spotProjectileSpeed > 0) Text('Projectile', style: TextStyle(fontSize: 20)),
        if (weapon.spotProjectileSpeed > 0)
          Wrap(
            spacing: 15,
            alignment: WrapAlignment.center,
            children: [
              Text('Speed: ${weapon.spotProjectileSpeed}'),
              Text('Explosion Range: ${weapon.spotExplosionRange}'),
            ],
          ),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text('Rate Of Fire', style: TextStyle(fontSize: 20)),
            Tooltip(message: 'Note: capped to 60 due to frame rate', child: Icon(Icons.info_outline, size: 16)),
          ],
        ),
        Wrap(
          spacing: 15,
          alignment: WrapAlignment.center,
          children: [
            Text('Rate: ${weapon.rateOfFire} - ${weapon.endRateOfFire}'),
            Text('(${weapon.rateOfFire / 60} - ${weapon.endRateOfFire / 60} shots/s)'),
            Text('Change Per Shot: ${weapon.rateOfFireChangePerShot}'),
            Text('Reset Time: ${timeString(weapon.rateOfFireResetTime)}'),
          ],
        ),
        Text('Accuracy', style: TextStyle(fontSize: 20)),
        Wrap(
          spacing: 15,
          alignment: WrapAlignment.center,
          children: [
            Text('Rate: ${weapon.startAccuracyCircleScale} - ${weapon.endAccuracyCircleScale}'),
            Text('Change Per Shot: ${weapon.accuracyChangePerShot}'),
            Text('Reset Time: ${timeString(weapon.accuracyChangeSpeed)}'),
          ],
        ),
        Text('Misc', style: TextStyle(fontSize: 20)),
        Wrap(
          spacing: 15,
          alignment: WrapAlignment.center,
          children: [
            Text('Penetration: ${weapon.penetration}'),
            Text('Maintain Fire Stance: ${timeString(weapon.maintainFireStance)}'),
            Text('Up Fire Timing: ${toPercentString(weapon.upTypeFireTiming)}'),
          ],
        ),
      ]);
    }
    return Column(mainAxisSize: MainAxisSize.min, spacing: 3, children: children);
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
      if (skillInfo != null) formatSkillInfoDescription(skillInfo, widget.useGlobal),
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
    }
    return Column(mainAxisSize: MainAxisSize.min, spacing: 3, children: children);
  }
}
