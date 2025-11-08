import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/equipment.dart';

import '../items.dart';

abstract class RollStrategy {
  RollResult execute(NikkeDatabase db, List<EquipmentLineModel> equips, List<EquipLineExpectation> targets);

  /// Run the strategy for a number of times and collect statistics
  /// - [count]: number of simulations to run
  /// - [db]: the Nikke database
  /// - [initialState]: the initial state of the equipments (4 equipments, each with 3 lines)
  /// - [targets]: the target expectations for the rolls, ordered by priority, NO DUPLICATED TYPES
  RollStrategyResult run(
    int count,
    NikkeDatabase db,
    List<List<EquipLine>> initialState,
    List<EquipLineExpectation> targets,
  ) {
    if (count < 0) throw ArgumentError.value(count, 'count', 'must be non-negative');
    if (initialState.length != 4) {
      throw ArgumentError.value(initialState, 'initialState', 'must have exactly 4 equipments');
    }

    final results = RollStrategyResult(count);
    for (var i = 0; i < count; i++) {
      final equips = initialState.map((lines) => EquipmentLineModel.from(lines)).toList();
      results.accept(execute(db, equips, targets), db);
    }
    return results;
  }
}

abstract class SingleEquipRollStrategy {
  RollResult execute(NikkeDatabase db, EquipmentLineModel equip, List<EquipLineExpectation> targets);

  /// Run the strategy for a number of times and collect statistics
  /// - [count]: number of simulations to run
  /// - [db]: the Nikke database
  /// - [initialState]: the initial state of the equipment
  /// - [targets]: the target expectations for the rolls, ordered by priority, NO DUPLICATED TYPES
  RollStrategyResult run(
    int count,
    NikkeDatabase db,
    List<EquipLine> initialState,
    List<EquipLineExpectation> targets,
  ) {
    if (count < 0) throw ArgumentError.value(count, 'count', 'must be non-negative');
    if (initialState.length > 3) {
      throw ArgumentError.value(initialState, 'initialState', 'must have at most 3 lines');
    }
    for (final expectation in targets) {
      if (expectation.lineCount > 2 || expectation.lineCount < 0) {
        throw ArgumentError.value(targets, 'targets', 'lineCount in expectation must be either 1 or 0');
      }
    }

    final results = RollStrategyResult(count);
    for (var i = 0; i < count; i++) {
      final equips = EquipmentLineModel.from(initialState);
      results.accept(execute(db, equips, targets), db);
    }
    return results;
  }
}

class EquipLineExpectation {
  EquipLineType type;
  int lineCount; // 0 means must not have this line
  int? minValue; // valid range should be determined by lineCount
  int? lockThreshold;

  EquipLineExpectation({required this.type, required this.lineCount, this.minValue, this.lockThreshold});
}

class RollResult {
  final List<EquipLine> finalLines;
  final int rollsUsed;
  final int rocksUsed;

  RollResult(this.finalLines, this.rollsUsed, this.rocksUsed);
}

class RollStrategyResult {
  int totalRolls = 0;
  int totalRocks = 0;
  int testNum;

  num get avgRocksUsed => testNum > 0 ? totalRocks / testNum : 0;
  num get avgRollsUsed => testNum > 0 ? totalRolls / testNum : 0;

  int minRollsUsed = -1;
  int maxRollsUsed = -1;
  int minRocksUsed = -1;
  int maxRocksUsed = -1;

  Map<EquipLineType, int> equipLineValues = {};

  RollStrategyResult(this.testNum);

  void accept(RollResult result, NikkeDatabase db) {
    totalRolls += result.rollsUsed;
    totalRocks += result.rocksUsed;

    if (minRollsUsed == -1 || result.rollsUsed < minRollsUsed) {
      minRollsUsed = result.rollsUsed;
    }
    if (maxRollsUsed == -1 || result.rollsUsed > maxRollsUsed) {
      maxRollsUsed = result.rollsUsed;
    }

    if (minRocksUsed == -1 || result.rocksUsed < minRocksUsed) {
      minRocksUsed = result.rocksUsed;
    }
    if (maxRocksUsed == -1 || result.rocksUsed > maxRocksUsed) {
      maxRocksUsed = result.rocksUsed;
    }

    for (final line in result.finalLines) {
      if (line.type == EquipLineType.none) continue;
      final lineVal = line.getValue(db);
      equipLineValues.update(line.type, (value) => value + lineVal, ifAbsent: () => lineVal);
    }
  }
}
