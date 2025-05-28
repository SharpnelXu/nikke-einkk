import 'package:json_annotation/json_annotation.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/harmony_cube.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';

part '../generated/model/user_data.g.dart';

@JsonSerializable()
class UserData {
  BattlePlayerOptions playerOptions = BattlePlayerOptions();
  Map<int, BattleNikkeOptions> nikkeOptions = {};
  List<BattleHarmonyCube> cubes = [];

  UserData({
    BattlePlayerOptions? playerOptions,
    Map<int, BattleNikkeOptions> nikkeOptions = const {},
    List<BattleHarmonyCube> cubes = const [],
  }) {
    if (playerOptions != null) {
      this.playerOptions = playerOptions;
    }
    this.nikkeOptions.addAll(nikkeOptions);
    this.cubes.addAll(cubes);
  }

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
