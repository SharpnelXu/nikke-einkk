import 'package:nikke_einkk/model/db.dart';

class TestHelper {
  TestHelper._();

  static Future<bool> loadData() async {
    if (!db.dataLoaded) {
      await db.loadData();
    }

    return db.dataLoaded;
  }
}

class Pair<A, B> {
  A value1;
  B value2;

  Pair(this.value1, this.value2);
}
