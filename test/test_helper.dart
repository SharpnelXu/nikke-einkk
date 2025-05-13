import 'package:nikke_einkk/model/db.dart';

class TestHelper {
  TestHelper._();

  static Future<bool> loadData() async {
    if (!gameData.dataLoaded) {
      await gameData.loadData();
    }

    return gameData.dataLoaded;
  }
}

class Pair<A, B> {
  A value1;
  B value2;

  Pair(this.value1, this.value2);
}