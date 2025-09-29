import 'package:flutter_test/flutter_test.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/data_path.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';
import 'package:nikke_einkk/model/monster.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/model/stages.dart';

import '../test_helper.dart';

void main() {
  TestHelper.loadUserDb();

  group('Data Examine', () {
    // test('funcType & status', () {
    //   final Set<FunctionType> types = {FunctionType.burstGaugeCharge};
    //   final Set<StatusTriggerType> statusTriggers = {};
    //   for (final function in global.functionTable.values) {
    //     if (types.contains(function.functionType)) {
    //       statusTriggers.add(function.statusTriggerType);
    //       statusTriggers.add(function.statusTrigger2Type);
    //     }
    //   }
    //
    //   logger.i(statusTriggers);
    // });

    final globalFolder = getExtractDataFolderPath(true);
    final cnFolder = getExtractDataFolderPath(false);
    final Set<String> emptySet = Set.identity();

    test('Check NikkeCharacterData', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {
          'id',
          'name_localkey',
          'description_localkey',
          'resource_id',
          'additional_skins',
          'name_code',
          'order',
          'original_rare',
          'grade_core_id',
          'grow_grade',
          'stat_enhance_id',
          'class',
          'element_id',
          'critical_ratio',
          'critical_damage',
          'shot_id',
          'bonusrange_min',
          'bonusrange_max',
          'use_burst_skill',
          'change_burst_step',
          'burst_apply_delay',
          'burst_duration',
          'ulti_skill_id',
          'skill1_id',
          'skill1_table',
          'skill2_id',
          'skill2_table',
          'eff_category_type',
          'eff_category_value',
          'category_type_1',
          'category_type_2',
          'category_type_3',
          'corporation',
          'corporation_sub_type',
          'cv_localkey',
          'squad',
          'piece_id',
          'is_visible',
          'prism_is_active',
          'is_detail_close',
          'surface_category',
        };
        final Set<String?> unknownRare = {};
        final Set<String?> unknownCharacterClass = {};
        final Set<String?> unknownBurstStep = {};
        final Set<String?> unknownSkillTable = {};
        final Set<String?> unknownCorporation = {};
        final Set<String?> unknownCorporationSubType = {};
        final Set<String> squads = {};
        final Set<String> extraKeys = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'CharacterTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();
          final data = NikkeCharacterData.fromJson(record);
          if (data.originalRare == Rarity.unknown) {
            unknownRare.add(data.rawOriginalRare);
          }
          if (data.characterClass == NikkeClass.unknown) {
            unknownCharacterClass.add(data.rawCharacterClass);
          }
          if (data.useBurstSkill == BurstStep.unknown) {
            unknownBurstStep.add(data.rawUseBurstSkill);
          }
          if (data.changeBurstStep == BurstStep.unknown) {
            unknownBurstStep.add(data.rawChangeBurstStep);
          }
          if (data.skill1Table == SkillType.unknown) {
            unknownSkillTable.add(data.rawSkill1Table);
          }
          if (data.skill2Table == SkillType.unknown) {
            unknownSkillTable.add(data.rawSkill2Table);
          }
          if (data.corporation == Corporation.unknown) {
            unknownCorporation.add(data.rawCorporation);
          }
          if (data.corporationSubType == CorporationSubType.unknown) {
            unknownCorporationSubType.add(data.rawCorporationSubType);
          }
          squads.add(data.squad);
          recordKeys.removeAll(expectedKeys);
          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }
        });

        // print(squads);
        expect(loaded, true, reason: 'Not loaded: $folder');
        expect(unknownRare, emptySet, reason: 'unknownRare $folder');
        expect(unknownCharacterClass, emptySet, reason: 'unknownCharacterClass $folder');
        expect(unknownBurstStep, emptySet, reason: 'unknownBurstStep $folder');
        expect(unknownSkillTable, emptySet, reason: 'unknownSkillTable $folder');
        expect(unknownCorporation, emptySet, reason: 'unknownCorporation $folder');
        expect(unknownCorporationSubType, emptySet, reason: 'unknownCorporationSubType $folder');
        expect(extraKeys, emptySet, reason: 'ExtraKeys $folder');
      }
    });

    test('Check WeaponData', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {
          'id',
          'name_localkey',
          'description_localkey',
          'camera_work',
          'weapon_type',
          'attack_type',
          'counter_enermy',
          'prefer_target',
          'prefer_target_condition',
          'shot_timing',
          'fire_type',
          'input_type',
          'is_targeting',
          'damage',
          'shot_count',
          'muzzle_count',
          'multi_target_count',
          'center_shot_count',
          'max_ammo',
          'maintain_fire_stance',
          'uptype_fire_timing',
          'reload_time',
          'reload_bullet',
          'reload_start_ammo',
          'rate_of_fire_reset_time',
          'rate_of_fire',
          'end_rate_of_fire',
          'rate_of_fire_change_pershot',
          'burst_energy_pershot',
          'target_burst_energy_pershot',
          'spot_first_delay',
          'spot_last_delay',
          'start_accuracy_circle_scale',
          'end_accuracy_circle_scale',
          'accuracy_change_pershot',
          'accuracy_change_speed',
          'auto_start_accuracy_circle_scale',
          'auto_end_accuracy_circle_scale',
          'auto_accuracy_change_pershot',
          'auto_accuracy_change_speed',
          'zoom_rate',
          'multi_aim_range',
          'spot_projectile_speed',
          'charge_time',
          'full_charge_damage',
          'full_charge_burst_energy',
          'spot_radius_object',
          'spot_radius',
          'spot_explosion_range',
          'core_damage_rate',
          'penetration',
          'use_function_id_list',
          'hurt_function_id_list',
          'shake_id',
          'ShakeType',
          'ShakeWeight',
          'homing_script',
          'aim_prefab',
        };

        final Set<String?> unknownWeaponType = {};
        final Set<String?> unknownAttackType = {};
        final Set<String?> unknownPreferTarget = {};
        final Set<String?> unknownPreferTargetCondition = {};
        final Set<String?> unknownShotTiming = {};
        final Set<String?> unknownFireType = {};
        final Set<String?> unknownInputType = {};
        final Set<String> extraKeys = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'CharacterShotTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();
          final data = WeaponData.fromJson(record);

          if (data.weaponType == WeaponType.unknown) {
            unknownWeaponType.add(data.rawWeaponType);
          }
          if (data.attackType == AttackType.unknown) {
            unknownAttackType.add(data.rawAttackType);
          }
          if (data.preferTarget == PreferTarget.unknown) {
            unknownPreferTarget.add(data.rawPreferTarget);
          }
          if (data.preferTargetCondition == PreferTargetCondition.unknown) {
            unknownPreferTargetCondition.add(data.rawPreferTargetCondition);
          }
          if (data.shotTiming == ShotTiming.unknown) {
            unknownShotTiming.add(data.rawShotTiming);
          }
          if (data.fireType == FireType.unknown) {
            unknownFireType.add(data.rawFireType);
          }
          if (data.inputType == InputType.unknown) {
            unknownInputType.add(data.rawInputType);
          }
          expect(
            data.useFunctionIdList.every((funcId) => funcId == 0),
            true,
            reason: 'Shot ${data.id} has functions: $folder',
          );
          expect(
            data.hurtFunctionIdList.every((funcId) => funcId == 0),
            true,
            reason: 'Shot ${data.id} has functions: $folder',
          );

          recordKeys.removeAll(expectedKeys);
          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }
        });

        expect(loaded, true, reason: 'Not loaded: $folder');
        expect(unknownWeaponType, emptySet, reason: 'unknownWeaponType: $folder');
        expect(unknownAttackType, emptySet, reason: 'unknownAttackType: $folder');
        expect(unknownPreferTarget, emptySet, reason: 'unknownPreferTarget: $folder');
        expect(unknownPreferTargetCondition, emptySet, reason: 'unknownPreferTargetCondition: $folder');
        expect(unknownShotTiming, emptySet, reason: 'unknownShotTiming: $folder');
        expect(unknownFireType, emptySet, reason: 'unknownFireType: $folder');
        expect(unknownInputType, emptySet, reason: 'unknownInputType: $folder');
        expect(extraKeys, emptySet, reason: 'extraKeys: $folder');
      }
    });

    test('Check CharacterStatData', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {
          'id',
          'group',
          'level',
          'level_hp',
          'level_attack',
          'level_defence',
          'level_energy_resist',
          'level_metal_resist',
          'level_bio_resist',
        };

        final Set<String> extraKeys = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'CharacterStatTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();

          recordKeys.removeAll(expectedKeys);
          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }
        });

        expect(loaded, true, reason: 'loaded: $folder');
        expect(extraKeys, emptySet, reason: 'extraKeys: $folder');
      }
    });

    test('Check CharacterStatEnhanceData', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {
          'id',
          'grade_ratio',
          'grade_hp',
          'grade_attack',
          'grade_defence',
          'grade_energy_resist',
          'grade_metal_resist',
          'grade_bio_resist',
          'core_hp',
          'core_attack',
          'core_defence',
          'core_energy_resist',
          'core_metal_resist',
          'core_bio_resist',
        };

        final Set<String> extraKeys = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'CharacterStatEnhanceTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();

          recordKeys.removeAll(expectedKeys);
          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }
        });

        expect(loaded, true, reason: 'loaded: $folder');
        expect(extraKeys, emptySet, reason: 'extraKeys: $folder');
      }
    });

    test('Check AttractiveStatData', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {
          'id',
          'attractive_level',
          'attractive_point',
          'attacker_hp_rate',
          'attacker_attack_rate',
          'attacker_defence_rate',
          'attacker_energy_resist_rate',
          'attacker_metal_resist_rate',
          'attacker_bio_resist_rate',
          'defender_hp_rate',
          'defender_attack_rate',
          'defender_defence_rate',
          'defender_energy_resist_rate',
          'defender_metal_resist_rate',
          'defender_bio_resist_rate',
          'supporter_hp_rate',
          'supporter_attack_rate',
          'supporter_defence_rate',
          'supporter_energy_resist_rate',
          'supporter_metal_resist_rate',
          'supporter_bio_resist_rate',
        };

        final Set<String> extraKeys = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'AttractiveLevelTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();

          recordKeys.removeAll(expectedKeys);
          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }
        });

        expect(loaded, true, reason: 'loaded: $folder');
        expect(extraKeys, emptySet, reason: 'extraKeys: $folder');
      }
    });

    test('Check EquipmentData with nested objects', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {
          'id',
          'name_localkey',
          'description_localkey',
          'resource_id',
          'item_type',
          'item_sub_type',
          'class',
          'item_rare',
          'grade_core_id',
          'grow_grade',
          'stat',
          'option_slot',
          'option_cost',
          'option_change_cost',
          'option_lock_cost',
        };

        // For EquipmentStat validation
        final statExpectedKeys = {'stat_type', 'stat_value'};
        final Set<String?> unknownStatTypes = {};
        final Set<String> extraStatKeys = {};

        // For OptionSlot validation
        final optionSlotExpectedKeys = {'option_slot', 'option_slot_success_ratio'};
        final Set<String> extraOptionSlotKeys = {};

        // Main object validations
        final Set<String?> unknownItemType = {};
        final Set<String?> unknownEquipType = {};
        final Set<String?> unknownCharacterClass = {};
        final Set<String?> unknownItemRarity = {};
        final Set<String> extraKeys = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'ItemEquipTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();
          final data = EquipmentData.fromJson(record);

          // Validate main object
          if (data.itemType == ItemType.unknown) {
            unknownItemType.add(data.rawItemType);
          }
          if (data.itemSubType == EquipType.unknown) {
            unknownEquipType.add(data.rawItemSubType);
          }
          if (data.characterClass == NikkeClass.unknown) {
            unknownCharacterClass.add(data.rawCharacterClass);
          }
          if (data.itemRarity == EquipRarity.unknown) {
            unknownItemRarity.add(data.rawItemRarity);
          }

          // Validate EquipmentStat objects
          for (final statJson in record['stat'] as List) {
            final statKeys = (statJson as Map<String, dynamic>).keys.toSet();
            final stat = EquipmentStat.fromJson(statJson);
            if (stat.statType == StatType.unknown) {
              unknownStatTypes.add(stat.rawStatType);
            }
            statKeys.removeAll(statExpectedKeys);
            if (statKeys.isNotEmpty) {
              extraStatKeys.addAll(statKeys);
            }
          }

          // Validate OptionSlot objects
          for (final slotJson in record['option_slot'] as List) {
            final slotKeys = (slotJson as Map<String, dynamic>).keys.toSet();
            slotKeys.removeAll(optionSlotExpectedKeys);
            if (slotKeys.isNotEmpty) {
              extraOptionSlotKeys.addAll(slotKeys);
            }
          }

          recordKeys.removeAll(expectedKeys);
          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }
        });

        expect(loaded, true, reason: 'loaded: $folder');
        expect(unknownItemType, emptySet, reason: 'unknownItemType: $folder');
        expect(unknownEquipType, emptySet, reason: 'unknownEquipType: $folder');
        expect(unknownCharacterClass, emptySet, reason: 'unknownCharacterClass: $folder');
        expect(unknownItemRarity, emptySet, reason: 'unknownItemRarity: $folder');
        expect(extraKeys, emptySet, reason: 'extraKeys: $folder');

        // Nested object assertions
        expect(unknownStatTypes, emptySet, reason: 'Unknown stat types found: $folder');
        expect(extraStatKeys, emptySet, reason: 'Extra fields in EquipmentStat: $folder');
        expect(extraOptionSlotKeys, emptySet, reason: 'Extra fields in OptionSlot: $folder');
      }
    });

    test('Check HarmonyCubeData with nested objects', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {
          'id',
          'name_localkey',
          'description_localkey',
          'location_id',
          'location_localkey',
          'order',
          'resource_id',
          'bg',
          'bg_color',
          'item_type',
          'item_sub_type',
          'item_rare',
          'class',
          'level_enhance_id',
          'harmonycube_skill_group',
        };

        // For HarmonyCubeSkillGroup validation
        final skillGroupExpectedKeys = {'skill_group_id'};
        final Set<String> extraSkillGroupKeys = {};

        // Main object validations
        final Set<String?> unknownItemType = {};
        final Set<String?> unknownRarity = {};
        final Set<String?> unknownCharacterClass = {};
        final Set<String> extraKeys = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'ItemHarmonyCubeTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();
          final data = HarmonyCubeData.fromJson(record);

          // Validate main object
          if (data.itemType == ItemType.unknown) {
            unknownItemType.add(data.rawItemType);
          }
          if (data.itemRare == Rarity.unknown) {
            unknownRarity.add(data.rawItemRare);
          }
          if (data.characterClass == NikkeClass.unknown) {
            unknownCharacterClass.add(data.rawCharacterClass);
          }

          // Validate HarmonyCubeSkillGroup objects
          for (final skillGroupJson in record['harmonycube_skill_group'] as List) {
            final skillGroupKeys = (skillGroupJson as Map<String, dynamic>).keys.toSet();
            skillGroupKeys.removeAll(skillGroupExpectedKeys);
            if (skillGroupKeys.isNotEmpty) {
              extraSkillGroupKeys.addAll(skillGroupKeys);
            }
          }

          recordKeys.removeAll(expectedKeys);
          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }
        });

        expect(loaded, true, reason: 'extraKeys: $folder');
        expect(unknownItemType, emptySet, reason: 'unknownItemType: $folder');
        expect(unknownRarity, emptySet, reason: 'unknownRarity: $folder');
        expect(unknownCharacterClass, emptySet, reason: 'unknownCharacterClass: $folder');
        expect(extraKeys, emptySet, reason: 'extraKeys: $folder');
        expect(extraSkillGroupKeys, emptySet, reason: 'Extra fields in HarmonyCubeSkillGroup: $folder');
      }
    });

    test('Check HarmonyCubeLevelData with nested objects', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {
          'id',
          'level_enhance_id',
          'level',
          'skill_levels',
          'material_id',
          'material_value',
          'gold_value',
          'slot',
          'harmonycube_stats',
        };

        // For HarmonyCubeSkillLevel validation
        final skillLevelExpectedKeys = {'skill_level'};
        final Set<String> extraSkillLevelKeys = {};

        // For HarmonyCubeStat validation
        final statExpectedKeys = {'stat_type', 'stat_rate'};
        final Set<String?> unknownStatTypes = {};
        final Set<String> extraStatKeys = {};

        // Main object validations
        final Set<String> extraKeys = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'ItemHarmonyCubeLevelTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();

          // Validate HarmonyCubeSkillLevel objects
          for (final skillLevelJson in record['skill_levels'] as List) {
            final skillLevelKeys = (skillLevelJson as Map<String, dynamic>).keys.toSet();
            skillLevelKeys.removeAll(skillLevelExpectedKeys);
            if (skillLevelKeys.isNotEmpty) {
              extraSkillLevelKeys.addAll(skillLevelKeys);
            }
          }

          // Validate HarmonyCubeStat objects
          for (final statJson in record['harmonycube_stats'] as List) {
            final statKeys = (statJson as Map<String, dynamic>).keys.toSet();
            final stat = HarmonyCubeStat.fromJson(statJson);
            if (stat.type == StatType.unknown) {
              unknownStatTypes.add(stat.rawType);
            }
            statKeys.removeAll(statExpectedKeys);
            if (statKeys.isNotEmpty) {
              extraStatKeys.addAll(statKeys);
            }
          }

          recordKeys.removeAll(expectedKeys);
          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }
        });

        expect(loaded, true, reason: 'loaded: $folder');
        expect(extraKeys, emptySet, reason: 'extraKeys: $folder');

        // Nested object assertions
        expect(extraSkillLevelKeys, emptySet, reason: 'Extra fields in HarmonyCubeSkillLevel: $folder');
        expect(unknownStatTypes, emptySet, reason: 'Unknown stat types in HarmonyCubeStat: $folder');
        expect(extraStatKeys, emptySet, reason: 'Extra fields in HarmonyCubeStat: $folder');
      }
    });

    test('Check FavoriteItemData with nested objects', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {
          'id',
          'name_localkey',
          'description_localkey',
          'icon_resource_id',
          'img_resource_id',
          'prop_resource_id',
          'order',
          'favorite_rare',
          'favorite_type',
          'weapon_type',
          'name_code',
          'max_level',
          'level_enhance_id',
          'probability_group',
          'collection_skill_group_data',
          'favoriteitem_skill_group_data',
          'albumcategory_id',
        };

        // For CollectionItemSkillGroup validation
        final collectionSkillExpectedKeys = {'collection_skill_id'};
        final Set<String> extraCollectionSkillKeys = {};

        // For FavoriteItemSkillGroup validation
        final favoriteSkillExpectedKeys = {'favorite_skill_id', 'skill_table', 'skill_change_slot'};
        final Set<String?> unknownSkillTables = {};
        final Set<String> extraFavoriteSkillKeys = {};

        // Main object validations
        final Set<String?> unknownRarity = {};
        final Set<String?> unknownFavoriteType = {};
        final Set<String?> unknownWeaponType = {};
        final Set<String> extraKeys = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'FavoriteItemTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();
          final data = FavoriteItemData.fromJson(record);

          // Validate main object enums
          if (data.favoriteRare == Rarity.unknown) {
            unknownRarity.add(data.rawFavoriteRare);
          }
          if (data.favoriteType == FavoriteItemType.unknown) {
            unknownFavoriteType.add(data.rawFavoriteType);
          }
          if (data.weaponType == WeaponType.unknown) {
            unknownWeaponType.add(data.rawWeaponType);
          }

          // Validate CollectionItemSkillGroup objects
          for (final skillJson in record['collection_skill_group_data'] as List) {
            final skillKeys = (skillJson as Map<String, dynamic>).keys.toSet();
            skillKeys.removeAll(collectionSkillExpectedKeys);
            if (skillKeys.isNotEmpty) {
              extraCollectionSkillKeys.addAll(skillKeys);
            }
          }

          // Validate FavoriteItemSkillGroup objects
          for (final skillJson in record['favoriteitem_skill_group_data'] as List) {
            final skillKeys = (skillJson as Map<String, dynamic>).keys.toSet();
            final skill = FavoriteItemSkillGroup.fromJson(skillJson);
            if (skill.skillTable == SkillType.unknown) {
              unknownSkillTables.add(skill.rawSkillTable);
            }
            skillKeys.removeAll(favoriteSkillExpectedKeys);
            if (skillKeys.isNotEmpty) {
              extraFavoriteSkillKeys.addAll(skillKeys);
            }
          }

          recordKeys.removeAll(expectedKeys);
          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }
        });

        expect(loaded, true, reason: 'loaded: $folder');
        expect(unknownRarity, emptySet, reason: 'unknownRarity: $folder');
        expect(unknownFavoriteType, emptySet, reason: 'unknownFavoriteType: $folder');
        expect(unknownWeaponType, emptySet, reason: 'unknownWeaponType: $folder');
        expect(extraKeys, emptySet, reason: 'extraKeys: $folder');

        // Nested object assertions
        expect(extraCollectionSkillKeys, emptySet, reason: 'Extra fields in CollectionItemSkillGroup: $folder');
        expect(unknownSkillTables, emptySet, reason: 'Unknown skill tables in FavoriteItemSkillGroup: $folder');
        expect(extraFavoriteSkillKeys, emptySet, reason: 'Extra fields in FavoriteItemSkillGroup: $folder');
      }
    });

    test('Check FavoriteItemLevelData with nested objects', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {
          'id',
          'level_enhance_id',
          'grade',
          'level',
          'favoriteitem_stat_data',
          'collection_skill_level_data',
        };

        // For CollectionItemSkillLevel validation
        final skillLevelExpectedKeys = {'collection_skill_level'};
        final Set<String> extraSkillLevelKeys = {};

        // For FavoriteItemStat validation
        final statExpectedKeys = {'stat_type', 'stat_value'};
        final Set<String?> unknownStatTypes = {};
        final Set<String> extraStatKeys = {};

        // Main object validations
        final Set<String> extraKeys = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'FavoriteItemLevelTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();

          // Validate CollectionItemSkillLevel objects
          for (final skillLevelJson in record['collection_skill_level_data'] as List) {
            final skillLevelKeys = (skillLevelJson as Map<String, dynamic>).keys.toSet();
            skillLevelKeys.removeAll(skillLevelExpectedKeys);
            if (skillLevelKeys.isNotEmpty) {
              extraSkillLevelKeys.addAll(skillLevelKeys);
            }
          }

          // Validate FavoriteItemStat objects
          for (final statJson in record['favoriteitem_stat_data'] as List) {
            final statKeys = (statJson as Map<String, dynamic>).keys.toSet();
            final stat = FavoriteItemStat.fromJson(statJson);
            if (stat.type == StatType.unknown) {
              unknownStatTypes.add(stat.rawType);
            }
            statKeys.removeAll(statExpectedKeys);
            if (statKeys.isNotEmpty) {
              extraStatKeys.addAll(statKeys);
            }
          }

          recordKeys.removeAll(expectedKeys);
          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }
        });

        expect(loaded, true, reason: 'loaded: $folder');
        expect(extraKeys, emptySet, reason: 'extraKeys: $folder');

        // Nested object assertions
        expect(extraSkillLevelKeys, emptySet, reason: 'Extra fields in CollectionItemSkillLevel: $folder');
        expect(unknownStatTypes, emptySet, reason: 'Unknown stat types in FavoriteItemStat: $folder');
        expect(extraStatKeys, emptySet, reason: 'Extra fields in FavoriteItemStat: $folder');
      }
    });

    test('Check SkillData with nested objects', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {
          'id',
          'skill_cooltime',
          'attack_type',
          'counter_type',
          'prefer_target',
          'prefer_target_condition',
          'skill_type',
          'skill_value_data',
          'duration_type',
          'duration_value',
          'before_use_function_id_list',
          'before_hurt_function_id_list',
          'after_use_function_id_list',
          'after_hurt_function_id_list',
          'resource_name',
          'icon',
          'shake_id',
        };

        // For SkillValueData validation
        final skillValueExpectedKeys = {'skill_value_type', 'skill_value'};
        final Set<String?> unknownValueTypes = {};
        final Set<String> extraSkillValueKeys = {};

        // Main object validations
        final Set<String?> unknownAttackType = {};
        final Set<String?> unknownPreferTarget = {};
        final Set<String?> unknownPreferTargetCondition = {};
        final Set<String?> unknownSkillType = {};
        final Set<String?> unknownDurationType = {};
        final Set<String> extraKeys = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'CharacterSkillTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();
          final data = SkillData.fromJson(record);

          // Validate main object enums
          if (data.attackType == AttackType.unknown) {
            unknownAttackType.add(data.rawAttackType);
          }
          if (data.preferTarget == PreferTarget.unknown) {
            unknownPreferTarget.add(data.rawPreferTarget);
          }
          if (data.preferTargetCondition == PreferTargetCondition.unknown) {
            unknownPreferTargetCondition.add(data.rawPreferTargetCondition);
          }
          if (data.skillType == CharacterSkillType.unknown) {
            unknownSkillType.add(data.rawSkillType);
          }
          if (data.durationType == DurationType.unknown) {
            unknownDurationType.add(data.rawDurationType);
          }

          // Validate SkillValueData objects
          for (final valueDataJson in record['skill_value_data'] as List) {
            final valueDataKeys = (valueDataJson as Map<String, dynamic>).keys.toSet();
            final valueData = SkillValueData.fromJson(valueDataJson);
            if (valueData.skillValueType == ValueType.unknown) {
              unknownValueTypes.add(valueData.rawSkillValueType);
            }
            valueDataKeys.removeAll(skillValueExpectedKeys);
            if (valueDataKeys.isNotEmpty) {
              extraSkillValueKeys.addAll(valueDataKeys);
            }
          }

          recordKeys.removeAll(expectedKeys);
          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }
        });

        expect(loaded, true, reason: 'loaded: $folder');
        expect(unknownAttackType, emptySet, reason: 'unknownAttackType: $folder');
        expect(unknownPreferTarget, emptySet, reason: 'unknownPreferTarget: $folder');
        expect(unknownPreferTargetCondition, emptySet, reason: 'unknownPreferTargetCondition: $folder');
        expect(unknownSkillType, emptySet, reason: 'unknownSkillType: $folder');
        expect(unknownDurationType, emptySet, reason: 'unknownDurationType: $folder');
        expect(extraKeys, emptySet, reason: 'extraKeys: $folder');

        // Nested object assertions
        expect(unknownValueTypes, emptySet, reason: 'Unknown value types in SkillValueData: $folder');
        expect(extraSkillValueKeys, emptySet, reason: 'Extra fields in SkillValueData: $folder');
      }
    });

    test('Check StateEffectData with nested objects', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {'id', 'use_function_id_list', 'hurt_function_id_list', 'functions', 'icon'};

        // For SkillFunction validation
        final skillFunctionExpectedKeys = {'function'};
        final Set<String> extraSkillFunctionKeys = {};

        // Main object validations
        final Set<String> extraKeys = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'StateEffectTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();

          // Validate CollectionItemSkillLevel objects
          for (final skillFuncJson in record['functions'] as List) {
            final skillLevelKeys = (skillFuncJson as Map<String, dynamic>).keys.toSet();
            skillLevelKeys.removeAll(skillFunctionExpectedKeys);
            if (skillLevelKeys.isNotEmpty) {
              extraSkillFunctionKeys.addAll(skillLevelKeys);
            }
          }

          recordKeys.removeAll(expectedKeys);
          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }
        });

        expect(loaded, true, reason: 'loaded: $folder');
        expect(extraKeys, emptySet, reason: 'extraKeys: $folder');

        // Nested object assertions
        expect(extraSkillFunctionKeys, emptySet, reason: 'Extra fields in SkillFunction: $folder');
      }
    });

    test('Check FunctionData with nested objects', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {
          'id',
          'group_id',
          'level',
          'name_localkey',
          'buff',
          'buff_remove',
          'function_type',
          'function_value_type',
          'function_standard',
          'function_value',
          'full_count',
          'is_cancel',
          'delay_type',
          'delay_value',
          'duration_type',
          'duration_value',
          'limit_value',
          'function_target',
          'timing_trigger_type',
          'timing_trigger_standard',
          'timing_trigger_value',
          'status_trigger_type',
          'status_trigger_standard',
          'status_trigger_value',
          'status_trigger2_type',
          'status_trigger2_standard',
          'status_trigger2_value',
          'keeping_type',
          'buff_icon',
          'shot_fx_list_type',
          'fx_prefab_01',
          'fx_target_01',
          'fx_socket_point_01',
          'fx_prefab_02',
          'fx_target_02',
          'fx_socket_point_02',
          'fx_prefab_03',
          'fx_target_03',
          'fx_socket_point_03',
          'fx_prefab_full',
          'fx_target_full',
          'fx_socket_point_full',
          'fx_prefab_01_arena',
          'fx_target_01_arena',
          'fx_socket_point_01_arena',
          'fx_prefab_02_arena',
          'fx_target_02_arena',
          'fx_socket_point_02_arena',
          'fx_prefab_03_arena',
          'fx_target_03_arena',
          'fx_socket_point_03_arena',
          'connected_function',
          'description_localkey',
          'element_reaction_icon',
          'function_battlepower',
        };

        // Enum validation sets
        final Set<String?> unknownBuffTypes = {};
        final Set<String?> unknownBuffRemoveTypes = {};
        final Set<String?> unknownFunctionTypes = {};
        final Set<String?> unknownValueTypes = {};
        final Set<String?> unknownStandardTypes = {};
        final Set<String?> unknownDelayTypes = {};
        final Set<String?> unknownDurationTypes = {};
        final Set<String?> unknownFunctionTargets = {};
        final Set<String?> unknownTimingTriggers = {};
        final Set<String?> unknownStatusTriggers = {};
        final Set<String?> unknownKeepingTypes = {};

        final Set<String> sockets = {};
        final Set<String> fxTargets = {};
        final Set<String> shotTypes = {};

        final Set<String> extraKeys = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'FunctionTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();
          final data = FunctionData.fromJson(record);

          // Validate all enum fields
          if (data.buff == BuffType.unknown) unknownBuffTypes.add(data.rawBuffType);
          if (data.buffRemove == BuffRemoveType.unknown) unknownBuffRemoveTypes.add(data.rawBuffRemove);
          if (data.functionType == FunctionType.unknown) unknownFunctionTypes.add(data.rawFunctionType);
          if (data.functionValueType == ValueType.unknown) unknownValueTypes.add(data.rawFunctionValueType);
          if (data.functionStandard == StandardType.unknown) unknownStandardTypes.add(data.rawFunctionStandard);
          if (data.delayType == DurationType.unknown) unknownDelayTypes.add(data.rawDelayType);
          if (data.durationType == DurationType.unknown) unknownDurationTypes.add(data.rawDurationType);
          if (data.functionTarget == FunctionTargetType.unknown) unknownFunctionTargets.add(data.rawFunctionTarget);
          if (data.timingTriggerType == TimingTriggerType.unknown) unknownTimingTriggers.add(data.rawTimingTriggerType);
          if (data.timingTriggerStandard == StandardType.unknown) {
            unknownStandardTypes.add(data.rawTimingTriggerStandard);
          }
          if (data.statusTriggerType == StatusTriggerType.unknown) unknownStatusTriggers.add(data.rawStatusTriggerType);
          if (data.statusTriggerStandard == StandardType.unknown) {
            unknownStandardTypes.add(data.rawStatusTriggerStandard);
          }
          if (data.statusTrigger2Type == StatusTriggerType.unknown) {
            unknownStatusTriggers.add(data.rawStatusTrigger2Type);
          }
          if (data.statusTrigger2Standard == StandardType.unknown) {
            unknownStandardTypes.add(data.rawStatusTrigger2Standard);
          }
          if (data.keepingType == FunctionStatus.unknown) unknownKeepingTypes.add(data.rawKeepingType);

          if (data.functionType == FunctionType.durationValueChange) {
            expect(data.statusTriggerType, StatusTriggerType.isFunctionOn, reason: 'Assumption violated');
            expect(data.functionValueType, ValueType.integer, reason: 'Assumption violated');
          }

          if (data.shotFxListType?.isNotEmpty == true) shotTypes.add(data.shotFxListType!);
          if (data.fxSocketPoint01?.isNotEmpty == true) sockets.add(data.fxSocketPoint01!);
          if (data.fxSocketPoint02?.isNotEmpty == true) sockets.add(data.fxSocketPoint02!);
          if (data.fxSocketPoint03?.isNotEmpty == true) sockets.add(data.fxSocketPoint03!);
          if (data.fxSocketPointFull?.isNotEmpty == true) sockets.add(data.fxSocketPointFull!);
          if (data.fxSocketPoint01Arena?.isNotEmpty == true) sockets.add(data.fxSocketPoint01Arena!);
          if (data.fxSocketPoint02Arena?.isNotEmpty == true) sockets.add(data.fxSocketPoint02Arena!);
          if (data.fxSocketPoint03Arena?.isNotEmpty == true) sockets.add(data.fxSocketPoint03Arena!);
          if (data.fxTarget01?.isNotEmpty == true) fxTargets.add(data.fxTarget01!);
          if (data.fxTarget02?.isNotEmpty == true) fxTargets.add(data.fxTarget02!);
          if (data.fxTarget03?.isNotEmpty == true) fxTargets.add(data.fxTarget03!);
          if (data.fxTargetFull?.isNotEmpty == true) fxTargets.add(data.fxTargetFull!);
          if (data.fxTarget01Arena?.isNotEmpty == true) fxTargets.add(data.fxTarget01Arena!);
          if (data.fxTarget02Arena?.isNotEmpty == true) fxTargets.add(data.fxTarget02Arena!);
          if (data.fxTarget03Arena?.isNotEmpty == true) fxTargets.add(data.fxTarget03Arena!);

          // Check for extra fields
          recordKeys.removeAll(expectedKeys);
          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }
        });

        // print('ShotTypes: $shotTypes');
        // print('FxTargets: $fxTargets');
        // print('Sockets: $sockets');

        expect(loaded, true, reason: 'loaded: $folder');

        // Main enum validations
        expect(unknownBuffTypes, emptySet, reason: 'Unknown buff types: $folder');
        expect(unknownBuffRemoveTypes, emptySet, reason: 'Unknown buff remove types: $folder');
        expect(unknownFunctionTypes, emptySet, reason: 'Unknown function types: $folder');
        expect(unknownValueTypes, emptySet, reason: 'Unknown value types: $folder');
        expect(unknownStandardTypes, emptySet, reason: 'Unknown standard types: $folder');
        expect(unknownDelayTypes, emptySet, reason: 'Unknown delay types: $folder');
        expect(unknownDurationTypes, emptySet, reason: 'Unknown duration types: $folder');
        expect(unknownFunctionTargets, emptySet, reason: 'Unknown function targets: $folder');
        expect(unknownTimingTriggers, emptySet, reason: 'Unknown timing triggers: $folder');
        expect(unknownStatusTriggers, emptySet, reason: 'Unknown status triggers: $folder');
        expect(unknownKeepingTypes, emptySet, reason: 'Unknown keeping types: $folder');

        // Structural validation
        expect(extraKeys, emptySet, reason: 'Extra fields found: $folder');
      }
    });

    test('Check SkillInfoData with nested description values', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {
          'id',
          'group_id',
          'skill_level',
          'next_level_id',
          'level_up_cost_id',
          'icon',
          'name_localkey',
          'description_localkey',
          'info_description_localkey',
          'description_value_list',
        };

        // For SkillDescriptionValue validation
        final descriptionValueExpectedKeys = {'description_value'};
        final Set<String> extraDescriptionValueKeys = {};

        final Set<String> extraKeys = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'SkillInfoTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();

          // Validate nested description values
          for (final valueJson in record['description_value_list'] as List) {
            final valueKeys = (valueJson as Map<String, dynamic>).keys.toSet();
            valueKeys.removeAll(descriptionValueExpectedKeys);
            if (valueKeys.isNotEmpty) {
              extraDescriptionValueKeys.addAll(valueKeys);
            }
          }

          // Check for extra keys in main object
          recordKeys.removeAll(expectedKeys);
          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }
        });

        expect(loaded, true, reason: 'loaded: $folder');
        expect(extraKeys, emptySet, reason: 'Extra fields in SkillInfoData: $folder');
        expect(extraDescriptionValueKeys, emptySet, reason: 'Extra fields in SkillDescriptionValue: $folder');
      }
    });

    test('Check WaveData with nested WavePathData and WaveMonster objects', () {
      for (final folder in [globalFolder, cnFolder]) {
        final Set<String> waveFiles = {};
        final waveLoaded = loadCsv(
          getDesignatedDirectory(folder, 'WaveData.Group.csv'),
          (data) => waveFiles.add(data.first),
        );
        expect(waveLoaded, true, reason: 'waves not loaded for $folder');

        final expectedKeys = {
          'stage_id',
          'group_id',
          'spot_mod',
          'battle_time',
          'monster_count',
          'use_intro_scene',
          'wave_repeat',
          'point_data',
          'point_data_fly',
          'background_name',
          'theme',
          'theme_time',
          'stage_info_bg',
          'target_list',
          'wave_data',
          'close_monster_count',
          'mid_monster_count',
          'far_monster_count',
          'mod_value',
          'ui_theme',
        };

        final wavePathExpectedKeys = {'wave_path', 'wave_monster_list', 'private_monster_count'};
        final waveMonsterExpectedKeys = {'wave_monster_id', 'spawn_type'};

        final Set<String> spotMod = {};
        final Set<String> uiTheme = {};
        final Set<String> theme = {};
        final Set<String> themeTime = {};

        for (final waveFile in waveFiles) {
          final Set<String> extraWaveDataKeys = {};
          final Set<String> extraWavePathKeys = {};
          final Set<String> extraWaveMonsterKeys = {};

          final loaded = loadData(getDesignatedDirectory(folder, 'WaveDataTable.$waveFile.json'), (record) {
            final recordKeys = (record as Map<String, dynamic>).keys.toSet();
            final data = WaveData.fromJson(record);
            spotMod.add(data.spotMod);
            if (data.uiTheme != null) uiTheme.add(data.uiTheme!);
            theme.add(data.theme);
            themeTime.add(data.themeTime);

            // Validate WavePathData
            for (final pathJson in record['wave_data'] as List) {
              final pathMap = pathJson as Map<String, dynamic>;
              final pathKeys = pathMap.keys.toSet();

              // Validate WaveMonster inside WavePathData
              for (final monsterJson in pathMap['wave_monster_list'] as List) {
                final monsterMap = monsterJson as Map<String, dynamic>;
                final monsterKeys = monsterMap.keys.toSet();

                monsterKeys.removeAll(waveMonsterExpectedKeys);
                if (monsterKeys.isNotEmpty) {
                  extraWaveMonsterKeys.addAll(monsterKeys);
                }
              }

              pathKeys.removeAll(wavePathExpectedKeys);
              if (pathKeys.isNotEmpty) {
                extraWavePathKeys.addAll(pathKeys);
              }
            }

            // Check for unexpected fields at the WaveData level
            recordKeys.removeAll(expectedKeys);
            if (recordKeys.isNotEmpty) {
              extraWaveDataKeys.addAll(recordKeys);
            }
          });

          // expect(loaded, true, reason: 'loaded: $folder, $waveFile');
          expect(extraWaveDataKeys, emptySet, reason: 'Unexpected fields in $waveFile: $folder');
          expect(extraWavePathKeys, emptySet, reason: 'Unexpected fields in WavePathData of $waveFile: $folder');
          expect(extraWaveMonsterKeys, emptySet, reason: 'Unexpected fields in WaveMonster of $waveFile: $folder');
        }

        logger.i('WaveData spotMod: $spotMod');
        logger.i('WaveData uiTheme: $uiTheme');
        logger.i('WaveData theme: $theme');
        logger.i('WaveData themeTime: $themeTime');
      }
    });

    test('Check UnionRaidWaveData fields', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {
          'id',
          'preset_group_id',
          'difficulty_type',
          'wave_order',
          'wave',
          'wave_change_step',
          'monster_stage_lv',
          'monster_stage_lv_change_group',
          'dynamic_object_stage_lv',
          'cover_stage_lv',
          'spot_autocontrol',
          'wave_name',
          'wave_description',
          'monster_image_si',
          'monster_image',
          'monster_spine_scale',
          'reward_id',
        };

        final Set<String> extraKeys = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'UnionRaidPresetTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();

          recordKeys.removeAll(expectedKeys);
          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }
        });

        expect(loaded, true, reason: 'Not loaded: $folder');
        expect(extraKeys, emptySet, reason: 'Unexpected fields in UnionRaidWaveData, $folder');
      }
    });

    test('Check SoloRaidWaveData fields', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {
          'id',
          'preset_group_id',
          'difficulty_type',
          'quick_battle_type',
          'character_lv',
          'wave_open_condition',
          'wave_order',
          'wave',
          'monster_stage_lv',
          'monster_stage_lv_change_group',
          'dynamic_object_stage_lv',
          'cover_stage_lv',
          'spot_autocontrol',
          'wave_name',
          'wave_description',
          'monster_image_si',
          'monster_image',
          'first_clear_reward_id',
          'reward_id',
        };

        final Set<String> extraKeys = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'SoloRaidPresetTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();

          recordKeys.removeAll(expectedKeys);
          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }
        });

        expect(loaded, true, reason: 'loaded: $folder');
        expect(extraKeys, emptySet, reason: 'Unexpected fields in SoloRaidWaveData: $folder');
      }
    });

    test('Check MonsterData with nested MonsterSkillInfoData', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {
          'id',
          'element_id',
          'monster_model_id',
          'name_localkey',
          'appearance_localkey',
          'description_localkey',
          'is_irregular',
          'hp_ratio',
          'attack_ratio',
          'defence_ratio',
          'energy_resist_ratio',
          'metal_resist_ratio',
          'bio_resist_ratio',
          'detector_center',
          'detector_radius',
          'nonetarget',
          'functionnonetarget',
          'spot_ai',
          'spot_ai_defense',
          'spot_ai_basedefense',
          'spot_move_speed',
          'spot_acceleration_time',
          'fixed_spawn_type',
          'spot_rand_ratio_normal',
          'spot_rand_ratio_jump',
          'spot_rand_ratio_drop',
          'spot_rand_ratio_dash',
          'spot_rand_ratio_teleport',
          'skill_data',
          'statenhance_id',
          'ui_grade',
          'passive_skill_id',
        };

        final skillDataExpectedKeys = {'skill_id', 'use_function_id_skill', 'hurt_function_id_skill'};

        final Set<String> extraMonsterKeys = {};
        final Set<String> extraSkillKeys = {};
        final Set<String> targetType = {};
        final Set<String> spawnType = {};
        final Set<String> grade = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'MonsterTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();

          final monster = MonsterData.fromJson(record);
          targetType.add(monster.nonetarget);
          targetType.add(monster.functionnonetarget);
          spawnType.add(monster.fixedSpawnType);
          if (monster.uiGrade != null) {
            grade.add(monster.uiGrade!);
          }

          // Validate nested MonsterSkillInfoData
          for (final skillJson in record['skill_data'] as List) {
            final skillMap = skillJson as Map<String, dynamic>;
            final skillKeys = skillMap.keys.toSet();

            skillKeys.removeAll(skillDataExpectedKeys);
            if (skillKeys.isNotEmpty) {
              extraSkillKeys.addAll(skillKeys);
            }
          }

          recordKeys.removeAll(expectedKeys);
          if (recordKeys.isNotEmpty) {
            extraMonsterKeys.addAll(recordKeys);
          }
        });

        logger.i('Monster TargetType: $targetType');
        logger.i('Monster SpawnType: $spawnType');
        logger.i('Monster Grade: $grade');
        expect(loaded, true, reason: 'loaded: $folder');
        expect(extraMonsterKeys, emptySet, reason: 'Unexpected fields in MonsterData: $folder');
        expect(extraSkillKeys, emptySet, reason: 'Unexpected fields in MonsterSkillInfoData: $folder');
      }
    });

    test('Check MonsterStatEnhanceData fields', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {
          'id',
          'group_id',
          'lv',
          'level_hp',
          'level_attack',
          'level_defence',
          'level_statdamageratio',
          'level_energy_resist',
          'level_metal_resist',
          'level_bio_resist',
          'level_projectile_hp',
          'level_broken_hp',
        };

        final Set<String> extraKeys = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'MonsterStatEnhanceTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();

          recordKeys.removeAll(expectedKeys);
          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }
        });

        expect(loaded, true, reason: 'loaded: $folder');
        expect(extraKeys, emptySet, reason: 'Unexpected fields in MonsterStatEnhanceData: $folder');
      }
    });

    test('Check MonsterPartData fields', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {
          'id',
          'monster_model_id',
          'parts_name_localkey',
          'damage_hp_ratio',
          'hp_ratio',
          'attack_ratio',
          'defence_ratio',
          'energy_resist_ratio',
          'metal_resist_ratio',
          'bio_resist_ratio',
          'destroy_after_anim',
          'destroy_after_movable',
          'passive_skill_id',
          'visible_hp',
          'linked_parts_id',
          'weapon_object',
          'weapon_object_enum',
          'parts_type',
          'parts_object',
          'parts_skin',
          'monster_destroy_anim_trigger',
          'is_main_part',
          'is_parts_damage_able',
        };

        final Set<String> extraKeys = {};
        final Set<String> monsterParts = {};
        final Set<String> destroyTrigger = {};
        final Set<String> weaponObjectEnum = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'MonsterPartsTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();

          final monsterPart = MonsterPartData.fromJson(record);
          monsterParts.add(monsterPart.partsType);
          destroyTrigger.add(monsterPart.destroyAnimTrigger);
          weaponObjectEnum.addAll(monsterPart.weaponObjectEnums);
          recordKeys.removeAll(expectedKeys);
          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }
        });

        logger.i(monsterParts);
        logger.i(destroyTrigger);
        logger.i(weaponObjectEnum);
        expect(loaded, true, reason: 'loaded: $folder');
        expect(extraKeys, emptySet, reason: 'Unexpected fields in MonsterPartData: $folder');
      }
    });

    test('Check MonsterStageLevelChangeData fields', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {
          'id',
          'group',
          'step',
          'condition_type',
          'condition_value_min',
          'condition_value_max',
          'monster_stage_lv',
          'passive_skill_id',
          'target_passive_skill_id',
          'gimmickobject_lv_control',
        };

        final Set<String> extraKeys = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'MonsterStageLvChangeTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();

          recordKeys.removeAll(expectedKeys);
          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }
        });

        expect(loaded, true, reason: 'loaded: $folder');
        expect(extraKeys, emptySet, reason: 'Unexpected fields in MonsterStageLevelChangeData: $folder');
      }
    });

    test('Check MonsterSkillData with enums and unexpected fields', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {
          'id',
          'name_localkey',
          'description_localkey',
          'skill_icon',
          'skill_ani_number',
          'weapon_type',
          'prefer_target',
          'show_lock_on',
          'attack_type',
          'fire_type',
          'casting_time',
          'break_object',
          'break_object_hp_raito',
          'skill_value_type_01',
          'skill_value_01',
          'skill_value_type_02',
          'skill_value_02',
          'shot_count',
          'delay_time',
          'shot_timing',
          'penetration',
          'projectile_speed',
          'projectile_hp_ratio',
          'projectile_def_ratio',
          'projectile_radius_object',
          'projectile_radius',
          'spot_explosion_range',
          'is_destroyable_projectile',
          'relate_anim',
          'deceleration_rate',
          'target_character_ratio',
          'target_cover_ratio',
          'target_nothing_ratio',
          'calling_group_id',
          'target_count',
          'object_resource',
          'object_position_type',
          'object_position',
          'is_using_timeline',
          'control_gauge',
          'control_parts',
          'weapon_object_enum',
          'linked_parts',
          'cancel_type',
          'move_object',
        };

        final Set<String?> unknownPreferTargets = {};
        final Set<String?> unknownAttackTypes = {};
        final Set<String?> unknownFireTypes = {};
        final Set<String?> unknownValueTypes = {};
        final Set<String> extraKeys = {};
        final Set<String> weaponTypes = {};
        final Set<String> preferTargets = {};
        final Set<String> attackType = {};
        final Set<String> fireType = {};
        final Set<String> shotTiming = {};
        final Set<String> objectPositions = {};
        final Set<String> cancelType = {};
        final Set<String> linkedParts = {};
        final Set<String> skillAnimeNumbers = {};
        final Set<String> skillValueType = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'MonsterSkillTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();
          final data = MonsterSkillData.fromJson(record);

          weaponTypes.add(data.weaponType);
          preferTargets.add(data.rawPreferTarget);
          attackType.add(data.rawAttackType);
          fireType.add(data.rawFireType);
          shotTiming.add(data.shotTiming);
          objectPositions.add(data.objectPositionType);
          skillAnimeNumbers.add(data.animationNumber);
          skillValueType.add(data.rawSkillValueType1);
          skillValueType.add(data.rawSkillValueType2);
          if (data.cancelType != null) {
            cancelType.add(data.cancelType!);
          }
          if (data.linkedParts != null) {
            linkedParts.add(data.linkedParts!);
          }

          // Enum validations
          if (data.preferTarget == PreferTarget.unknown) {
            unknownPreferTargets.add(data.rawPreferTarget);
          }
          if (data.attackType == AttackType.unknown) {
            unknownAttackTypes.add(data.rawAttackType);
          }
          if (data.fireType == FireType.unknown) {
            unknownFireTypes.add(data.rawFireType);
          }
          if (data.skillValueType1 == ValueType.unknown) {
            unknownValueTypes.add(data.rawSkillValueType1);
          }
          if (data.skillValueType2 == ValueType.unknown) {
            unknownValueTypes.add(data.rawSkillValueType2);
          }

          recordKeys.removeAll(expectedKeys);
          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }
        });

        logger.i('WeaponTypes in $folder: $weaponTypes');
        logger.i('PreferTargets in $folder: $preferTargets');
        logger.i('AttackTypes in $folder: $attackType');
        logger.i('FireTypes in $folder: $fireType');
        logger.i('ShotTiming in $folder: $shotTiming');
        logger.i('ObjectPositions in $folder: $objectPositions');
        logger.i('CancelType in $folder: $cancelType');
        logger.i('LinkedParts in $folder: $linkedParts');
        logger.i('SkillAnimeNumbers in $folder: $skillAnimeNumbers');
        logger.i('SkillValueTypes in $folder: $skillValueType');

        expect(loaded, true, reason: 'loaded: $folder');
        expect(unknownPreferTargets, emptySet, reason: 'Unknown PreferTarget: $folder');
        expect(unknownAttackTypes, emptySet, reason: 'Unknown AttackType: $folder');
        expect(unknownFireTypes, emptySet, reason: 'Unknown FireType: $folder');
        expect(unknownValueTypes, emptySet, reason: 'Unknown ValueType: $folder');
        expect(extraKeys, emptySet, reason: 'Unexpected keys in MonsterSkillData: $folder');
      }
    });

    test('Check WordGroupData unexpected fields', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {'id', 'group', 'page_number', 'order', 'resource_type', 'resource_value'};

        final Set<String> extraKeys = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'WordTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();
          recordKeys.removeAll(expectedKeys);

          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }
        });

        expect(loaded, true, reason: 'loaded: $folder');
        expect(extraKeys, emptySet, reason: 'Unexpected keys in WordGroupData: $folder');
      }
    });

    test('WordGroup description parsing', () {
      locale.loadGeneral('Locale_Skill');
      final labelRegex = RegExp(r'\{(\w+)\}');
      final tagRegex = RegExp(r'<(\w+)(=.+)?>');
      final Set<String> labelSet = {};
      final Set<String> tagSet = {};
      for (final transl in locale.locale['Locale_Skill']!.values) {
        for (final str in [transl.en, transl.zhCN, transl.ja, transl.ko]) {
          for (final match in labelRegex.allMatches(str)) {
            labelSet.add(match[1]!);
          }
          for (final match in tagRegex.allMatches(str)) {
            tagSet.add(match[1]!);
          }
        }
      }

      final expectedLabels = {
        'description_value_01',
        'description_value_02',
        'description_value_03',
        'description_value_04',
        'description_value_05',
        'description_value_06',
        'description_value_07',
        'description_value_08',
        'description_value_09',
        'description_value_10',
        'description_value_11',
        'function_dec_value01',
        'function_dec_value02',
        'function_value01',
        'function_value02',
        'duration_value01', // not used
        'duration_value02', // not used
        'damage',
        'core_damage_rate',
        'charge_time',
        'full_charge_damage',
      };
      final expectedTags = {'color', 'word_group'};

      expect(labelSet, expectedLabels, reason: 'Unexpected description value');
      expect(tagSet, expectedTags, reason: 'Unexpected tags');
    });

    test('Check MultiplayerRaidData unexpected fields', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {
          'id',
          'name',
          'player_count',
          'character_select_time_limit',
          'character_lv',
          'stage_level',
          'monster_stage_lv',
          'dynamic_object_stage_lv',
          'cover_stage_lv',
          'monster_stage_lv_change_group',
          'spot_id',
          'condition_reward_group',
          'reward_limit_count',
          'rank_condition_reward_group',
          'monster_stage_lv_change_group_easy',
          'spot_id_easy',
        };

        final Set<String> extraKeys = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'MultiRaidTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();
          recordKeys.removeAll(expectedKeys);

          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }
        });

        expect(loaded, true, reason: 'loaded: $folder');
        expect(extraKeys, emptySet, reason: 'Unexpected keys in MultiplayerRaidData: $folder');
      }
    });

    test('Check PackageListData unexpected fields', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {
          'id',
          'package_shop_id',
          'package_order',
          'product_id',
          'name_localkey',
          'description_localkey',
          'product_resource_id',
          'buy_limit_type',
          'is_limit',
          'buy_limit_count',
          'is_active',
        };

        final Set<String> extraKeys = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'PackageListTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();
          recordKeys.removeAll(expectedKeys);

          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }

          PackageListData.fromJson(record);
        });

        expect(loaded, true, reason: 'loaded: $folder');
        expect(extraKeys, emptySet, reason: 'Unexpected keys in PackageListData: $folder');
      }
    });

    test('Check InAppShopData unexpected fields', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {
          'id',
          'main_category_type',
          'order_group_id',
          'name_localkey',
          'description_localkey',
          'main_category_icon_name',
          'sub_category_id',
          'sub_category_name_localkey',
          'package_shop_id',
          'is_hide_if_not_valid',
          'renew_type',
          'start_date',
          'end_date',
          'date_ui_control',
          'shop_type',
          'shop_category',
          'shop_prefab_name',
        };

        final Set<String> extraKeys = {};
        final Set<String?> unknownCategory = {};
        final Set<String> mainCategoryTypes = {};
        final Set<String> renewTypes = {};
        final Set<String> shopTypes = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'InAppShopManagerTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();
          recordKeys.removeAll(expectedKeys);

          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }

          final data = InAppShopData.fromJson(record);
          if (data.shopCategory == ShopCategory.unknown) {
            unknownCategory.add(data.rawShopCategory);
          }
          mainCategoryTypes.add(data.mainCategoryType);
          renewTypes.add(data.renewType);
          shopTypes.add(data.shopType);
        });

        // print(shopTypes);
        expect(loaded, true, reason: 'loaded: $folder');
        expect(extraKeys, emptySet, reason: 'Unexpected keys in InAppShopData: $folder');
        expect(unknownCategory, isEmpty, reason: 'Unknown shop category: $folder');
      }
    });

    test('Check PackageProductData unexpected fields', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {'id', 'package_group_id', 'product_type', 'product_id', 'product_value'};

        final Set<String> extraKeys = {};
        final Set<String?> unknownCategory = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'PackageGroupTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();
          recordKeys.removeAll(expectedKeys);

          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }

          final data = PackageProductData.fromJson(record);
          if (data.productType == ProductType.unknown) {
            unknownCategory.add(data.rawProductType);
          }
        });

        expect(loaded, true, reason: 'loaded: $folder');
        expect(extraKeys, emptySet, reason: 'Unexpected keys in PackageProductData: $folder');
        expect(unknownCategory, isEmpty, reason: 'Unknown product type: $folder');
      }
    });

    test('Check CurrencyData unexpected fields', () {
      for (final folder in [globalFolder, cnFolder]) {
        final expectedKeys = {
          'id',
          'name_localkey',
          'description_localkey',
          'resource_id',
          'is_visible_to_inventory',
          'max_value',
        };

        final Set<String> extraKeys = {};

        final loaded = loadData(getDesignatedDirectory(folder, 'CurrencyTable.json'), (record) {
          final recordKeys = (record as Map<String, dynamic>).keys.toSet();
          recordKeys.removeAll(expectedKeys);

          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }

          CurrencyData.fromJson(record);
        });

        expect(loaded, true, reason: 'loaded: $folder');
        expect(extraKeys, emptySet, reason: 'Unexpected keys in CurrencyData: $folder');
      }
    });

    test('Shop Redirect Tests', () {
      for (final folder in [globalFolder, cnFolder]) {
        bool loaded = loadData(getDesignatedDirectory(folder, 'CustomPackageShopTable.json'), (record) {
          final data = CustomPackageShopData.fromJson(record);
          expect(data.customGroupId, data.packageGroupId, reason: '$folder: custom package shop data mismatch');
        });

        // loaded &= loadData(getDesignatedDirectory(folder, 'StepUpPackageShopTable.json'), (record) {
        //   expect(record['package_shop_id'], record['stepup_group_id'], reason: '$folder: step up shop data mismatch');
        // });

        expect(loaded, true, reason: 'loaded: $folder');
      }
    });

    test('ItemConsumeTable Enum check', () {
      for (final folder in [globalFolder]) {
        final Set<String> useConditionTypes = {};
        final Set<String> itemTypes = {};
        final Set<String> itemSubTypes = {};
        final Set<String> itemRares = {};
        final Set<String> useTypes = {};
        final Set<String> percentDisplayTypes = {};
        bool loaded = loadData(getDesignatedDirectory(folder, 'ItemConsumeTable.json'), (record) {
          useConditionTypes.add(record['use_condition_type'] as String);
          itemTypes.add(record['item_type'] as String);
          itemSubTypes.add(record['item_sub_type'] as String);
          itemRares.add(record['item_rare'] as String);
          useTypes.add(record['use_type'] as String);
          percentDisplayTypes.add(record['percent_display_type'] as String);
        });

        logger.i('useConditionTypes=$useConditionTypes');
        logger.i('itemTypes=$itemTypes');
        logger.i('itemSubTypes=$itemSubTypes');
        logger.i('itemRares=$itemRares');
        logger.i('useTypes=$useTypes');
        logger.i('percentDisplayTypes=$percentDisplayTypes');
      }
    });

    test('ItemMaterialTable Enum check', () {
      for (final folder in [globalFolder]) {
        final Set<String> itemTypes = {};
        final Set<String> itemSubTypes = {};
        final Set<String> itemRares = {};
        final Set<String> materialTypes = {};
        bool loaded = loadData(getDesignatedDirectory(folder, 'ItemMaterialTable.json'), (record) {
          itemTypes.add(record['item_type'] as String);
          itemSubTypes.add(record['item_sub_type'] as String);
          itemRares.add(record['item_rare'] as String);
          materialTypes.add(record['material_type'] as String);
        });

        logger.i('itemTypes=$itemTypes');
        logger.i('itemSubTypes=$itemSubTypes');
        logger.i('itemRares=$itemRares');
        logger.i('materialTypes=$materialTypes');
      }
    });

    test('ItePieceTable Enum check', () {
      for (final folder in [globalFolder]) {
        final Set<String> itemTypes = {};
        final Set<String> itemSubTypes = {};
        final Set<String> itemRares = {};
        final Set<String> useTypes = {};
        final Set<String> nikkeClasses = {};
        bool loaded = loadData(getDesignatedDirectory(folder, 'ItemPieceTable.json'), (record) {
          itemTypes.add(record['item_type'] as String);
          itemSubTypes.add(record['item_sub_type'] as String);
          itemRares.add(record['item_rare'] as String);
          useTypes.add(record['use_type'] as String);
          nikkeClasses.add(record['class'] as String);
        });

        logger.i('itemTypes=$itemTypes');
        logger.i('itemSubTypes=$itemSubTypes');
        logger.i('itemRares=$itemRares');
        logger.i('useTypes=$useTypes');
        logger.i('class=$nikkeClasses');
      }
    });

    test('MidasProductTable Enum check', () {
      for (final folder in [globalFolder]) {
        final Set<String> itemTypes = {};
        final Set<String> productTypes = {};
        bool loaded = loadData(getDesignatedDirectory(folder, 'MidasProductTable.json'), (record) {
          itemTypes.add(record['item_type'] as String);
          productTypes.add(record['product_type'] as String);
        });

        logger.i('itemTypes=$itemTypes');
        logger.i('productTypes=$productTypes');
      }
    });
  });
}
