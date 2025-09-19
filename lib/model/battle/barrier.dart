import 'package:nikke_einkk/model/skills.dart';

class Barrier {
  int id;
  int hp;
  int maxHp;
  int duration;
  DurationType durationType;

  Barrier(this.id, this.hp, this.maxHp, this.durationType, this.duration);
}
