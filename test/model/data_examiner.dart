import 'package:flutter_test/flutter_test.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/skills.dart';

import '../test_helper.dart';

void main() async {
  await TestHelper.loadData();

  group('Data Examine', () {
    test('funcType & status', () {
      final Set<FunctionType> types = {FunctionType.burstGaugeCharge};
      final Set<StatusTriggerType> statusTriggers = {};
      for (final function in gameData.functionTable.values) {
        if (types.contains(function.functionType)) {
          statusTriggers.add(function.statusTriggerType);
          statusTriggers.add(function.statusTrigger2Type);
        }
      }

      logger.i(statusTriggers);
    });
  });
}
