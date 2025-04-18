import 'dart:convert';
import 'dart:io';

import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/translation.dart';
import 'package:path/path.dart';

/// db object
final gameData = NikkeDatabase();

class NikkeDatabase {
  static const String appPath = '.';

  String get dataPath => join(appPath, 'data');
  String get characterTableFilePath => join(dataPath, 'CharacterTable.json');
  String get characterTranslationTableFilePath => join(dataPath, 'CharacterTranslationTable.json');

  final Map<int, NikkeCharacterData> characterData = {};
  final Map<int, Map<int, NikkeCharacterData>> characterResourceGardeTable = {};
  final Map<int, Translation> characterNameTranslation = {};

  Future<bool> loadData() async {
    bool result = true;

    result &= await loadCharacterData();
    result &= await loadTranslationData();

    return result;
  }

  Future<bool> loadCharacterData() async {
    final characterTableFile = File(characterTableFilePath);
    final bool exists = await characterTableFile.exists();
    if (exists) {
      final json = jsonDecode(await characterTableFile.readAsString());
      for (final record in json['records']) {
        final character = NikkeCharacterData.fromJson(record);
        characterData[character.id] = character;
        characterResourceGardeTable.putIfAbsent(character.resourceId, () => <int, NikkeCharacterData>{});
        characterResourceGardeTable[character.resourceId]![character.gradeCoreId] = character;
      }
    }
    return exists;
  }

  Future<bool> loadTranslationData() async {
    final characterTranslationTableFile = File(characterTranslationTableFilePath);
    final bool exists = await characterTranslationTableFile.exists();
    if (exists) {
      final jsonList = jsonDecode(await characterTranslationTableFile.readAsString());
      final regex = RegExp(r'^\d+_name');
      for (final record in jsonList) {
        final translation = Translation.fromJson(record);
        final match = regex.hasMatch(translation.key);
        if (match) {
          final resourceId = translation.key.split('_')[0];
          characterNameTranslation[int.parse(resourceId)] = translation;
        }
      }
    }
    return exists;
  }
}
