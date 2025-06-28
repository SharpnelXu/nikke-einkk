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
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';

/// db object
final dbLegacy = NikkeDatabase();

final locale = Locale();
final global = NikkeDatabaseV2(true);
final cn = NikkeDatabaseV2(false);
final userDb = UserDatabase();
late PackageInfo packageInfo;

final Logger logger = Logger();

enum Language { unknown, ko, en, ja, zhTW, zhCN, th, de, fr, debug }

class Locale {
  Language language = Language.en;

  final Map<String, Map<String, Translation>> locale = {};

  bool init() {
    locale.clear();

    bool result = true;
    result &= loadGeneral('Locale_Character');
    result &= loadGeneral('Locale_Skill');
    result &= loadGeneral('Locale_System');
    result &= loadGeneral('Locale_Monster');
    result &= loadGeneral('Locale_Item');

    logger.i('Locale init result: $result');

    return result;
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
    if (language == Language.debug) return joinedKey;
    if (joinedKey == null) return null;

    final splits = joinedKey.split(':');
    if (splits.length != 2) return null;

    String tableType = splits[0];
    if (tableType == 'Locale_BeforeInstall') {
      tableType = 'Locale_Character';
    }
    final key = splits[1];
    return locale[tableType]?[key]?.forLanguage(language);
  }
}

class NikkeDatabaseV2 {
  bool isGlobal = true;
  bool initialized = false;

  String get server => isGlobal ? 'Global' : 'CN';

  NikkeDatabaseV2(this.isGlobal);

  int maxSyncLevel = 1;
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
  final Map<int, MonsterSkillData> monsterSkillTable = {};
  final Map<int, Map<int, NikkeCharacterData>> characterResourceGardeTable = {};
  final Map<int, WeaponData> characterShotTable = {};
  final Map<int, SkillData> characterSkillTable = {};
  final Map<int, SkillInfoData> skillInfoTable = {};
  final Map<String, List<WordGroupData>> wordGroupTable = {};
  final Map<int, CoverStatData> coverStatTable = {};
  final Map<int, Map<int, SkillInfoData>> groupedSkillInfoTable = {}; // grouped by skillGroupId, skillLevel
  final Map<int, Map<int, CharacterStatData>> groupedCharacterStatTable = {};
  final Map<int, CharacterStatEnhanceData> characterStatEnhanceTable = {};
  final Map<int, AttractiveStatData> attractiveStatTable = {};
  final Map<EquipType, Map<NikkeClass, Map<EquipRarity, EquipmentData>>> groupedEquipTable = {};
  final Map<WeaponType, Map<Rarity, FavoriteItemData>> dollTable = {};
  final Map<int, FavoriteItemData> nameCodeFavItemTable = {};
  final Map<int, Map<int, FavoriteItemLevelData>> favoriteItemLevelTable = {};
  final Map<int, HarmonyCubeData> harmonyCubeTable = {};
  final Map<int, Map<int, HarmonyCubeLevelData>> harmonyCubeEnhanceLvTable = {};

  final Map<int, Set<CharacterSkillType>> nameCodeSkillTypes = {};
  final Map<int, Set<FunctionType>> nameCodeFuncTypes = {};
  final Map<int, Set<TimingTriggerType>> nameCodeTimingTypes = {};
  final Map<int, Set<StatusTriggerType>> nameCodeStatusTypes = {};

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
    monsterSkillTable.clear();
    characterResourceGardeTable.clear();
    characterShotTable.clear();
    characterSkillTable.clear();
    skillInfoTable.clear();
    wordGroupTable.clear();
    nameCodeFavItemTable.clear();
    nameCodeSkillTypes.clear();
    nameCodeFuncTypes.clear();
    nameCodeTimingTypes.clear();
    nameCodeStatusTypes.clear();
    groupedCharacterStatTable.clear();
    groupedEquipTable.clear();
    harmonyCubeTable.clear();
    harmonyCubeEnhanceLvTable.clear();
    groupedSkillInfoTable.clear();

    final extractFolderPath = getExtractDataFolderPath(isGlobal);
    String directory(String fileName) {
      return getDesignatedDirectory(extractFolderPath, fileName);
    }

    initialized = true;
    initialized &= loadData(directory('UnionRaidPresetTable.json'), processUnionRaidWaveData);
    initialized &= loadData(directory('MonsterTable.json'), processRaptureData);
    initialized &= loadData(directory('MonsterPartsTable.json'), processRapturePartData);
    initialized &= loadData(directory('MonsterStatEnhanceTable.json'), processMonsterStatEnhanceData);
    initialized &= loadData(directory('MonsterStageLvChangeTable.json'), processMonsterStageLvChangeData);
    initialized &= loadData(directory('SoloRaidPresetTable.json'), processSoloRaidWaveData);
    initialized &= loadData(directory('StateEffectTable.json'), processStateEffectData);
    initialized &= loadData(directory('FunctionTable.json'), processFunctionData);
    initialized &= loadData(directory('MonsterSkillTable.json'), processMonsterSkillData);
    initialized &= loadData(directory('CharacterTable.json'), processCharacterData);
    initialized &= loadData(directory('CharacterShotTable.json'), processCharacterShotData);
    initialized &= loadData(directory('CharacterSkillTable.json'), processCharacterSkillData);
    initialized &= loadData(directory('SkillInfoTable.json'), processSkillInfoData);
    initialized &= loadData(directory('WordTable.json'), processWordGroupData);
    initialized &= loadData(directory('FavoriteItemTable.json'), processDollData);
    initialized &= loadData(directory('CharacterStatTable.json'), processCharacterStatData);
    initialized &= loadData(directory('ItemEquipTable.json'), processEquipData);
    initialized &= loadData(directory('ItemHarmonyCubeTable.json'), processCubeData);
    initialized &= loadData(directory('ItemHarmonyCubeLevelTable.json'), processCubeLevelData);

    initialized &= loadCsv(directory('WaveData.GroupDict.csv'), processWaveDict);

    if (initialized) {
      _buildFilterTable();
    }
  }

  void _buildFilterTable() {
    for (final characterData in characterResourceGardeTable.values.map((entry) => entry.values.first)) {
      nameCodeSkillTypes.putIfAbsent(characterData.nameCode, () => {});
      nameCodeFuncTypes.putIfAbsent(characterData.nameCode, () => {});
      nameCodeTimingTypes.putIfAbsent(characterData.nameCode, () => {});
      nameCodeStatusTypes.putIfAbsent(characterData.nameCode, () => {});
      final skillTypes = nameCodeSkillTypes[characterData.nameCode]!;
      final funcTypes = nameCodeFuncTypes[characterData.nameCode]!;
      final timingTypes = nameCodeTimingTypes[characterData.nameCode]!;
      final statusTypes = nameCodeStatusTypes[characterData.nameCode]!;
      _processSkill(characterData.skill1Id, characterData.skill1Table, skillTypes, funcTypes, timingTypes, statusTypes);
      _processSkill(characterData.skill2Id, characterData.skill2Table, skillTypes, funcTypes, timingTypes, statusTypes);
      _processActiveSkill(characterData.ultiSkillId, skillTypes, funcTypes, timingTypes, statusTypes);

      final favItem = nameCodeFavItemTable[characterData.nameCode];
      if (favItem != null) {
        for (final favSkill in favItem.favoriteItemSkills) {
          _processSkill(favSkill.skillId, favSkill.skillTable, skillTypes, funcTypes, timingTypes, statusTypes);
        }
      }
    }
  }

  void _processSkill(
    int skillId,
    SkillType type,
    Set<CharacterSkillType> skillTypes,
    Set<FunctionType> funcTypes,
    Set<TimingTriggerType> timingTypes,
    Set<StatusTriggerType> statusTypes,
  ) {
    if (type == SkillType.characterSkill) {
      _processActiveSkill(skillId, skillTypes, funcTypes, timingTypes, statusTypes);
    } else {
      _processPassiveSkill(skillId, skillTypes, funcTypes, timingTypes, statusTypes);
    }
  }

  void _processPassiveSkill(
    int skillId,
    Set<CharacterSkillType> skillTypes,
    Set<FunctionType> funcTypes,
    Set<TimingTriggerType> timingTypes,
    Set<StatusTriggerType> statusTypes,
  ) {
    final skillData = stateEffectTable[skillId];
    if (skillData != null) {
      for (final funcId in skillData.allValidFuncIds) {
        _processFunc(funcId, skillTypes, funcTypes, timingTypes, statusTypes);
      }
    }
  }

  void _processActiveSkill(
    int skillId,
    Set<CharacterSkillType> skillTypes,
    Set<FunctionType> funcTypes,
    Set<TimingTriggerType> timingTypes,
    Set<StatusTriggerType> statusTypes,
  ) {
    final skillData = characterSkillTable[skillId];
    if (skillData == null) {
      skillTypes.add(CharacterSkillType.unknown);
      return;
    }

    skillTypes.add(skillData.skillType);
    for (final funcId in skillData.allValidFuncIds) {
      _processFunc(funcId, skillTypes, funcTypes, timingTypes, statusTypes);
    }
  }

  void _processFunc(
    int funcId,
    Set<CharacterSkillType> skillTypes,
    Set<FunctionType> funcTypes,
    Set<TimingTriggerType> timingTypes,
    Set<StatusTriggerType> statusTypes,
  ) {
    final func = functionTable[funcId];
    if (func == null) {
      funcTypes.add(FunctionType.unknown);
      return;
    }

    funcTypes.add(func.functionType);
    timingTypes.add(func.timingTriggerType);
    statusTypes.add(func.statusTriggerType);
    statusTypes.add(func.statusTrigger2Type);
    if (func.functionType == FunctionType.useCharacterSkillId) {
      _processActiveSkill(func.functionValue, skillTypes, funcTypes, timingTypes, statusTypes);
    }

    for (final funcId in func.connectedFunction.where((funcId) => funcId != 0)) {
      _processFunc(funcId, skillTypes, funcTypes, timingTypes, statusTypes);
    }
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

  void processMonsterSkillData(dynamic record) {
    final data = MonsterSkillData.fromJson(record);
    monsterSkillTable[data.id] = data;
  }

  void processCharacterData(dynamic record) {
    final data = NikkeCharacterData.fromJson(record);

    if (data.resourceId == 16) {
      data.elementId.add(NikkeElement.iron.id);
    }

    characterResourceGardeTable.putIfAbsent(data.resourceId, () => {});
    characterResourceGardeTable[data.resourceId]![data.gradeCoreId] = data;
  }

  void processCharacterShotData(dynamic record) {
    final data = WeaponData.fromJson(record);
    characterShotTable[data.id] = data;
  }

  void processCharacterSkillData(dynamic record) {
    final data = SkillData.fromJson(record);
    characterSkillTable[data.id] = data;
  }

  void processSkillInfoData(dynamic record) {
    final data = SkillInfoData.fromJson(record);
    skillInfoTable[data.id] = data;
    groupedSkillInfoTable.putIfAbsent(data.groupId, () => {});
    groupedSkillInfoTable[data.groupId]![data.skillLevel] = data;
  }

  void processWordGroupData(dynamic record) {
    final data = WordGroupData.fromJson(record);
    wordGroupTable.putIfAbsent(data.group, () => []);
    wordGroupTable[data.group]!.add(data);
  }

  void processDollData(dynamic record) {
    final data = FavoriteItemData.fromJson(record);
    if (data.favoriteRare == Rarity.ssr) {
      nameCodeFavItemTable[data.nameCode] = data;
    }
  }

  void processCharacterStatData(dynamic record) {
    final stat = CharacterStatData.fromJson(record);
    groupedCharacterStatTable.putIfAbsent(stat.group, () => {});
    groupedCharacterStatTable[stat.group]![stat.level] = stat;
    maxSyncLevel = max(maxSyncLevel, stat.level);
  }

  void processEquipData(dynamic record) {
    final equip = EquipmentData.fromJson(record);
    if (equip.characterClass == NikkeClass.unknown) return;

    groupedEquipTable.putIfAbsent(equip.itemSubType, () => {});
    groupedEquipTable[equip.itemSubType]!.putIfAbsent(equip.characterClass, () => {});
    groupedEquipTable[equip.itemSubType]![equip.characterClass]![equip.itemRarity] = equip;
  }

  void processCubeData(dynamic record) {
    final data = HarmonyCubeData.fromJson(record);
    harmonyCubeTable[data.id] = data;
  }

  void processCubeLevelData(dynamic record) {
    final data = HarmonyCubeLevelData.fromJson(record);
    harmonyCubeEnhanceLvTable.putIfAbsent(data.levelEnhanceId, () => {});
    harmonyCubeEnhanceLvTable[data.levelEnhanceId]![data.level] = data;
  }
}

class UserDatabase {
  bool initialized = false;
  final Map<String, String> customizeDirectory = {};
  UserData userData = UserData();
  bool useGlobal = true;

  NikkeDatabaseV2 get gameDb => useGlobal ? global : cn;

  String directory(String fileName) {
    return join(userDataPath, fileName);
  }

  void init() {
    customizeDirectory.clear();

    initialized = true;
    initialized &= loadCsv(directory('DataDirectory.csv'), processCustomizeDirectory);
    initialized &= loadRawData(directory('userData.json'), processUserData);
  }

  void processUserData(dynamic record) {
    final data = UserData.fromJson(record);
    userData = data;
    locale.language = userData.language;
  }

  void processCustomizeDirectory(List<String> data) {
    if (data.length == 2) {
      final prefix = data.first;
      final folder = data.last;
      customizeDirectory[prefix] = folder;
    }
  }

  void save() {
    final userDataFile = File(directory('userData.json'));
    if (!userDataFile.parent.existsSync()) {
      userDataFile.parent.createSync(recursive: true);
    }
    userData.language = locale.language;
    final jsonEncoder = JsonEncoder.withIndent('  ');
    userDataFile.writeAsStringSync(jsonEncoder.convert(userData.toJson()));
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

bool loadRawData(String filePath, void Function(dynamic) process) {
  final table = File(filePath);
  final exists = table.existsSync();
  if (exists) {
    process(jsonDecode(table.readAsStringSync()));
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
  final Map<int, SkillInfoData> skillInfoTable = {};
  final Map<String, Translation> localeCharacterTable = {};
  final Map<String, Translation> localeSkillTable = {};

  final Map<int, HarmonyCubeData> harmonyCubeTable = {};
  final Map<int, CoverStatData> coverStatTable = {};
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
