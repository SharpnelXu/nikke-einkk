import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:logger/logger.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/data_path.dart';
import 'package:nikke_einkk/model/items.dart';
import 'package:nikke_einkk/model/monster.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/model/stages.dart';
import 'package:nikke_einkk/model/translation.dart';
import 'package:nikke_einkk/model/user_data.dart';
import 'package:path/path.dart';

/// db object
final db = NikkeDatabase();

final locale = Locale();
final global = NikkeDatabaseV2(true);
final cn = NikkeDatabaseV2(false);
final userDb = UserDatabase();

final Logger logger = Logger();

enum Language { unknown, ko, en, ja, zhTW, zhCN, th, de, fr }

class Locale {
  Language language = Language.en;

  final Map<String, Map<String, Translation>> locale = {};

  bool init() {
    locale.clear();

    bool result = true;
    result &= loadLocaleCharacter();
    result &= loadGeneral('Locale_Skill');
    result &= loadGeneral('Locale_System');
    result &= loadGeneral('Locale_Monster');

    logger.i('Locale init result: $result');

    return result;
  }

  bool loadLocaleCharacter() {
    final type = 'Locale_Character';
    final file = File(join(localePath, type, '$type.json'));
    final exists = file.existsSync();
    if (exists) {
      locale[type] = {};
      final jsonList = jsonDecode(file.readAsStringSync());
      final regex = RegExp(r'^\d+_name');
      for (final record in jsonList) {
        final translation = Translation.fromJson(record);
        final match = regex.hasMatch(translation.key);
        if (match) {
          locale[type]![translation.key] = translation;
        }
      }
    }
    return exists;
  }

  bool loadGeneral(String type) {
    final file = File(join(localePath, type, '$type.json'));
    final exists = file.existsSync();
    if (exists) {
      locale[type] = {};
      final jsonList = jsonDecode(file.readAsStringSync());
      for (final record in jsonList) {
        final translation = Translation.fromJson(record);
        locale[type]![translation.key] = translation;
      }
    }
    return exists;
  }

  String? getTranslation(String? joinedKey) {
    if (joinedKey == null) return null;

    final splits = joinedKey.split(':');
    if (splits.length != 2) return null;

    final tableType = splits[0];
    final key = splits[1];
    return locale[tableType]?[key]?.forLanguage(language);
  }
}

class NikkeDatabaseV2 {
  bool isGlobal = true;
  bool initialized = false;

  String get server => isGlobal ? 'Global' : 'CN';

  NikkeDatabaseV2(this.isGlobal);

  final Map<int, List<UnionRaidWaveData>> unionRaidData = {}; // key is presetId
  final Map<int, String> waveGroupDict = {};
  final Map<String, Map<int, WaveData>> waveData = {};
  final Map<int, MonsterData> raptureData = {};
  final Map<int, List<MonsterPartData>> rapturePartData = {}; // key is modelId
  final Map<int, Map<int, MonsterStatEnhanceData>> monsterStatEnhanceData = {}; // key is groupId, lv
  final Map<int, List<MonsterStageLevelChangeData>> monsterStageLvChangeData = {};
  final Map<int, List<SoloRaidWaveData>> soloRaidData = {}; // key is presetId
  final Map<int, StateEffectData> stateEffectTable = {};
  final Map<int, FunctionData> functionTable = {};

  void init() {
    unionRaidData.clear();
    waveGroupDict.clear();
    waveData.clear();
    raptureData.clear();
    rapturePartData.clear();
    monsterStatEnhanceData.clear();
    monsterStageLvChangeData.clear();
    soloRaidData.clear();
    stateEffectTable.clear();
    functionTable.clear();

    final extractFolderPath = getExtractDataFolderPath(isGlobal);
    initialized = true;
    initialized &= loadData(
      getDesignatedDirectory(extractFolderPath, 'UnionRaidPresetTable.json'),
      processUnionRaidWaveData,
    );
    initialized &= loadData(getDesignatedDirectory(extractFolderPath, 'MonsterTable.json'), processRaptureData);
    initialized &= loadData(
      getDesignatedDirectory(extractFolderPath, 'MonsterPartsTable.json'),
      processRapturePartData,
    );
    initialized &= loadData(
      getDesignatedDirectory(extractFolderPath, 'MonsterStatEnhanceTable.json'),
      processMonsterStatEnhanceData,
    );
    initialized &= loadData(
      getDesignatedDirectory(extractFolderPath, 'MonsterStageLvChangeTable.json'),
      processMonsterStageLvChangeData,
    );
    initialized &= loadData(
      getDesignatedDirectory(extractFolderPath, 'SoloRaidPresetTable.json'),
      processSoloRaidWaveData,
    );
    initialized &= loadData(getDesignatedDirectory(extractFolderPath, 'StateEffectTable.json'), processStateEffectData);
    initialized &= loadData(getDesignatedDirectory(extractFolderPath, 'FunctionTable.json'), processFunctionData);

    initialized &= loadCsv(getDesignatedDirectory(extractFolderPath, 'WaveData.GroupDict.csv'), processWaveDict);
  }

  WaveData? getWaveData(int stageId) {
    final extractFolderPath = getExtractDataFolderPath(isGlobal);
    final group = waveGroupDict[stageId];
    if (group == null) {
      return null;
    }

    if (!waveData.containsKey(group)) {
      final loaded = loadData(getDesignatedDirectory(extractFolderPath, 'WaveDataTable.$group.json'), processWaveData);
      if (!loaded) {
        logger.w('Tried to load wave $group based on stage $stageId, but failed');
      }
    }

    return waveData[group]?[stageId];
  }

  void processWaveDict(List<String> data) {
    if (data.length == 2) {
      final wave = int.parse(data.first);
      final group = data.last;
      waveGroupDict[wave] = group;
    }
  }

  void processSoloRaidWaveData(dynamic record) {
    final data = SoloRaidWaveData.fromJson(record);
    soloRaidData.putIfAbsent(data.presetGroupId, () => []);
    soloRaidData[data.presetGroupId]!.add(data);
  }

  void processUnionRaidWaveData(dynamic record) {
    final data = UnionRaidWaveData.fromJson(record);
    unionRaidData.putIfAbsent(data.presetGroupId, () => []);
    unionRaidData[data.presetGroupId]!.add(data);
  }

  void processWaveData(dynamic record) {
    final data = WaveData.fromJson(record);
    waveData.putIfAbsent(data.groupId, () => {});
    waveData[data.groupId]![data.stageId] = data;
  }

  void processRaptureData(dynamic record) {
    final data = MonsterData.fromJson(record);
    raptureData[data.id] = data;
  }

  void processRapturePartData(dynamic record) {
    final data = MonsterPartData.fromJson(record);
    rapturePartData.putIfAbsent(data.monsterModelId, () => []);
    rapturePartData[data.monsterModelId]!.add(data);
  }

  void processMonsterStatEnhanceData(dynamic record) {
    final data = MonsterStatEnhanceData.fromJson(record);
    monsterStatEnhanceData.putIfAbsent(data.groupId, () => {});
    monsterStatEnhanceData[data.groupId]![data.lv] = data;
  }

  void processMonsterStageLvChangeData(dynamic record) {
    final data = MonsterStageLevelChangeData.fromJson(record);
    monsterStageLvChangeData.putIfAbsent(data.group, () => []);
    monsterStageLvChangeData[data.group]!.add(data);
  }

  void processStateEffectData(dynamic record) {
    final data = StateEffectData.fromJson(record);
    stateEffectTable[data.id] = data;
  }

  void processFunctionData(dynamic record) {
    final data = FunctionData.fromJson(record);
    functionTable[data.id] = data;
  }
}

class UserDatabase {
  bool initialized = false;
  final Map<String, String> customizeDirectory = {};

  void init() {
    customizeDirectory.clear();

    initialized = true;
    initialized &= loadCsv(join(userDataPath, 'DataDirectory.csv'), processCustomizeDirectory);
  }

  void processCustomizeDirectory(List<String> data) {
    if (data.length == 2) {
      final prefix = data.first;
      final folder = data.last;
      customizeDirectory[prefix] = folder;
    }
  }
}

bool loadCsv(String filePath, void Function(List<String>) process) {
  final csv = File(filePath);
  final exists = csv.existsSync();

  if (exists) {
    final lines = csv.readAsLinesSync();
    for (int idx = 1; idx < lines.length; idx += 1) {
      final line = lines[idx];
      process(line.split(', '));
    }
  }

  return exists;
}

bool loadData(String filePath, void Function(dynamic) process) {
  final table = File(filePath);
  final exists = table.existsSync();
  if (exists) {
    final json = jsonDecode(table.readAsStringSync());
    for (final record in json['records']) {
      process(record);
    }
  }
  return exists;
}

/// will be deprecated i guess
class NikkeDatabase {
  static const String appPath = '.';

  String get userDataPath => join(appPath, 'userData');

  String get userDataFilePath => join(userDataPath, 'UserData.json');

  String get dataPath => join(appPath, 'data');
  String get characterTableFilePath => join(dataPath, 'CharacterTable.json');
  String get characterShotTableFilePath => join(dataPath, 'CharacterShotTable.json');
  String get characterSkillTableFilePath => join(dataPath, 'CharacterSkillTable.json');
  String get stateEffectTableFilePath => join(dataPath, 'StateEffectTable.json');
  String get functionTableFilePath => join(dataPath, 'FunctionTable.json');
  String get characterStatTableFilePath => join(dataPath, 'CharacterStatTable.json');
  String get characterStatEnhanceTableFilePath => join(dataPath, 'CharacterStatEnhanceTable.json');
  String get attractiveLevelTableFilePath => join(dataPath, 'AttractiveLevelTable.json');
  String get itemEquipTableFilePath => join(dataPath, 'ItemEquipTable.json');
  String get itemHarmonyCubeTableFilePath => join(dataPath, 'ItemHarmonyCubeTable.json');
  String get itemHarmonyCubeLevelTableFilePath => join(dataPath, 'ItemHarmonyCubeLevelTable.json');
  String get favoriteItemTableFilePath => join(dataPath, 'FavoriteItemTable.json');
  String get favoriteItemLevelTableFilePath => join(dataPath, 'FavoriteItemLevelTable.json');
  String get skillInfoTableFilePath => join(dataPath, 'SkillInfoTable.json');
  String get coverStatEnhanceTableFilePath => join(dataPath, 'CoverStatEnhanceTable.json');
  String get localeCharacterFilePath => join(dataPath, 'Locale_Character.json');
  String get localeSkillFilePath => join(dataPath, 'Locale_Skill.json');

  final Map<int, NikkeCharacterData> characterData = {}; // maybe not needed
  final Map<int, Map<int, NikkeCharacterData>> characterResourceGardeTable = {};
  final Map<int, WeaponData> characterShotTable = {};
  final Map<int, SkillData> characterSkillTable = {};
  final Map<int, StateEffectData> stateEffectTable = {};
  final Map<int, FunctionData> functionTable = {};
  final Map<int, HarmonyCubeData> harmonyCubeTable = {};
  final Map<int, CoverStatData> coverStatTable = {};
  final Map<int, SkillInfoData> skillInfoTable = {};
  final Map<String, Translation> localeCharacterTable = {};
  final Map<String, Translation> localeSkillTable = {};

  // character stats
  // grouped by enhanceId, level
  final Map<int, Map<int, CharacterStatData>> groupedCharacterStatTable = {};
  // grouped by enhanceId
  final Map<int, CharacterStatEnhanceData> characterStatEnhanceTable = {};
  final Map<int, AttractiveStatData> attractiveStatTable = {};
  // grouped by skillGroupId, skillLevel
  final Map<int, Map<int, SkillInfoData>> groupedSkillInfoTable = {};

  // equips
  final Map<EquipType, Map<NikkeClass, Map<EquipRarity, EquipmentData>>> groupedEquipTable = {};

  // favoriteItems
  final Map<WeaponType, Map<Rarity, FavoriteItemData>> dollTable = {};
  final Map<int, FavoriteItemData> nameCodeFavItemTable = {};

  // grouped by enhanceId, level
  final Map<int, Map<int, HarmonyCubeLevelData>> harmonyCubeLevelTable = {};
  final Map<int, Map<int, FavoriteItemLevelData>> favoriteItemLevelTable = {};

  final Set<FunctionType> onShotFunctionTypes = {};
  final Set<FunctionType> onHitFunctionTypes = {};

  UserData userData = UserData();

  bool dataLoaded = false;
  int maxSyncLevel = 1;

  Future<bool> loadData() async {
    logger.i('Loading Database......');

    bool result = true;

    result &= await loadCharacterData();
    result &= await loadLocaleCharacter();
    result &= await loadLocaleSkill();
    result &= await loadCharacterShotData();
    result &= await loadCharacterStatData();
    result &= await loadCharacterStatEnhanceData();
    result &= await loadAttractiveStatData();
    result &= await loadEquipData();
    result &= await loadCharacterSkillData();
    result &= await loadStateEffectData();
    result &= await loadFunctionData();
    result &= await loadSkillInfoData();
    result &= await loadHarmonyCubeData();
    result &= await loadHarmonyCubeLevelData();
    result &= await loadFavoriteItemData();
    result &= await loadFavoriteItemLevelData();
    result &= await loadCoverStatData();

    await loadUserData();

    dataLoaded = result;
    logger.i('Loading completed, result: $dataLoaded');
    return result;
  }

  void writeUserData() async {
    final file = File(userDataFilePath);
    await file.writeAsString(jsonEncode(userData.toJson()));
  }

  Future<bool> loadUserData() async {
    final file = File(userDataFilePath);
    final bool exists = await file.exists();
    if (exists) {
      final json = jsonDecode(await file.readAsString());
      userData = UserData.fromJson(json);
    }
    return exists;
  }

  Future<bool> loadCharacterData() async {
    final characterTableFile = File(characterTableFilePath);
    final bool exists = await characterTableFile.exists();
    if (exists) {
      final json = jsonDecode(await characterTableFile.readAsString());
      for (final record in json['records']) {
        final character = NikkeCharacterData.fromJson(record);
        if (!character.isVisible) continue;

        if (character.resourceId == 16) {
          character.elementId.add(NikkeElement.iron.id);
        }

        characterData[character.id] = character;
        characterResourceGardeTable.putIfAbsent(character.resourceId, () => <int, NikkeCharacterData>{});
        characterResourceGardeTable[character.resourceId]![character.gradeCoreId] = character;
      }
    }
    return exists;
  }

  Future<bool> loadLocaleCharacter() async {
    final characterTranslationTableFile = File(localeCharacterFilePath);
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

  Future<bool> loadLocaleSkill() async {
    final file = File(localeSkillFilePath);
    final bool exists = await file.exists();
    if (exists) {
      final jsonList = jsonDecode(await file.readAsString());
      for (final record in jsonList) {
        final translation = Translation.fromJson(record);
        localeSkillTable[translation.key] = translation;
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
        final weapon = WeaponData.fromJson(record);
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
        maxSyncLevel = max(maxSyncLevel, stat.level);
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
        final equip = EquipmentData.fromJson(record);
        if (equip.characterClass == NikkeClass.unknown) continue;

        groupedEquipTable.putIfAbsent(equip.itemSubType, () => <NikkeClass, Map<EquipRarity, EquipmentData>>{});
        groupedEquipTable[equip.itemSubType]!.putIfAbsent(equip.characterClass, () => <EquipRarity, EquipmentData>{});
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

        if (function.durationType == DurationType.shots) {
          onShotFunctionTypes.add(function.functionType);
        }
        if (function.durationType == DurationType.hits) {
          onHitFunctionTypes.add(function.functionType);
        }
      }
    }
    return exists;
  }

  Future<bool> loadSkillInfoData() async {
    final table = File(skillInfoTableFilePath);
    final bool exists = await table.exists();
    if (exists) {
      final json = jsonDecode(await table.readAsString());
      for (final record in json['records']) {
        final skillInfo = SkillInfoData.fromJson(record);
        skillInfoTable[skillInfo.id] = skillInfo;
        groupedSkillInfoTable.putIfAbsent(skillInfo.groupId, () => {});
        groupedSkillInfoTable[skillInfo.groupId]![skillInfo.skillLevel] = skillInfo;
      }
    }
    return exists;
  }

  Future<bool> loadHarmonyCubeData() async {
    final table = File(itemHarmonyCubeTableFilePath);
    final bool exists = await table.exists();
    if (exists) {
      final json = jsonDecode(await table.readAsString());
      for (final record in json['records']) {
        final harmonyCube = HarmonyCubeData.fromJson(record);
        harmonyCubeTable[harmonyCube.id] = harmonyCube;
      }
    }
    return exists;
  }

  Future<bool> loadHarmonyCubeLevelData() async {
    final table = File(itemHarmonyCubeLevelTableFilePath);
    final bool exists = await table.exists();
    if (exists) {
      final json = jsonDecode(await table.readAsString());
      for (final record in json['records']) {
        final harmonyLevelStat = HarmonyCubeLevelData.fromJson(record);
        harmonyCubeLevelTable.putIfAbsent(harmonyLevelStat.levelEnhanceId, () => {});
        harmonyCubeLevelTable[harmonyLevelStat.levelEnhanceId]![harmonyLevelStat.level] = harmonyLevelStat;
      }
    }
    return exists;
  }

  Future<bool> loadFavoriteItemData() async {
    final table = File(favoriteItemTableFilePath);
    final bool exists = await table.exists();
    if (exists) {
      final json = jsonDecode(await table.readAsString());
      for (final record in json['records']) {
        final favoriteItem = FavoriteItemData.fromJson(record);
        if (favoriteItem.favoriteRare == Rarity.ssr) {
          nameCodeFavItemTable[favoriteItem.nameCode] = favoriteItem;
        } else {
          dollTable.putIfAbsent(favoriteItem.weaponType, () => {});
          dollTable[favoriteItem.weaponType]![favoriteItem.favoriteRare] = favoriteItem;
        }
      }
    }
    return exists;
  }

  Future<bool> loadFavoriteItemLevelData() async {
    final table = File(favoriteItemLevelTableFilePath);
    final bool exists = await table.exists();
    if (exists) {
      final json = jsonDecode(await table.readAsString());
      for (final record in json['records']) {
        final favoriteItemStat = FavoriteItemLevelData.fromJson(record);
        favoriteItemLevelTable.putIfAbsent(favoriteItemStat.levelEnhanceId, () => {});
        favoriteItemLevelTable[favoriteItemStat.levelEnhanceId]![favoriteItemStat.level] = favoriteItemStat;
      }
    }
    return exists;
  }

  Future<bool> loadCoverStatData() async {
    final table = File(coverStatEnhanceTableFilePath);
    final bool exists = await table.exists();
    if (exists) {
      final json = jsonDecode(await table.readAsString());
      for (final record in json['records']) {
        final coverStat = CoverStatData.fromJson(record);
        coverStatTable[coverStat.lv] = coverStat;
      }
    }
    return exists;
  }

  Translation? getTranslation(String? joinedKey) {
    if (joinedKey == null) return null;

    final splits = joinedKey.split(':');
    if (splits.length != 2) return null;

    final tableType = splits[0];
    final key = splits[1];
    if (tableType == 'Locale_Character') {
      return localeCharacterTable[key];
    } else if (tableType == 'Locale_Skill') {
      return localeSkillTable[key];
    }

    return null;
  }

  EquipmentData? getEquipData(EquipType equipType, NikkeClass nikkeClass, EquipRarity rarity) {
    return groupedEquipTable[equipType]?[nikkeClass]?[rarity];
  }
}

int maxResearchLevel(int syncLevel) {
  return max(syncLevel ~/ 20 - 2, 1) * 10;
}
