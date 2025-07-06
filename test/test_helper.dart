import 'package:nikke_einkk/model/db.dart';

class TestHelper {
  TestHelper._();

  static void loadData() {
    if (!global.initialized) {
      global.init();
    }
    if (!cn.initialized) {
      cn.init();
    }
  }

  static void loadUserDb() {
    if (!userDb.initialized) {
      userDb.init();
    }
  }
}

class Pair<A, B> {
  A value1;
  B value2;

  Pair(this.value1, this.value2);
}
