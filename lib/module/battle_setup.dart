import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';
import 'package:nikke_einkk/module/nikke_list.dart';

class BattleSetupPage extends StatefulWidget {
  const BattleSetupPage({super.key});

  @override
  State<BattleSetupPage> createState() => _BattleSetupPageState();
}

class _BattleSetupPageState extends State<BattleSetupPage> {
  final RaptureDisplay raptureDisplay = RaptureDisplay();
  final List<NikkeDisplay> nikkeDisplays = List.generate(5, (_) => NikkeDisplay());

  // List of colors for the containers (optional)
  final List<Color> containerColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Battle Simulation')),
      body: SingleChildScrollView(
        // Vertical scrolling
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 500,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: raptureDisplay),
                  ...List.generate(5, (index) {
                    return Expanded(child: nikkeDisplays[index]);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RaptureDisplay extends StatefulWidget {
  final BattleRaptureOptions options = BattleRaptureOptions();

  RaptureDisplay({super.key});

  @override
  State<RaptureDisplay> createState() => _RaptureDisplayState();
}

class _RaptureDisplayState extends State<RaptureDisplay> {
  static const avatarSize = 100.0;

  BattleRaptureOptions get options => widget.options;

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat.decimalPattern();

    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        verticalDirection: VerticalDirection.down,
        spacing: 5,
        children: [
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(4)),
            child: Center(child: Text('${options.name}.png')),
          ),
          Text(options.name, maxLines: 1),
          Text('HP: ${format.format(options.startHp)}'),
          Text('ATK: ${format.format(options.startAttack)}'),
          Text('DEF: ${format.format(options.startDefence)}'),
          Text('Distance: ${format.format(options.startDistance)}'),
        ],
      ),
    );
  }
}

class NikkeDisplay extends StatefulWidget {
  final BattleNikkeOptions options = BattleNikkeOptions(nikkeResourceId: -1);

  NikkeDisplay({super.key});

  @override
  State<NikkeDisplay> createState() => _NikkeDisplayState();
}

class _NikkeDisplayState extends State<NikkeDisplay> {
  BattleNikkeOptions get option => widget.options;

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat.decimalPattern();
    final characterData = gameData.characterResourceGardeTable[option.nikkeResourceId]?[option.coreLevel];
    final name = gameData.getTranslation(characterData?.nameLocalkey)?.zhCN ?? characterData?.resourceId;
    final weapon = gameData.characterShotTable[characterData?.shotId];

    final doll = option.favoriteItem;
    final dollString =
        doll == null
            ? 'None'
            : '${doll.rarity.name.toUpperCase()} (Lv ${doll.rarity == Rarity.ssr ? dollLvString(doll, doll.level) : doll.level})';

    final List<Widget> statDisplays = [];

    if (option.nikkeResourceId != -1) {
      final Map<EquipLineType, int> equipLineVals = {};
      for (final equip in option.equips) {
        if (equip == null) continue;

        for (final equipLine in equip.equipLines) {
          final stateEffectData = gameData.stateEffectTable[equipLine.getStateEffectId()];
          if (stateEffectData == null) {
            continue;
          }

          for (final functionId in stateEffectData.functions) {
            if (functionId.function != 0) {
              final function = gameData.functionTable[functionId.function]!;
              equipLineVals.putIfAbsent(equipLine.type, () => 0);
              equipLineVals[equipLine.type] = equipLineVals[equipLine.type]! + function.functionValue;
            }
          }
        }
      }

      statDisplays.addAll([
        Text('Sync: ${option.syncLevel}'),
        Text('Core: ${coreString(option.coreLevel)}'),
        Text('Attract: ${option.attractLevel}'),
        Text('Skill: ${option.skillLevels.map((lv) => lv.toString()).join('/')}'),
        Text('Doll: $dollString'),
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 16,
              constraints: BoxConstraints(maxHeight: 16),
              padding: EdgeInsets.zero,
              icon: Icon(Icons.info),
              onPressed: () {},
              tooltip:
                  equipLineVals.isEmpty
                      ? 'No Lines Set'
                      : equipLineVals.keys
                          .map(
                            (equipLineType) =>
                                '$equipLineType:'
                                ' ${(equipLineVals[equipLineType]! / 100).toStringAsFixed(2)}%',
                          )
                          .join('\n'),
            ),
            Text(
              'Gear: ${option.equips.map((equip) {
                if (equip == null || equip.rarity == EquipRarity.unknown) return '-';

                return '${equip.rarity.name.toUpperCase()}'
                    '${equip.rarity.canHaveCorp && equip.corporation == characterData?.corporation ? 'C' : ''}';
              }).join('/')}',
            ),
          ],
        ),
        Text(
          'Gear Lv: ${option.equips.map((equip) {
            if (equip == null || equip.rarity == EquipRarity.unknown) return '-';

            return '${equip.level}';
          }).join('/')}',
        ),
      ]);

      if (WeaponType.chargeWeaponTypes.contains(weapon?.weaponType)) {
        statDisplays.addAll([
          Text('Always Focus: ${option.alwaysFocus}'),
          Text('Cancel Charge Delay: ${option.forceCancelShootDelay}'),
          Text('Charge Mode: ${option.chargeMode.name}'),
        ]);
      }
    }

    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        verticalDirection: VerticalDirection.down,
        spacing: 5,
        children: [
          InkWell(
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => NikkeSelectorPage(option: option)));
              if (mounted) setState(() {});
            },
            child: buildNikkeIcon(characterData, true, 'Tap to select'),
          ),
          Text(name == null ? 'None' : '$name / ${weapon?.weaponType}', maxLines: 1),
          ...statDisplays,
        ],
      ),
    );
  }
}
