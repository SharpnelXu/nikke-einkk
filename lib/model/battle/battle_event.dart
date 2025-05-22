import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:nikke_einkk/model/battle/battle_entity.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/buff.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/skills.dart';

import 'nikke.dart';

abstract class BattleEvent {
  Widget buildDisplay();

  int getActivatorUniqueId() {
    return -1;
  }

  List<int> getTargetUniqueIds() {
    return [];
  }
}

// or replace these with an enum type if no real use case
class NikkeFireEvent extends BattleEvent {
  String name;
  int currentAmmo;
  int maxAmmo;
  bool isFullCharge;
  int ownerUniqueId;

  NikkeFireEvent({
    required this.name,
    required this.isFullCharge,
    required this.currentAmmo,
    required this.maxAmmo,
    required this.ownerUniqueId,
  });

  @override
  buildDisplay() {
    return Text('$name (Pos $ownerUniqueId) attack (Ammo: ${currentAmmo - 1}/$maxAmmo)');
  }

  @override
  int getActivatorUniqueId() {
    return ownerUniqueId;
  }
}

class NikkeReloadStartEvent extends BattleEvent {
  String name;
  num reloadTimeData;
  int reloadFrames;
  int ownerUniqueId;

  NikkeReloadStartEvent({
    required this.name,
    required this.reloadTimeData,
    required this.reloadFrames,
    required this.ownerUniqueId,
  });

  @override
  int getActivatorUniqueId() {
    return ownerUniqueId;
  }

  @override
  Widget buildDisplay() {
    return Text(
      '$name (Pos $ownerUniqueId) reloading: '
      '${(reloadTimeData / 100).toStringAsFixed(2)}s ($reloadFrames frames)',
    );
  }
}

class NikkeDamageEvent extends BattleEvent {
  late NikkeDamageType type;
  late String name;
  late int attackerUniqueId;
  late int targetUniqueId;
  late int chargePercent;
  late int shotCount;
  bool isShareDamage = false;
  int shareCount = 0;
  int? partId;

  late NikkeDamageParameter damageParameter;

  NikkeDamageEvent.bullet({
    required BattleSimulation simulation,
    required BattleNikke nikke,
    required BattleRapture rapture,
  }) {
    name = nikke.name;
    type = NikkeDamageType.bullet;
    attackerUniqueId = nikke.uniqueId;
    targetUniqueId = rapture.uniqueId;
    final weaponData = nikke.currentWeaponData;
    shotCount = weaponData.shotCount;
    chargePercent =
        WeaponType.chargeWeaponTypes.contains(nikke.currentWeaponType)
            ? (10000 * nikke.chargeFrames / nikke.getFramesToFullCharge(simulation)).round()
            : 0;
    chargePercent = chargePercent.clamp(0, 10000);
    final pierce = nikke.getPierce(simulation);
    partId = rapture.getPartsInFront();

    // TODO: fill in other buff params
    damageParameter = NikkeDamageParameter(
      attack: nikke.baseAttack,
      attackBuff: nikke.getAttackBuffValues(simulation),
      defence: rapture.baseDefence,
      damageRate: weaponData.damage * weaponData.muzzleCount,
      damageRateBuff: nikke.getNormalDamageRatioChangeBuffValues(simulation),
      coreHitRate: calculateCoreHitRate(simulation, nikke, rapture),
      coreDamageRate: weaponData.coreDamageRate,
      coreDamageBuff: nikke.getCoreDamageBuffValues(simulation),
      criticalRate: nikke.getCriticalRate(simulation) + nikke.getNormalCriticalBuff(simulation),
      criticalDamageRate: nikke.characterData.criticalDamage,
      criticalDamageBuff: nikke.getCriticalDamageBuffValues(simulation),
      isBonusRange: nikke.isBonusRange(rapture.distance),
      isFullBurst: simulation.burstStage == 4,
      isStrongElement: nikke.element.strongAgainst(rapture.element),
      elementDamageBuff: nikke.getIncreaseElementDamageBuffValues(simulation),
      chargeDamageRate: weaponData.fullChargeDamage,
      chargeDamageBuff: nikke.getChargeDamageBuffValues(simulation),
      chargePercent: chargePercent,
      // pierce won't hit rapture body as parts
      partDamageBuff: pierce == 0 && partId != null ? nikke.getPartsDamageBuffValues(simulation) : 0,
      pierceDamageBuff: pierce > 0 ? nikke.getPierceDamageBuffValues(simulation) : 0,
      addDamageBuff: nikke.getAddDamageBuffValues(simulation),
      breakDamageBuff: partId == null && rapture.hasRedCircle ? nikke.getBreakDamageBuff(simulation) : 0,
    );
  }

  NikkeDamageEvent.piercePart({
    required BattleSimulation simulation,
    required BattleNikke nikke,
    required BattleRapture rapture,
    required BattleRaptureParts part,
  }) {
    name = nikke.name;
    type = NikkeDamageType.piercePart;
    attackerUniqueId = nikke.uniqueId;
    targetUniqueId = rapture.uniqueId;
    final weaponData = nikke.currentWeaponData;
    shotCount = weaponData.shotCount;
    chargePercent =
        WeaponType.chargeWeaponTypes.contains(nikke.currentWeaponType)
            ? (10000 * nikke.chargeFrames / nikke.getFramesToFullCharge(simulation)).round()
            : 0;
    chargePercent = chargePercent.clamp(0, 10000);
    partId = part.id;

    // TODO: fill in other buff params
    damageParameter = NikkeDamageParameter(
      attack: nikke.baseAttack,
      attackBuff: nikke.getAttackBuffValues(simulation),
      defence: rapture.baseDefence,
      damageRate: weaponData.damage * weaponData.muzzleCount,
      damageRateBuff: nikke.getNormalDamageRatioChangeBuffValues(simulation),
      coreHitRate: part.isCore ? 10000 : 0,
      coreDamageRate: weaponData.coreDamageRate,
      coreDamageBuff: nikke.getCoreDamageBuffValues(simulation),
      criticalRate: nikke.getCriticalRate(simulation),
      criticalDamageRate: nikke.characterData.criticalDamage,
      criticalDamageBuff: nikke.getCriticalDamageBuffValues(simulation),
      isBonusRange: nikke.isBonusRange(rapture.distance),
      isFullBurst: simulation.burstStage == 4,
      isStrongElement: nikke.element.strongAgainst(rapture.element),
      elementDamageBuff: nikke.getIncreaseElementDamageBuffValues(simulation),
      chargeDamageRate: weaponData.fullChargeDamage,
      chargeDamageBuff: nikke.getChargeDamageBuffValues(simulation),
      chargePercent: chargePercent,
      partDamageBuff: nikke.getPartsDamageBuffValues(simulation),
      pierceDamageBuff: nikke.getPierceDamageBuffValues(simulation),
      addDamageBuff: nikke.getAddDamageBuffValues(simulation),
    );
  }

  NikkeDamageEvent.skill({
    required BattleSimulation simulation,
    required BattleNikke nikke,
    required BattleRapture rapture,
    required int damageRate,
    this.isShareDamage = false,
  }) {
    name = nikke.name;
    type = NikkeDamageType.skill;
    attackerUniqueId = nikke.uniqueId;
    targetUniqueId = rapture.uniqueId;

    shotCount = 1;
    shareCount = simulation.raptures.length; // just share damage to all enemies
    chargePercent = 0;

    // TODO: fill in other buff params
    damageParameter = NikkeDamageParameter(
      attack: nikke.baseAttack,
      attackBuff: nikke.getAttackBuffValues(simulation),
      defence: rapture.baseDefence,
      damageRate: damageRate,
      coreHitRate: 0,
      criticalRate: nikke.getCriticalRate(simulation),
      criticalDamageRate: nikke.characterData.criticalDamage,
      criticalDamageBuff: nikke.getCriticalDamageBuffValues(simulation),
      isFullBurst: simulation.burstStage == 4,
      isStrongElement: nikke.element.strongAgainst(rapture.element),
      elementDamageBuff: nikke.getIncreaseElementDamageBuffValues(simulation),
      addDamageBuff: nikke.getAddDamageBuffValues(simulation),
      distributedDamageBuff: isShareDamage ? nikke.getShareDamageBuffValues(simulation) : 0,
    );
  }

  int calculateCoreHitRate(BattleSimulation simulation, BattleNikke nikke, BattleRapture rapture) {
    if (rapture.coreSize == 0) {
      // no core
      return 0;
    }

    if (rapture.coreRequiresPierce && nikke.getPierce(simulation) == 0) {
      // cannot hit core
      return 0;
    }

    if (WeaponType.chargeWeaponTypes.contains(nikke.currentWeaponType)) {
      return 10000;
    }

    // just a wild guess for now
    return (50 * rapture.coreSize / max(1, nikke.getAccuracyCircleScale(simulation) * rapture.distance) * 10000)
        .round();
  }

  @override
  int getActivatorUniqueId() {
    return attackerUniqueId;
  }

  @override
  List<int> getTargetUniqueIds() {
    return [targetUniqueId];
  }

  @override
  Widget buildDisplay() {
    final criticalPercent = min(BattleUtils.toModifier(damageParameter.criticalRate), 1);
    final corePercent = min(BattleUtils.toModifier(damageParameter.coreHitRate), 1);
    final nonCritPercent = 1 - criticalPercent;
    final nonCorePercent = 1 - corePercent;
    final basePercent = nonCritPercent * nonCorePercent;
    final coreCritPercent = criticalPercent * corePercent;

    final nameText = '$name (Pos $attackerUniqueId) ${type.name} damage: ${damageParameter.calculateExpectedDamage()}';
    final shotText = shotCount > 1 ? ' ($shotCount Shots)' : '';
    final chargeText = chargePercent > 0 ? ' Charge: ${(chargePercent / 100).toStringAsFixed(2)}%' : '';
    final baseText =
        basePercent > 0 ? ' Base: ${damageParameter.calculateDamage()} ${(basePercent * 100).toStringAsFixed(2)}%' : '';
    final coreText =
        corePercent > 0
            ? ' Core: ${damageParameter.calculateDamage(core: true)} ${(corePercent * 100).toStringAsFixed(2)}%'
            : '';
    final critText =
        criticalPercent > 0
            ? ' Crit: ${damageParameter.calculateDamage(critical: true)} ${(criticalPercent * 100).toStringAsFixed(2)}%'
            : '';
    final coreCritText =
        coreCritPercent > 0
            ? ' Core + Crit: ${damageParameter.calculateDamage(core: true, critical: true)}'
                ' ${(criticalPercent * 100).toStringAsFixed(2)}%'
            : '';
    final shareText = isShareDamage ? ' Shared by $shotCount targets' : '';

    return Text('$nameText$shotText$chargeText$baseText$coreText$critText$coreCritText$shareText');
  }
}

enum NikkeDamageType { bullet, skill, piercePart }

class BurstGenerationEvent extends BattleEvent {
  String name = '';
  late int attackerUniqueId;
  int targetUniqueId = -1;
  int chargePercent = 0;
  int currentMeter = 0;
  int burst = 0;
  int positionBurstBonus = 10000;
  bool isBullet = true;

  BurstGenerationEvent({
    required BattleSimulation simulation,
    required BattleNikke nikke,
    required BattleRapture rapture,
  }) {
    name = nikke.name;
    final weaponData = nikke.currentWeaponData;
    attackerUniqueId = nikke.uniqueId;
    targetUniqueId = rapture.uniqueId;
    chargePercent =
        WeaponType.chargeWeaponTypes.contains(weaponData.weaponType)
            ? (10000 * nikke.chargeFrames / nikke.getFramesToFullCharge(simulation)).round()
            : 0;
    chargePercent = chargePercent.clamp(0, 10000);
    currentMeter = simulation.burstMeter;
    final bonusBurst =
        (nikke.option.alwaysFocus || simulation.currentNikke == nikke.uniqueId) &&
        WeaponType.chargeWeaponTypes.contains(nikke.currentWeaponData.weaponType);

    positionBurstBonus = bonusBurst ? 10000 + (15000 * BattleUtils.toModifier(chargePercent)).round() : 10000;

    final baseBurst = nikke.getBurstGen(simulation, rapture.isStageTarget);

    burst = (baseBurst * weaponData.shotCount * BattleUtils.toModifier(positionBurstBonus)).round();
  }

  BurstGenerationEvent.fill({required BattleSimulation simulation, required BattleNikke nikke, required this.burst}) {
    name = nikke.name;
    attackerUniqueId = nikke.uniqueId;
    isBullet = false;
  }

  @override
  int getActivatorUniqueId() {
    return attackerUniqueId;
  }

  @override
  List<int> getTargetUniqueIds() {
    return [targetUniqueId];
  }

  @override
  Widget buildDisplay() {
    final updatedBurst = min(currentMeter + burst, BattleSimulation.burstMeterCap);

    return Text(
      '$name (Pos $attackerUniqueId) Burst Gen: ${(updatedBurst / 10000).toStringAsFixed(4)}%'
      ' (+${(burst / 10000).toStringAsFixed(4)}%)'
      '${positionBurstBonus > 10000 && isBullet ? ' Bonus: ${(positionBurstBonus / 100).toStringAsFixed(2)}%' : ''}',
    );
  }
}

class BattleStartEvent extends BattleEvent {
  static BattleStartEvent battleStartEvent = BattleStartEvent._();

  BattleStartEvent._();

  @override
  Widget buildDisplay() {
    return Text('Battle Start');
  }
}

class HpChangeEvent extends BattleEvent {
  late String name;
  late int ownerUniqueId; // who changed hp
  late int afterChangeHp;
  late int maxHp;
  bool isMaxHpOnly;
  bool isHeal;
  int changeAmount;

  HpChangeEvent(
    BattleSimulation simulation,
    BattleEntity entity,
    this.changeAmount, {
    this.isMaxHpOnly = false,
    this.isHeal = false,
  }) {
    name = entity.name;
    ownerUniqueId = entity.uniqueId;
    afterChangeHp = entity.currentHp;
    maxHp = entity.getMaxHp(simulation);
  }

  @override
  int getActivatorUniqueId() {
    return ownerUniqueId;
  }

  @override
  Widget buildDisplay() {
    final hpPercent = (afterChangeHp / maxHp * 100).toStringAsFixed(2);
    return Text(
      '$name (Pos $ownerUniqueId) ${isMaxHpOnly ? 'Max' : ''}HP change:'
      ' $changeAmount ($hpPercent% $afterChangeHp/$maxHp)',
    );
  }
}

class UseSkillEvent extends BattleEvent {
  late String name;
  final int skillId;
  final int ownerUniqueId;
  final int skillGroup;
  final int skillNum;
  final List<int> skillTargetUniqueIds = [];

  UseSkillEvent(
    BattleSimulation simulation,
    this.skillId,
    this.ownerUniqueId,
    this.skillGroup,
    this.skillNum,
    List<int> targetUniqueIds,
  ) {
    name = simulation.getEntityByUniqueId(ownerUniqueId)!.name;
    skillTargetUniqueIds.addAll(targetUniqueIds);
  }

  @override
  int getActivatorUniqueId() {
    return ownerUniqueId;
  }

  @override
  List<int> getTargetUniqueIds() {
    return skillTargetUniqueIds;
  }

  @override
  Widget buildDisplay() {
    final skillName =
        gameData.getTranslation(gameData.skillInfoTable[skillId]?.nameLocalkey)?.zhCN ?? 'Skill $skillNum';
    return Text('$name (Pos $ownerUniqueId) activates $skillName');
  }
}

class ChangeBurstStepEvent extends BattleEvent {
  late String? name;
  final int ownerUniqueId;
  late int currentStage;
  late int nextStage;
  late int duration;

  ChangeBurstStepEvent(BattleSimulation simulation, this.ownerUniqueId, this.nextStage, this.duration) {
    final owner = simulation.getNikkeOnPosition(ownerUniqueId);
    name = owner?.name;
    currentStage = simulation.burstStage;
  }

  @override
  int getActivatorUniqueId() {
    return ownerUniqueId;
  }

  @override
  Widget buildDisplay() {
    return Text(
      'Burst stage $currentStage -> $nextStage ${name != null ? 'by $name (Pos $ownerUniqueId) '
              'Duration ${(duration / 100).toStringAsFixed(2)}s' : ''}',
    );
  }
}

class ExitFullBurstEvent extends BattleEvent {
  static ExitFullBurstEvent exitFullBurstEvent = ExitFullBurstEvent._();

  ExitFullBurstEvent._();

  @override
  Widget buildDisplay() {
    return Text('Exit full burst');
  }
}

class BuffEvent extends BattleEvent {
  late FunctionData data;
  late String giverName;
  late int buffGiverUniqueId;
  late String receiverName;
  late int buffReceiverUniqueId;
  late int buffCount;

  BuffEvent(BattleSimulation simulation, BattleBuff buff) {
    data = buff.data;
    buffGiverUniqueId = buff.buffGiverUniqueId;
    giverName = simulation.getEntityByUniqueId(buffGiverUniqueId)!.name;
    buffReceiverUniqueId = buff.buffReceiverUniqueId;
    receiverName = simulation.getEntityByUniqueId(buffReceiverUniqueId)!.name;
    buffCount = buff.count;
  }

  @override
  int getActivatorUniqueId() {
    return buffGiverUniqueId;
  }

  @override
  List<int> getTargetUniqueIds() {
    return [buffReceiverUniqueId];
  }

  @override
  Widget buildDisplay() {
    final valueString =
        data.functionValueType == ValueType.percent
            ? '${(data.functionValue / 100).toStringAsFixed(2)}%'
            : '${data.functionValue}';
    final funcString =
        '${data.functionType.name} $valueString (${data.functionStandard.name}) $buffCount/${data.fullCount}';
    final skillName = gameData.getTranslation(data.nameLocalkey)?.zhCN ?? 'Buff';
    return Text('$skillName $funcString (to $receiverName by $giverName)');
  }
}
