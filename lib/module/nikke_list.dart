import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';

class NikkeList extends StatelessWidget {
  const NikkeList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nikke List')),
      body: CustomScrollView(
        slivers: [
          SliverGrid.extent(
            maxCrossAxisExtent: 144,
            children:
                gameData.characterResourceGardeTable.values.map((characterData) => _buildGrid(characterData)).toList(),
          ),
        ],
        physics: const AlwaysScrollableScrollPhysics(),
      ),
    );
  }

  Widget _buildGrid(Map<int, NikkeCharacterData> gradeToData) {
    final characterData = gradeToData.values.last;
    final name = gameData.getTranslation(characterData.nameLocalkey)?.zhCN ?? characterData.resourceId;
    final weapon = gameData.characterShotTable[characterData.shotId]!;

    return Tooltip(
      message:
          'id: ${characterData.id}\n'
          'resourceId: ${characterData.resourceId}\n'
          'rarity: ${characterData.originalRare}\n'
          'class: ${characterData.characterClass}\n'
          'corp: ${characterData.corporation}\n'
          'burstStep: ${characterData.useBurstSkill} => ${characterData.changeBurstStep}\n'
          'shotId: ${characterData.shotId}\n'
          'first/lastDelay: ${weapon.spotFirstDelay}/${weapon.spotLastDelay}',
      child: Container(
        width: 100,
        height: 150,
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5),
          color: weapon.spotFirstDelay != 20 || weapon.spotLastDelay != 20 ? Colors.red : null,
        ),
        child: Center(
          child: Text(
            '$name / ${weapon.weaponType}',
            style: TextStyle(color: characterData.hasUnknownEnum ? Colors.red : Colors.black, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
