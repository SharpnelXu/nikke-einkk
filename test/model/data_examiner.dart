import 'package:flutter_test/flutter_test.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/data_path.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';
import 'package:nikke_einkk/model/skills.dart';

import '../test_helper.dart';

void main() async {
  await TestHelper.loadData();

  group('Data Examine', () {
    test('funcType & status', () {
      final Set<FunctionType> types = {FunctionType.burstGaugeCharge};
      final Set<StatusTriggerType> statusTriggers = {};
      for (final function in db.functionTable.values) {
        if (types.contains(function.functionType)) {
          statusTriggers.add(function.statusTriggerType);
          statusTriggers.add(function.statusTrigger2Type);
        }
      }

      logger.i(statusTriggers);
    });

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
        };
        final Set<String?> unknownRare = {};
        final Set<String?> unknownCharacterClass = {};
        final Set<String?> unknownBurstStep = {};
        final Set<String?> unknownSkillTable = {};
        final Set<String?> unknownCorporation = {};
        final Set<String?> unknownCorporationSubType = {};
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
          recordKeys.removeAll(expectedKeys);
          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }
        });

        logger.d('Folder: $folder');
        expect(loaded, true);
        expect(unknownRare, emptySet);
        expect(unknownCharacterClass, emptySet);
        expect(unknownBurstStep, emptySet);
        expect(unknownSkillTable, emptySet);
        expect(unknownCorporation, emptySet);
        expect(unknownCorporationSubType, emptySet);
        expect(extraKeys, emptySet);
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

          recordKeys.removeAll(expectedKeys);
          if (recordKeys.isNotEmpty) {
            extraKeys.addAll(recordKeys);
          }
        });

        logger.d('Folder: $folder');
        expect(loaded, true);
        expect(unknownWeaponType, emptySet);
        expect(unknownAttackType, emptySet);
        expect(unknownPreferTarget, emptySet);
        expect(unknownPreferTargetCondition, emptySet);
        expect(unknownShotTiming, emptySet);
        expect(unknownFireType, emptySet);
        expect(unknownInputType, emptySet);
        expect(extraKeys, emptySet);
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

        logger.d('Folder: $folder');
        expect(loaded, true);
        expect(extraKeys, emptySet);
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

        logger.d('Folder: $folder');
        expect(loaded, true);
        expect(extraKeys, emptySet);
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

        logger.d('Folder: $folder');
        expect(loaded, true);
        expect(extraKeys, emptySet);
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
          for (final statJson in record['stat']) {
            final statKeys = statJson.keys.toSet();
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
          for (final slotJson in record['option_slot']) {
            final slotKeys = slotJson.keys.toSet();
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

        logger.d('Folder: $folder');
        expect(loaded, true);
        expect(unknownItemType, emptySet);
        expect(unknownEquipType, emptySet);
        expect(unknownCharacterClass, emptySet);
        expect(unknownItemRarity, emptySet);
        expect(extraKeys, emptySet);

        // Nested object assertions
        expect(unknownStatTypes, emptySet, reason: 'Unknown stat types found');
        expect(extraStatKeys, emptySet, reason: 'Extra fields in EquipmentStat');
        expect(extraOptionSlotKeys, emptySet, reason: 'Extra fields in OptionSlot');
      }
    });
  });
}
