import 'package:json_annotation/json_annotation.dart';

import 'common.dart';

part '../generated/model/items.g.dart';

// ItemEquipTable
@JsonSerializable()
class EquipmentItemData {
  final int id;
  @JsonKey(name: 'name_localkey')
  final String nameLocalkey;
  @JsonKey(name: 'description_localkey')
  final String descriptionLocalkey;
  @JsonKey(name: 'resource_id')
  final String resourceId;
  @JsonKey(name: 'item_type')
  final ItemType itemType;
  @JsonKey(name: 'item_sub_type')
  final EquipType itemSubType;
  @JsonKey(name: 'class')
  final NikkeClass characterClass;
  @JsonKey(name: 'item_rare')
  final EquipRarity itemRarity;
  @JsonKey(name: 'grade_core_id')
  final int gradeCoreId;
  @JsonKey(name: 'grow_grade')
  final int growGrade;
  final List<EquipmentStat> stat;
  @JsonKey(name: 'option_slot')
  final List<OptionSlot> optionSlots;
  @JsonKey(name: 'option_cost')
  final int optionCost;
  @JsonKey(name: 'option_change_cost')
  final int optionChangeCost;
  @JsonKey(name: 'option_lock_cost')
  final int optionLockCost;

  EquipmentItemData({
    this.id = 0,
    this.nameLocalkey = '',
    this.descriptionLocalkey = '',
    this.resourceId = '',
    this.itemType = ItemType.equip,
    this.itemSubType = EquipType.unknown,
    this.characterClass = NikkeClass.unknown,
    this.itemRarity = EquipRarity.unknown,
    this.gradeCoreId = 0,
    this.growGrade = 0,
    this.stat = const [],
    this.optionSlots = const [],
    this.optionCost = 0,
    this.optionChangeCost = 0,
    this.optionLockCost = 0,
  });

  factory EquipmentItemData.fromJson(Map<String, dynamic> json) => _$EquipmentItemDataFromJson(json);

  Map<String, dynamic> toJson() => _$EquipmentItemDataToJson(this);
}

@JsonSerializable()
class EquipmentStat {
  final StatType statType;
  final int statValue;

  EquipmentStat({this.statType = StatType.none, this.statValue = 0});

  factory EquipmentStat.fromJson(Map<String, dynamic> json) => _$EquipmentStatFromJson(json);

  Map<String, dynamic> toJson() => _$EquipmentStatToJson(this);
}

@JsonSerializable()
class OptionSlot {
  final int optionSlot;
  final int optionSlotSuccessRatio;

  OptionSlot({this.optionSlot = 0, this.optionSlotSuccessRatio = 0});

  factory OptionSlot.fromJson(Map<String, dynamic> json) => _$OptionSlotFromJson(json);
  Map<String, dynamic> toJson() => _$OptionSlotToJson(this);
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum ItemType { unknown, equip }

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum EquipRarity { unknown, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10 }

enum EquipType {
  unknown,
  @JsonValue('Module_A')
  head,
  @JsonValue('Module_B')
  body,
  @JsonValue('Module_C')
  arm,
  @JsonValue('Module_D')
  leg,
}
