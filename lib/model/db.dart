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
  String get characterShotTableFilePath => join(dataPath, 'CharacterShotTable.json');

  final Map<int, NikkeCharacterData> characterData = {};
  final Map<int, Map<int, NikkeCharacterData>> characterResourceGardeTable = {};
  final Map<String, Translation> localeCharacterTable = {};
  final Map<int, WeaponSkillData> characterShotTable = {};

  Future<bool> loadData() async {
    bool result = true;

    result &= await loadCharacterData();
    result &= await loadTranslationData();
    result &= await loadCharacterShotData();

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
          localeCharacterTable[translation.key] = translation;
        }
      }
    }
    return exists;
  }

  Future<bool> loadCharacterShotData() async {
    final table = File(characterShotTableFilePath);
    final bool exists = await table.exists();
    if (exists) {
      final json = jsonDecode(await table.readAsString());
      for (final record in json['records']) {
        final weapon = WeaponSkillData.fromJson(record);
        characterShotTable[weapon.id] = weapon;
      }
    }
    return exists;
  }

  Translation? getTranslation(String joinedKey) {
    final splits = joinedKey.split(':');
    final tableType = splits[0];
    final key = splits[1];
    if (tableType == 'Locale_Character') {
      return localeCharacterTable[key];
    }

    return null;
  }
}
