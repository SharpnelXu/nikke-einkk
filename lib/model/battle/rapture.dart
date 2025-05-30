import 'dart:math';

import 'package:collection/collection.dart';
import 'package:nikke_einkk/model/battle/barrier.dart';
import 'package:nikke_einkk/model/battle/battle_event.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/buff.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/skills.dart';

import 'battle_entity.dart';

class BattleRaptureOptions {
  String name = "Rapture";
  bool isStageTarget = true;
  bool canBeTargeted = true;
  int coreSize = 10;
  int startDistance = 25;
  int startHp = 1;
  int startAttack = 0;
  int startDefence = 100;
  int coreRequiresPierce = 0;

  Map<int, List<BattleRaptureAction>> actions = {};

  Map<int, BattleRaptureParts> parts = {};
}

class BattleRaptureAction {
  final BattleRaptureActionType type;
  int? setParameter;
  int? timeParameter;
  DurationType? durationType;
  List<NikkeElement>? eleShields;

  BattleRaptureActionTarget? targetType;
  BattleRaptureActionTargetSubtype? targetSubtype;
  int? targetCount;
  bool? sortHigh;

  FunctionType? buffType;
  bool? isBuff;

  BattleRaptureAction(this.type);

  BattleRaptureAction.set(this.type, this.setParameter);

  BattleRaptureAction.timed(this.type, this.timeParameter);

  factory BattleRaptureAction.barrier(int hp, DurationType durationType, int? duration) {
    return BattleRaptureAction(BattleRaptureActionType.generateBarrier)
      ..setParameter = hp
      ..durationType = durationType
      ..timeParameter = duration;
  }

  factory BattleRaptureAction.eleShield(List<NikkeElement> eleShields, int duration) {
    return BattleRaptureAction(BattleRaptureActionType.elementalShield)
      ..eleShields = eleShields
      ..timeParameter = duration;
  }

  factory BattleRaptureAction.attack(
    BattleRaptureActionTarget targetType,
    int damageRate, [
    BattleRaptureActionTargetSubtype? targetSubtype,
    int? targetCount,
    bool? high,
  ]) {
    return BattleRaptureAction(BattleRaptureActionType.attack)
      ..setParameter = damageRate
      ..targetType = targetType
      ..targetSubtype = targetSubtype
      ..targetCount = targetCount
      ..sortHigh = high;
  }

  factory BattleRaptureAction.parts(int partId) {
    return BattleRaptureAction(BattleRaptureActionType.generateParts)
      ..setParameter = partId;
  }

  factory BattleRaptureAction.setBuff({
    required BattleRaptureActionTarget targetType,
    required FunctionType buffType,
    required bool isBuff,
    required int buffValue,
    required DurationType durationType,
    required int duration,
    BattleRaptureActionTargetSubtype? targetSubtype,
    int? targetCount,
    bool? sortHigh,
  }) {
    return BattleRaptureAction(BattleRaptureActionType.setBuff)
      ..buffType = buffType
      ..isBuff = isBuff
      ..setParameter = buffValue
      ..durationType = durationType
      ..timeParameter = duration
      ..targetType = targetType
      ..targetSubtype = targetSubtype
      ..targetCount = targetCount
      ..sortHigh = sortHigh;
  }

  factory BattleRaptureAction.clearBuff({
    required BattleRaptureActionTarget targetType,
    required bool isBuff,
    BattleRaptureActionTargetSubtype? targetSubtype,
    int? targetCount,
    bool? sortHigh,
  }) {
    return BattleRaptureAction(BattleRaptureActionType.clearBuff)
      ..isBuff = isBuff
      ..targetType = targetType
      ..targetSubtype = targetSubtype
      ..targetCount = targetCount
      ..sortHigh = sortHigh;
  }
}

enum BattleRaptureActionType {
  // set parameter
  setAtk,
  setDef,
  setDistance,
  setCoreSize,
  setCorePierce,

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
  elementalShieldEnd,
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

enum BattleRaptureActionTargetSubtype { attack, defence, hp, hpRatio, maxHp, hpCover, hpCoverRatio, maxHpCover }

int getSortingStat(BattleSimulation simulation, BattleNikke nikke, BattleRaptureActionTargetSubtype type) {
  switch (type) {
    case BattleRaptureActionTargetSubtype.attack:
      return nikke.getAttackBuffValues(simulation) + nikke.baseAttack;
    case BattleRaptureActionTargetSubtype.defence:
      return nikke.getDefenceBuffValues(simulation) + nikke.baseDefence;
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
  }
}

class BattleRaptureParts {
  int id;
  int maxHp = 10000;
  int hp = 10000;
  bool isBehindBoss = true;
  bool isCore = false;

  BattleRaptureParts(this.id);

  bool canBeDamaged(bool hasPierce) {
    return hp > 0 && (hasPierce || !isBehindBoss);
  }

  BattleRaptureParts copy() {
    return BattleRaptureParts(id)
      ..maxHp = maxHp
      ..hp = maxHp
      ..isBehindBoss = isBehindBoss
      ..isCore = isCore;
  }
}

class BattleRapture extends BattleEntity {
  late BattleRaptureOptions options;

  bool canBeTargeted = true;

  bool invincible = false;
  bool outsideScreen = false;
  List<NikkeElement> elementalShield = [];

  bool isStageTarget = true;

  // set to 0 for no core
  int coreSize = 10;

  bool coreRequiresPierce = false;

  int distance = 25;

  int attack = 0;
  int defence = 0;

  Barrier? barrier;

  @override
  int get baseHp => options.startHp;

  @override
  int get baseDefence => options.startDefence;

  @override
  int get baseAttack => options.startAttack;

  List<BattleRaptureParts> parts = [];

  bool hasRedCircle = false;

  Map<int, List<BattleRaptureAction>> endActions = {};

  BattleRapture({BattleRaptureOptions? options}) {
    this.options = options ?? BattleRaptureOptions();
  }

  void init() {
    currentHp = options.startHp;
    coreSize = options.coreSize;
    defence = options.startDefence;
    attack = options.startAttack;
    distance = options.startDistance;
    canBeTargeted = options.canBeTargeted;
    isStageTarget = options.isStageTarget;
    coreRequiresPierce = options.coreRequiresPierce != 0;

    hasRedCircle = false;

    invincible = false;
    outsideScreen = false;

    elementalShield.clear();
    barrier = null;
    parts.clear();
    hasRedCircle = false;
    buffs.clear();

    endActions.clear();
  }

  bool hasPartsInFront() {
    return parts.isNotEmpty && parts.any((part) => !part.isBehindBoss);
  }

  int? getPartsInFront() {
    return parts.firstWhereOrNull((part) => !part.isBehindBoss && part.hp > 0)?.id;
  }

  @override
  void normalAction(BattleSimulation simulation) {
    super.normalAction(simulation);

    final barrier = this.barrier;
    if (barrier != null) {
      if (barrier.durationType == DurationType.timeSec) {
        barrier.duration -= 1;
        if (barrier.duration == 0) {
          this.barrier = null;
        }
      }

      if (barrier.hp <= 0) {
        this.barrier = null;
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
        case BattleRaptureActionType.setCorePierce:
          coreRequiresPierce = action.setParameter! != 0;
          break;
        case BattleRaptureActionType.jump:
          outsideScreen = true;
          if (action.timeParameter != null) {
            final endFrame =
                simulation.currentFrame - BattleUtils.timeDataToFrame(action.timeParameter!, simulation.fps);
            endActions.putIfAbsent(endFrame, () => []);
            endActions[endFrame]!.add(BattleRaptureAction(BattleRaptureActionType.jumpEnd));
          }
          break;
        case BattleRaptureActionType.jumpEnd:
          outsideScreen = false;
          break;
        case BattleRaptureActionType.invincible:
          invincible = true;
          if (action.timeParameter != null) {
            final endFrame =
                simulation.currentFrame - BattleUtils.timeDataToFrame(action.timeParameter!, simulation.fps);
            endActions.putIfAbsent(endFrame, () => []);
            endActions[endFrame]!.add(BattleRaptureAction(BattleRaptureActionType.invincibleEnd));
          }
          break;
        case BattleRaptureActionType.invincibleEnd:
          invincible = false;
          break;
        case BattleRaptureActionType.redCircle:
          hasRedCircle = true;
          if (action.timeParameter != null) {
            final endFrame =
                simulation.currentFrame - BattleUtils.timeDataToFrame(action.timeParameter!, simulation.fps);
            endActions.putIfAbsent(endFrame, () => []);
            endActions[endFrame]!.add(BattleRaptureAction(BattleRaptureActionType.redCircleEnd));
          }
          break;
        case BattleRaptureActionType.redCircleEnd:
          hasRedCircle = false;
          break;
        case BattleRaptureActionType.elementalShield:
          elementalShield.addAll(action.eleShields!);
          if (action.timeParameter != null) {
            final endFrame =
                simulation.currentFrame - BattleUtils.timeDataToFrame(action.timeParameter!, simulation.fps);
            endActions.putIfAbsent(endFrame, () => []);
            endActions[endFrame]!.add(BattleRaptureAction(BattleRaptureActionType.elementalShieldEnd));
          }
          break;
        case BattleRaptureActionType.elementalShieldEnd:
          elementalShield.clear();
          break;
        case BattleRaptureActionType.generateBarrier:
          barrier = Barrier(action.setParameter!, action.durationType!, action.timeParameter ?? 0);
          break;
        case BattleRaptureActionType.generateParts:
          final partId = action.setParameter!;

          if (options.parts.containsKey(partId) && parts.every((part) => part.id != partId)) {
            parts.add(options.parts[partId]!.copy());
          }

          break;
        case BattleRaptureActionType.attack:
          for (final target in getActionTargets(simulation, action)) {
            if (target is! BattleNikke) continue;

            simulation.registerEvent(
              simulation.currentFrame,
              RaptureDamageEvent(simulation: simulation, rapture: this, nikke: target, damageRate: action.setParameter!),
            );
          }
          break;
        case BattleRaptureActionType.setBuff:
          for (final target in getActionTargets(simulation, action)) {
            final buff = BattleBuff(
              FunctionData(
                id: -1,
                groupId: -(action.setParameter! * 1000 + action.buffType!.index),
                buff: action.isBuff! ? BuffType.buff : BuffType.deBuff,
                buffRemove: BuffRemoveType.clear,
                functionType: action.buffType!,
                functionValueType: ValueType.percent,
                functionValue: action.setParameter!,
                functionStandard: StandardType.user,
                fullCount: 99,
                durationType: action.durationType!,
                durationValue: action.timeParameter!,
                functionTarget: FunctionTargetType.self,
                timingTriggerType: TimingTriggerType.none,
                statusTriggerType: StatusTriggerType.none,
                statusTrigger2Type: StatusTriggerType.none,
              ),
              uniqueId,
              target.uniqueId,
              simulation,
            );
            target.buffs.add(buff);
          }
          break;
        case BattleRaptureActionType.clearBuff:
        for (final target in getActionTargets(simulation, action)) {
          target.buffs.removeWhere(
                  (buff) {
                    final canRemove = buff.data.buffRemove == BuffRemoveType.clear;
                    final isBuff = [BuffType.buff, BuffType.buffEtc].contains(buff.data.buff);
                    final isDebuff = [BuffType.deBuffEtc, BuffType.deBuff].contains(buff.data.buff);
                    return canRemove && ((isBuff && action.isBuff!) || (isDebuff && !action.isBuff!));
                  }
          );
        }
        break;
      }
    }
  }

  List<BattleEntity> getActionTargets(BattleSimulation simulation, BattleRaptureAction action) {
    switch (action.targetType!) {
      case BattleRaptureActionTarget.allNikkes:
        return simulation.nikkes.toList();
      case BattleRaptureActionTarget.allRaptures:
        return simulation.raptures.toList();
      case BattleRaptureActionTarget.allRapturesExceptSelf:
        return simulation.raptures.toList()..remove(this);
      case BattleRaptureActionTarget.allActors:
        return [...simulation.nikkes, ...simulation.raptures];
      case BattleRaptureActionTarget.self:
        return [this];
      case BattleRaptureActionTarget.targetedNikkes:
        final nikkes = simulation.nikkes.toList();
        final subtype = action.targetSubtype!;
        nikkes.sort((a, b) => getSortingStat(simulation, a, subtype) - getSortingStat(simulation, b, subtype));

        final countList = action.sortHigh! ? nikkes.reversed.toList() : nikkes;
        return countList.sublist(0, min(countList.length, action.targetCount!));
    }
  }
}
