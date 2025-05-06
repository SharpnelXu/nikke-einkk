import 'dart:convert';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/items.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/model/translation.dart';
import 'package:path/path.dart';

/// db object
final gameData = NikkeDatabase();

class NikkeDatabase {
  static const String appPath = '.';

  String get dataPath => join(appPath, 'data');
  String get characterTableFilePath => join(dataPath, 'CharacterTable.json');
  String get characterShotTableFilePath => join(dataPath, 'CharacterShotTable.json');
  String get characterSkillTableFilePath => join(dataPath, 'CharacterSkillTable.json');
  String get stateEffectTableFilePath => join(dataPath, 'StateEffectTable.json');
  String get functionTableFilePath => join(dataPath, 'FunctionTable.json');
  String get characterStatTableFilePath => join(dataPath, 'CharacterStatTable.json');
  String get characterStatEnhanceTableFilePath => join(dataPath, 'CharacterStatEnhanceTable.json');
  String get attractiveLevelTableFilePath => join(dataPath, 'AttractiveLevelTable.json');
  String get localeCharacterTableFilePath => join(dataPath, 'LocaleCharacterTable.json');
  String get itemEquipTableFilePath => join(dataPath, 'ItemEquipTable.json');

  final Map<int, NikkeCharacterData> characterData = {}; // maybe not needed
  final Map<int, Map<int, NikkeCharacterData>> characterResourceGardeTable = {};
  final Map<String, Translation> localeCharacterTable = {};
  final Map<int, WeaponSkillData> characterShotTable = {};
  final Map<int, SkillData> characterSkillTable = {};
  final Map<int, StateEffectData> stateEffectTable = {};
  final Map<int, FunctionData> functionTable = {};

  // character stats
  // grouped by group/level
  final Map<int, Map<int, CharacterStatData>> groupedCharacterStatTable = {};
  final Map<int, CharacterStatEnhanceData> characterStatEnhanceTable = {};
  final Map<int, AttractiveStatData> attractiveStatTable = {};

  // equips
  final Map<EquipType, Map<NikkeClass, Map<EquipRarity, EquipmentItemData>>> groupedEquipTable = {};

  static final Logger logger = Logger();
  bool dataLoaded = false;

  Future<bool> loadData() async {
    logger.i('Loading Database......');

    bool result = true;

    result &= await loadCharacterData();
    result &= await loadTranslationData();
    result &= await loadCharacterShotData();
    result &= await loadCharacterStatData();
    result &= await loadCharacterStatEnhanceData();
    result &= await loadAttractiveStatData();
    result &= await loadEquipData();
    result &= await loadCharacterSkillData();
    result &= await loadStateEffectData();
    result &= await loadFunctionData();

    dataLoaded = result;
    logger.i('Loading completed, result: $dataLoaded');
    return result;
  }

  Future<bool> loadCharacterData() async {
    final characterTableFile = File(characterTableFilePath);
    final bool exists = await characterTableFile.exists();
    if (exists) {
      final json = jsonDecode(await characterTableFile.readAsString());
      for (final record in json['records']) {
        final character = NikkeCharacterData.fromJson(record);
        if (!character.isVisible) continue;

        characterData[character.id] = character;
        characterResourceGardeTable.putIfAbsent(character.resourceId, () => <int, NikkeCharacterData>{});
        characterResourceGardeTable[character.resourceId]![character.gradeCoreId] = character;
      }
    }
    return exists;
  }

  Future<bool> loadTranslationData() async {
    final characterTranslationTableFile = File(localeCharacterTableFilePath);
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

  Future<bool> loadCharacterStatData() async {
    final table = File(characterStatTableFilePath);
    final bool exists = await table.exists();
    if (exists) {
      final json = jsonDecode(await table.readAsString());
      for (final record in json['records']) {
        final stat = CharacterStatData.fromJson(record);
        groupedCharacterStatTable.putIfAbsent(stat.group, () => <int, CharacterStatData>{});
        groupedCharacterStatTable[stat.group]![stat.level] = stat;
      }
    }
    return exists;
  }

  Future<bool> loadCharacterStatEnhanceData() async {
    final table = File(characterStatEnhanceTableFilePath);
    final bool exists = await table.exists();
    if (exists) {
      final json = jsonDecode(await table.readAsString());
      for (final record in json['records']) {
        final statEnhance = CharacterStatEnhanceData.fromJson(record);
        characterStatEnhanceTable[statEnhance.id] = statEnhance;
      }
    }
    return exists;
  }

  Future<bool> loadAttractiveStatData() async {
    final table = File(attractiveLevelTableFilePath);
    final bool exists = await table.exists();
    if (exists) {
      final json = jsonDecode(await table.readAsString());
      for (final record in json['records']) {
        final attractiveStat = AttractiveStatData.fromJson(record);
        attractiveStatTable[attractiveStat.attractiveLevel] = attractiveStat;
      }
    }
    return exists;
  }

  Future<bool> loadEquipData() async {
    final table = File(itemEquipTableFilePath);
    final bool exists = await table.exists();
    if (exists) {
      final json = jsonDecode(await table.readAsString());
      for (final record in json['records']) {
        final equip = EquipmentItemData.fromJson(record);
        if (equip.characterClass == NikkeClass.unknown) continue;

        groupedEquipTable.putIfAbsent(equip.itemSubType, () => <NikkeClass, Map<EquipRarity, EquipmentItemData>>{});
        groupedEquipTable[equip.itemSubType]!.putIfAbsent(
          equip.characterClass,
          () => <EquipRarity, EquipmentItemData>{},
        );
        groupedEquipTable[equip.itemSubType]![equip.characterClass]![equip.itemRarity] = equip;
      }
    }
    return exists;
  }

  Future<bool> loadCharacterSkillData() async {
    final table = File(characterSkillTableFilePath);
    final bool exists = await table.exists();
    if (exists) {
      final json = jsonDecode(await table.readAsString());
      for (final record in json['records']) {
        final skill = SkillData.fromJson(record);

        characterSkillTable[skill.id] = skill;
      }
    }
    return exists;
  }

  Future<bool> loadStateEffectData() async {
    final table = File(stateEffectTableFilePath);
    final bool exists = await table.exists();
    if (exists) {
      final json = jsonDecode(await table.readAsString());
      for (final record in json['records']) {
        final stateEffect = StateEffectData.fromJson(record);
        stateEffectTable[stateEffect.id] = stateEffect;
      }
    }
    return exists;
  }

  Future<bool> loadFunctionData() async {
    final table = File(functionTableFilePath);
    final bool exists = await table.exists();
    if (exists) {
      final json = jsonDecode(await table.readAsString());
      for (final record in json['records']) {
        final function = FunctionData.fromJson(record);
        functionTable[function.id] = function;
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
