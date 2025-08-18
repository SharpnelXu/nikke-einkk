import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nikke_einkk/model/battle/barrier.dart';
import 'package:nikke_einkk/model/battle/battle_entity.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/battle_skill.dart';
import 'package:nikke_einkk/model/battle/buff.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';
import 'package:nikke_einkk/model/battle/events/nikke_damage_event.dart';
import 'package:nikke_einkk/model/battle/events/rapture_damage_event.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';

part '../../generated/model/battle/rapture.g.dart';

@JsonSerializable()
class BattleRaptureOptions {
  // from MonsterTable
  int? monsterId;
  String name = 'Rapture';
  NikkeElement element;
  Map<int, BattleRaptureParts> parts = {};

  // made up data
  bool isStageTarget;
  bool canBeTargeted;
  int coreSize;
  int startDistance;

  // from level enhance
  int? level;
  int startHp;
  int startAttack;
  int startDefence;
  int damageRatio;
  int projectileHp;
  int brokenHp;

  Map<int, List<BattleRaptureAction>> actions = SplayTreeMap((a, b) => b.compareTo(a));

  BattleRaptureOptions copy() {
    return BattleRaptureOptions(
      monsterId: monsterId,
      level: level,
      name: name,
      isStageTarget: isStageTarget,
      canBeTargeted: canBeTargeted,
      coreSize: coreSize,
      startDistance: startDistance,
      startHp: startHp,
      startAttack: startAttack,
      startDefence: startDefence,
      element: element,
      actions: actions,
      parts: parts,
      damageRatio: damageRatio,
      projectileHp: projectileHp,
      brokenHp: brokenHp,
    );
  }

  BattleRaptureOptions({
    this.monsterId,
    this.level,
    this.name = "Rapture",
    this.isStageTarget = true,
    this.canBeTargeted = true,
    this.coreSize = 10,
    this.startDistance = 25,
    this.startHp = 1,
    this.startAttack = 1,
    this.startDefence = 140,
    this.damageRatio = 10000,
    this.projectileHp = 1,
    this.brokenHp = 1,
    this.element = NikkeElement.unknown,
    Map<int, List<BattleRaptureAction>> actions = const {},
    Map<int, BattleRaptureParts> parts = const {},
  }) {
    for (final frame in actions.keys) {
      this.actions[frame] = [];
      this.actions[frame]!.addAll(actions[frame]!.map((action) => action.copy()));
    }
    for (final partId in parts.keys) {
      this.parts[partId] = parts[partId]!.copy();
    }
  }

  factory BattleRaptureOptions.fromJson(Map<String, dynamic> json) => _$BattleRaptureOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$BattleRaptureOptionsToJson(this);
}

@JsonSerializable()
class BattleRaptureAction {
  final BattleRaptureActionType type;
  final int frame;
  int? setParameter;
  int? frameDuration;
  DurationType? durationType;
  List<NikkeElement>? eleShields;
  int? barrierHp;

  int? damageRate;
  bool? hitCover;
  BattleRaptureActionTarget? targetType;
  BattleRaptureActionTargetSubtype? targetSubtype;
  int? position;
  int? targetCount;
  bool? sortHighToLow;

  int? buffValue;
  FunctionType? buffType;
  bool? isBuff;

  int? partId;

  BattleRaptureAction copy() {
    return BattleRaptureAction(
      type: type,
      frame: frame,
      setParameter: setParameter,
      frameDuration: frameDuration,
      durationType: durationType,
      eleShields: eleShields,
      targetType: targetType,
      targetSubtype: targetSubtype,
      position: position,
      targetCount: targetCount,
      sortHighToLow: sortHighToLow,
      buffType: buffType,
      isBuff: isBuff,
      buffValue: buffValue,
      partId: partId,
      damageRate: damageRate,
      barrierHp: barrierHp,
      hitCover: hitCover,
    );
  }

  BattleRaptureAction({
    required this.type,
    required this.frame,
    this.setParameter,
    this.frameDuration,
    this.durationType,
    List<NikkeElement>? eleShields,
    this.targetType,
    this.targetSubtype,
    this.position,
    this.targetCount,
    this.sortHighToLow,
    this.buffType,
    this.isBuff,
    this.buffValue,
    this.partId,
    this.damageRate,
    this.barrierHp,
    this.hitCover,
  }) : eleShields = eleShields?.toList();

  factory BattleRaptureAction.fromJson(Map<String, dynamic> json) => _$BattleRaptureActionFromJson(json);

  Map<String, dynamic> toJson() => _$BattleRaptureActionToJson(this);

  BattleRaptureAction.set(this.type, this.frame, this.setParameter);

  BattleRaptureAction.timed(this.type, this.frame, this.frameDuration);

  factory BattleRaptureAction.barrier(int frame, int hp, DurationType durationType, int? duration) {
    return BattleRaptureAction(
      type: BattleRaptureActionType.generateBarrier,
      frame: frame,
      barrierHp: hp,
      durationType: durationType,
      frameDuration: duration,
    );
  }

  factory BattleRaptureAction.eleShield(int frame, List<NikkeElement> eleShields, int duration) {
    return BattleRaptureAction(
      type: BattleRaptureActionType.elementalShield,
      frame: frame,
      eleShields: eleShields,
      frameDuration: duration,
    );
  }

  factory BattleRaptureAction.attack({
    required int frame,
    required BattleRaptureActionTarget targetType,
    required int damageRate,
    required bool hitCover,
    BattleRaptureActionTargetSubtype? targetSubtype,
    int? targetCount,
    bool? sortHighToLow,
    int? position,
  }) {
    return BattleRaptureAction(
      type: BattleRaptureActionType.attack,
      frame: frame,
      damageRate: damageRate,
      targetType: targetType,
      targetSubtype: targetSubtype,
      targetCount: targetCount,
      sortHighToLow: sortHighToLow,
      position: position,
      hitCover: hitCover,
    );
  }

  factory BattleRaptureAction.parts(int frame, int partId) {
    return BattleRaptureAction(type: BattleRaptureActionType.generateParts, frame: frame, partId: partId);
  }

  factory BattleRaptureAction.setBuff({
    required int frame,
    required BattleRaptureActionTarget targetType,
    required FunctionType buffType,
    required bool treatAsBuff,
    required int buffValue,
    required DurationType durationType,
    required int duration,
    BattleRaptureActionTargetSubtype? targetSubtype,
    int? targetCount,
    bool? sortHighToLow,
    int? position,
  }) {
    return BattleRaptureAction(
      type: BattleRaptureActionType.setBuff,
      frame: frame,
      buffType: buffType,
      isBuff: treatAsBuff,
      buffValue: buffValue,
      durationType: durationType,
      frameDuration: duration,
      targetType: targetType,
      targetSubtype: targetSubtype,
      targetCount: targetCount,
      sortHighToLow: sortHighToLow,
      position: position,
    );
  }

  factory BattleRaptureAction.clearBuff({
    required int frame,
    required BattleRaptureActionTarget targetType,
    required bool isClearBuff,
    BattleRaptureActionTargetSubtype? targetSubtype,
    int? targetCount,
    bool? sortHighToLow,
    int? position,
  }) {
    return BattleRaptureAction(
      type: BattleRaptureActionType.clearBuff,
      frame: frame,
      isBuff: isClearBuff,
      targetType: targetType,
      targetSubtype: targetSubtype,
      targetCount: targetCount,
      sortHighToLow: sortHighToLow,
      position: position,
    );
  }
}

enum BattleRaptureActionType {
  // set parameter
  setAtk,
  setDef,
  setDistance,
  setCoreSize,

  // time parameter
  jump,
  invincible,
  redCircle,
  elementalShield,
  generateBarrier,

  // parts
  generateParts,

  // requires target
  attack,
  setBuff,
  clearBuff,

  // timed actions end
  jumpEnd,
  invincibleEnd,
  redCircleEnd,
  elementalShieldEnd;

  @override
  String toString() {
    switch (this) {
      case BattleRaptureActionType.setAtk:
        return 'Set ATK';
      case BattleRaptureActionType.setDef:
        return 'Set DEF';
      case BattleRaptureActionType.setDistance:
        return 'Set Distance';
      case BattleRaptureActionType.setCoreSize:
        return 'Set Core Status';
      case BattleRaptureActionType.jump:
        return 'Jump';
      case BattleRaptureActionType.invincible:
        return 'Set Invincibility';
      case BattleRaptureActionType.redCircle:
        return 'Start Special Interruption';
      case BattleRaptureActionType.elementalShield:
        return 'Generate Code Barrier';
      case BattleRaptureActionType.generateBarrier:
        return 'Generate Barrier';
      case BattleRaptureActionType.generateParts:
        return 'Generate Parts';
      case BattleRaptureActionType.attack:
        return 'Execute Attack';
      case BattleRaptureActionType.setBuff:
        return 'Set Buff';
      case BattleRaptureActionType.clearBuff:
        return 'Remove Buff';
      case BattleRaptureActionType.jumpEnd:
      case BattleRaptureActionType.invincibleEnd:
      case BattleRaptureActionType.redCircleEnd:
      case BattleRaptureActionType.elementalShieldEnd:
        return name;
    }
  }
}

enum BattleRaptureActionTarget {
  allNikkes,
  allRaptures,
  allRapturesExceptSelf,
  allActors,
  self,

  // sub targets
  targetedNikkes,
}

enum BattleRaptureActionTargetSubtype {
  attack,
  defence,
  hp,
  hpRatio,
  maxHp,
  hpCover,
  hpCoverRatio,
  maxHpCover,
  position,
}

int getSortingStat(BattleSimulation simulation, BattleNikke nikke, BattleRaptureActionTargetSubtype type) {
  switch (type) {
    case BattleRaptureActionTargetSubtype.attack:
      return nikke.getFinalAttack(simulation);
    case BattleRaptureActionTargetSubtype.defence:
      return nikke.getFinalDefence(simulation);
    case BattleRaptureActionTargetSubtype.hp:
      return nikke.currentHp;
    case BattleRaptureActionTargetSubtype.hpRatio:
      return (10000 * nikke.currentHp / nikke.getMaxHp(simulation)).round();
    case BattleRaptureActionTargetSubtype.maxHp:
      return nikke.getMaxHp(simulation);
    case BattleRaptureActionTargetSubtype.hpCover:
      return nikke.cover.currentHp;
    case BattleRaptureActionTargetSubtype.hpCoverRatio:
      return (10000 * nikke.cover.currentHp / nikke.cover.getMaxHp(simulation)).round();
    case BattleRaptureActionTargetSubtype.maxHpCover:
      return nikke.cover.getMaxHp(simulation);
    case BattleRaptureActionTargetSubtype.position:
      return 0;
  }
}

@JsonSerializable()
class BattleRaptureParts {
  int id;
  String name;
  int maxHp = 10000;
  @JsonKey(includeFromJson: false, includeToJson: false)
  int hp = 10000;
  bool isBehindBoss = true;
  bool isCore = false;

  BattleRaptureParts({
    required this.id,
    this.name = 'Part',
    this.maxHp = 10000,
    this.hp = 10000,
    this.isBehindBoss = true,
    this.isCore = false,
  });

  factory BattleRaptureParts.fromJson(Map<String, dynamic> json) => _$BattleRapturePartsFromJson(json);

  Map<String, dynamic> toJson() => _$BattleRapturePartsToJson(this);

  bool canBeDamaged(bool hasPierce) {
    return hp > 0 && (hasPierce || !isBehindBoss);
  }

  BattleRaptureParts copy() {
    return BattleRaptureParts(id: id, name: name, maxHp: maxHp, hp: hp, isBehindBoss: isBehindBoss, isCore: isCore);
  }
}

class BattleRapture extends BattleEntity {
  BattleRaptureOptions options;

  bool canBeTargeted = true;

  bool invincible = false;
  bool outsideScreen = false;
  List<NikkeElement> elementalShield = [];

  bool isStageTarget = true;

  // set to 0 for no core
  int coreSize = 10;

  int distance = 25;

  int attack = 0;
  int defence = 0;

  Barrier? barrier;

  @override
  String get name => locale.getTranslation(options.name) ?? options.name;

  @override
  int get baseHp => options.startHp;

  @override
  int get baseDefence => defence;

  @override
  int get baseAttack => attack;

  List<BattleRaptureParts> parts = [];

  bool hasRedCircle = false;

  Map<int, List<BattleRaptureAction>> endActions = {};

  @override
  NikkeElement get element => options.element;

  HitMonsterGetBuffData? hitMonsterGetBuffData;

  BattleRapture(this.options);

  void init(BattleSimulation simulation, int uniqueId) {
    this.uniqueId = uniqueId;
    currentHp = options.startHp;
    coreSize = options.coreSize;
    defence = options.startDefence;
    attack = options.startAttack;
    distance = options.startDistance;
    canBeTargeted = options.canBeTargeted;
    isStageTarget = options.isStageTarget;
    hitMonsterGetBuffData = null;

    hasRedCircle = false;

    invincible = false;
    outsideScreen = false;

    elementalShield.clear();
    barrier = null;
    parts.clear();
    hasRedCircle = false;
    buffs.clear();
    funcRatioTracker.clear();

    endActions.clear();
  }

  bool hasPartsInFront() {
    return parts.isNotEmpty && parts.any((part) => !part.isBehindBoss);
  }

  int? getPartsInFront() {
    return parts.firstWhereOrNull((part) => !part.isBehindBoss && part.hp > 0)?.id;
  }

  bool validateBulletDamage(BattleNikke attacker) {
    return !invincible &&
        !outsideScreen &&
        (elementalShield.isEmpty || attacker.effectiveElements.any((ele) => elementalShield.contains(ele)));
  }

  bool validateSkillDamage(BattleNikke attacker) {
    return !invincible &&
        (elementalShield.isEmpty || attacker.effectiveElements.any((ele) => elementalShield.contains(ele)));
  }

  @override
  void normalAction(BattleSimulation simulation) {
    super.normalAction(simulation);

    final barrier = this.barrier;
    if (barrier != null) {
      if (barrier.durationType.isTimed) {
        barrier.duration -= 1;
        if (barrier.duration == 0) {
          this.barrier = null;
        }
      }

      if (barrier.hp <= 0) {
        this.barrier = null;
      }
    }

    final hitMonsterGetBuffData = this.hitMonsterGetBuffData;
    if (hitMonsterGetBuffData != null) {
      hitMonsterGetBuffData.duration -= 1;
      if (hitMonsterGetBuffData.duration <= 0) {
        this.hitMonsterGetBuffData = null;
      }
    }

    if (options.actions.containsKey(simulation.currentFrame)) {
      executeRaptureActions(simulation, options.actions[simulation.currentFrame]!);
    }

    if (endActions.containsKey(simulation.currentFrame)) {
      executeRaptureActions(simulation, endActions[simulation.currentFrame]!);
    }
  }

  void executeRaptureActions(BattleSimulation simulation, List<BattleRaptureAction> actions) {
    for (final action in actions) {
      switch (action.type) {
        case BattleRaptureActionType.setAtk:
          attack = action.setParameter!;
          break;
        case BattleRaptureActionType.setDef:
          defence = action.setParameter!;
          break;
        case BattleRaptureActionType.setDistance:
          distance = action.setParameter!;
          break;
        case BattleRaptureActionType.setCoreSize:
          coreSize = action.setParameter!;
          break;
        case BattleRaptureActionType.jump:
          outsideScreen = true;
          if (action.frameDuration != null) {
            final endFrame = simulation.currentFrame - action.frameDuration!;
            endActions.putIfAbsent(endFrame, () => []);
            endActions[endFrame]!.add(BattleRaptureAction(type: BattleRaptureActionType.jumpEnd, frame: endFrame));
          }
          break;
        case BattleRaptureActionType.jumpEnd:
          outsideScreen = false;
          break;
        case BattleRaptureActionType.invincible:
          invincible = true;
          if (action.frameDuration != null) {
            final endFrame = simulation.currentFrame - action.frameDuration!;
            endActions.putIfAbsent(endFrame, () => []);
            endActions[endFrame]!.add(
              BattleRaptureAction(type: BattleRaptureActionType.invincibleEnd, frame: endFrame),
            );
          }
          break;
        case BattleRaptureActionType.invincibleEnd:
          invincible = false;
          break;
        case BattleRaptureActionType.redCircle:
          hasRedCircle = true;
          if (action.frameDuration != null) {
            final endFrame = simulation.currentFrame - action.frameDuration!;
            endActions.putIfAbsent(endFrame, () => []);
            endActions[endFrame]!.add(BattleRaptureAction(type: BattleRaptureActionType.redCircleEnd, frame: endFrame));
          }
          break;
        case BattleRaptureActionType.redCircleEnd:
          hasRedCircle = false;
          break;
        case BattleRaptureActionType.elementalShield:
          elementalShield.addAll(action.eleShields!);
          if (action.frameDuration != null) {
            final endFrame = simulation.currentFrame - action.frameDuration!;
            endActions.putIfAbsent(endFrame, () => []);
            endActions[endFrame]!.add(
              BattleRaptureAction(type: BattleRaptureActionType.elementalShieldEnd, frame: endFrame),
            );
          }
          break;
        case BattleRaptureActionType.elementalShieldEnd:
          elementalShield.clear();
          break;
        case BattleRaptureActionType.generateBarrier:
          barrier = Barrier(-1, action.barrierHp!, action.durationType!, action.frameDuration ?? 0);
          break;
        case BattleRaptureActionType.generateParts:
          final partId = action.partId!;

          if (options.parts.containsKey(partId) && parts.every((part) => part.id != partId)) {
            parts.add(options.parts[partId]!.copy());
          }

          break;
        case BattleRaptureActionType.attack:
          for (final target in getActionTargets(simulation, action)) {
            if (target is! BattleNikke) continue;

            simulation.registerEvent(
              simulation.currentFrame,
              RaptureDamageEvent.create(simulation, this, target, action.damageRate!, action.hitCover!),
            );
          }
          break;
        case BattleRaptureActionType.setBuff:
          for (final target in getActionTargets(simulation, action)) {
            final buff = BattleBuff.create(
              data: FunctionData(
                id: -1,
                groupId: -(action.setParameter! * 1000 + action.buffType!.index),
                rawBuffType: action.isBuff! ? BuffType.buff.name.pascal : BuffType.deBuff.name.pascal,
                rawBuffRemove: BuffRemoveType.clear.name.pascal,
                rawFunctionType: action.buffType!.jsonKey,
                rawFunctionValueType: ValueType.percent.name.pascal,
                functionValue: action.buffValue!,
                rawFunctionStandard: StandardType.user.name.pascal,
                fullCount: 999,
                rawDurationType: action.durationType!.name.pascal,
                durationValue: frameToTimeData(action.frameDuration!, simulation.fps),
                rawFunctionTarget: FunctionTargetType.self.name.pascal,
                rawTimingTriggerType: TimingTriggerType.none.name.pascal,
                rawStatusTriggerType: StatusTriggerType.none.name.pascal,
                rawStatusTrigger2Type: StatusTriggerType.none.name.pascal,
              ),
              buffGiverUniqueId: uniqueId,
              buffReceiverUniqueId: target.uniqueId,
              simulation: simulation,
              source: Source.raptureSkill,
            );
            target.buffs.add(buff);
          }
          break;
        case BattleRaptureActionType.clearBuff:
          for (final target in getActionTargets(simulation, action)) {
            target.buffs.removeWhere((buff) {
              final canRemove = buff.data.buffRemove == BuffRemoveType.clear;
              final isBuff = [BuffType.buff, BuffType.buffEtc].contains(buff.data.buff);
              final isDebuff = [BuffType.deBuffEtc, BuffType.deBuff].contains(buff.data.buff);
              return canRemove && ((isBuff && action.isBuff!) || (isDebuff && !action.isBuff!));
            });
          }
          break;
      }
    }
  }

  List<BattleEntity> getActionTargets(BattleSimulation simulation, BattleRaptureAction action) {
    switch (action.targetType!) {
      case BattleRaptureActionTarget.allNikkes:
        return simulation.nonnullNikkes.toList();
      case BattleRaptureActionTarget.allRaptures:
        return simulation.raptures.toList();
      case BattleRaptureActionTarget.allRapturesExceptSelf:
        return simulation.raptures.toList()..remove(this);
      case BattleRaptureActionTarget.allActors:
        return [...simulation.nonnullNikkes, ...simulation.raptures];
      case BattleRaptureActionTarget.self:
        return [this];
      case BattleRaptureActionTarget.targetedNikkes:
        final nikkes = simulation.nonnullNikkes.toList();
        final subtype = action.targetSubtype!;
        if (subtype == BattleRaptureActionTargetSubtype.position) {
          int position = action.position!;
          return [if (simulation.battleNikkes[position - 1] != null) simulation.battleNikkes[position - 1]!];
        }

        nikkes.sort((a, b) => getSortingStat(simulation, a, subtype) - getSortingStat(simulation, b, subtype));

        final countList = action.sortHighToLow! ? nikkes.reversed.toList() : nikkes;
        return countList.sublist(0, min(countList.length, action.targetCount!));
    }
  }

  void broadcast(BattleEvent event, BattleSimulation simulation) {
    if (event is NikkeDamageEvent && event.targetId == uniqueId) {
      for (final buff in buffs) {
        if (buff.data.durationType.isShots && simulation.db.onHitFunctionTypes.contains(buff.data.functionType)) {
          buff.duration -= 1;
        }
      }
    }
  }
}
