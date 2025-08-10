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
final locale = Locale();
final global = NikkeDatabase(true);
final cn = NikkeDatabase(false);
final userDb = UserDatabase();
final constData = GameConstants();
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
    result &= loadGeneral('Locale_InAppShopProduct');

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

class GameConstants {
  final rangeCorrection = 3000;
  final fullBurstCorrection = 5000;
  final baseElementRate = 11000;
  final burstMeterCap = 1000000; // 9000 = 0.9%
  final sameBurstStageCd = 50; // 0.5 seconds
  final fullCountLimit = 999999; // assume all full counter greater than this is a function group
  final damageBurstApplyDelay = 100; // 1 second
}

class NikkeDatabase {
  bool isGlobal = true;
  bool initialized = false;

  String get server => isGlobal ? 'Global' : 'CN';

  NikkeDatabase(this.isGlobal);

  int maxSyncLevel = 1;
  final Map<int, List<UnionRaidWaveData>> unionRaidData = {}; // key is presetId
  final Map<int, List<SoloRaidWaveData>> soloRaidData = {}; // key is presetId
  final Map<int, MultiplayerRaidData> coopRaidData = {};
  final Map<int, String> waveGroupDict = {};
  final Map<String, Map<int, WaveData>> waveData = {};
  final Map<int, MonsterData> raptureData = {};
  final Map<int, List<MonsterPartData>> rapturePartData = {}; // key is modelId
  final Map<int, Map<int, MonsterStatEnhanceData>> monsterStatEnhanceData = {}; // key is groupId, lv
  final Map<int, List<MonsterStageLevelChangeData>> monsterStageLvChangeData = {};
  final Map<int, MonsterSkillData> monsterSkillTable = {};

  final Map<int, Map<int, NikkeCharacterData>> characterResourceGardeTable = {};
  final Map<int, WeaponData> characterShotTable = {};
  final Map<int, SkillData> characterSkillTable = {};
  final Map<int, StateEffectData> stateEffectTable = {};
  final Map<int, FunctionData> functionTable = {};
  final Map<int, SkillInfoData> skillInfoTable = {};
  final Map<int, Map<int, SkillInfoData>> groupedSkillInfoTable = {}; // grouped by skillGroupId, skillLevel
  final Map<String, List<WordGroupData>> wordGroupTable = {};
  final Map<int, CoverStatData> coverStatTable = {};
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

  final Set<FunctionType> onShotFunctionTypes = {};
  final Set<FunctionType> onHitFunctionTypes = {};

  // shops & items
  final Map<int, List<InAppShopData>> inAppShopManager = {}; // orderGroupId as key
  final Map<int, List<PackageListData>> packageListData = {}; // packageShopId as key
  final Map<int, List<PackageProductData>> packageGroupData = {}; // package_group_id as key
  final Map<int, CurrencyData> currencyTable = {};
  final Map<int, SimplifiedItemData> simplifiedItemTable = {};

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
    characterStatEnhanceTable.clear();
    attractiveStatTable.clear();
    coverStatTable.clear();
    dollTable.clear();
    favoriteItemLevelTable.clear();
    coopRaidData.clear();
    packageListData.clear();
    inAppShopManager.clear();
    packageGroupData.clear();
    currencyTable.clear();
    simplifiedItemTable.clear();

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
    initialized &= loadData(directory('CharacterStatEnhanceTable.json'), processCharacterStatEnhanceData);
    initialized &= loadData(directory('CoverStatEnhanceTable.json'), processCoverStatData);
    initialized &= loadData(directory('AttractiveLevelTable.json'), processAttractiveLevelTable);
    initialized &= loadData(directory('FavoriteItemLevelTable.json'), processFavoriteItemLevelData);
    initialized &= loadData(directory('MultiRaidTable.json'), processCoopRaidData);
    initialized &= loadData(directory('PackageListTable.json'), processPackageListData);
    initialized &= loadData(directory('InAppShopManagerTable.json'), processInAppShopData);
    initialized &= loadData(directory('PackageGroupTable.json'), processPackageGroupData);
    initialized &= loadData(directory('CurrencyTable.json'), processCurrencyData);
    initialized &= loadData(directory('ItemConsumeTable.json'), processSimplifiedItemData);
    initialized &= loadData(directory('ItemEquipTable.json'), processSimplifiedItemData);
    initialized &= loadData(directory('ItemHarmonyCubeTable.json'), processSimplifiedItemData);
    initialized &= loadData(directory('ItemMaterialTable.json'), processSimplifiedItemData);
    initialized &= loadData(directory('ItemPieceTable.json'), processSimplifiedItemData);

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

  WaveData? getWaveData(int? stageId) {
    if (stageId == null) return null;

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

    if (data.durationType.isShots) {
      onShotFunctionTypes.add(data.functionType);
    }
    if (data.durationType.isHits) {
      onHitFunctionTypes.add(data.functionType);
    }
  }

  void processMonsterSkillData(dynamic record) {
    final data = MonsterSkillData.fromJson(record);
    monsterSkillTable[data.id] = data;
  }

  void processCharacterData(dynamic record) {
    final data = NikkeCharacterData.fromJson(record);

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
    } else {
      dollTable.putIfAbsent(data.weaponType, () => {});
      dollTable[data.weaponType]![data.favoriteRare] = data;
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

  void processCharacterStatEnhanceData(dynamic record) {
    final data = CharacterStatEnhanceData.fromJson(record);
    characterStatEnhanceTable[data.id] = data;
  }

  void processCoverStatData(dynamic record) {
    final data = CoverStatData.fromJson(record);
    coverStatTable[data.lv] = data;
  }

  void processAttractiveLevelTable(dynamic record) {
    final data = AttractiveStatData.fromJson(record);
    attractiveStatTable[data.attractiveLevel] = data;
  }

  void processFavoriteItemLevelData(dynamic record) {
    final data = FavoriteItemLevelData.fromJson(record);
    favoriteItemLevelTable.putIfAbsent(data.levelEnhanceId, () => {});
    favoriteItemLevelTable[data.levelEnhanceId]![data.level] = data;
  }

  void processCoopRaidData(dynamic record) {
    final data = MultiplayerRaidData.fromJson(record);
    coopRaidData[data.id] = data;
  }

  void processPackageListData(dynamic record) {
    final data = PackageListData.fromJson(record);
    packageListData.putIfAbsent(data.packageShopId, () => []);
    packageListData[data.packageShopId]!.add(data);
  }

  void processInAppShopData(dynamic record) {
    final data = InAppShopData.fromJson(record);
    inAppShopManager.putIfAbsent(data.orderGroupId, () => []);
    inAppShopManager[data.orderGroupId]!.add(data);
  }

  void processPackageGroupData(dynamic record) {
    final data = PackageProductData.fromJson(record);
    packageGroupData.putIfAbsent(data.packageGroupId, () => []);
    packageGroupData[data.packageGroupId]!.add(data);
  }

  void processCurrencyData(dynamic record) {
    final data = CurrencyData.fromJson(record);
    currencyTable[data.id] = data;
  }

  void processSimplifiedItemData(dynamic record) {
    final data = SimplifiedItemData.fromJson(record);
    simplifiedItemTable[data.id] = data;
  }
}

class UserDatabase {
  bool initialized = false;
  final Map<String, String> customizeDirectory = {};
  UserData userData = UserData();
  bool useGlobal = true;

  PlayerOptions get playerOptions => useGlobal ? userData.globalPlayerOptions : userData.cnPlayerOptions;
  Map<int, NikkeOptions> get nikkeOptions => useGlobal ? userData.globalNikkeOptions : userData.cnNikkeOptions;
  Map<int, int> get cubeLvs => useGlobal ? userData.globalCubeLvs : userData.cnCubeLvs;

  NikkeDatabase get gameDb => useGlobal ? global : cn;

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

int maxResearchLevel(int syncLevel) {
  return max(syncLevel ~/ 20 - 2, 1) * 10;
}
