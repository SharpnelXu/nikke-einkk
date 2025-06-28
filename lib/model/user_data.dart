import 'package:json_annotation/json_annotation.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/harmony_cube.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/db.dart';

part '../generated/model/user_data.g.dart';

@JsonSerializable()
class UserData {
  Language language;
  BattlePlayerOptions playerOptions = BattlePlayerOptions();
  Map<int, BattleNikkeOptions> nikkeOptions = {};
  List<BattleHarmonyCubeOption> cubes = [];

  UserData({
    this.language = Language.en,
    BattlePlayerOptions? playerOptions,
    Map<int, BattleNikkeOptions> nikkeOptions = const {},
    List<BattleHarmonyCubeOption> cubes = const [],
  }) {
    if (playerOptions != null) {
      this.playerOptions = playerOptions.copy();
    }
    for (final id in nikkeOptions.keys) {
      this.nikkeOptions[id] = nikkeOptions[id]!.copy();
    }
    this.cubes.addAll(cubes.map((cube) => cube.copy()));
  }

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

@JsonSerializable()
class BattleSetup {
  late BattlePlayerOptions playerOptions;
  List<BattleNikkeOptions> nikkeOptions = [];
  late BattleRaptureOptions raptureOptions;

  BattleSetup({
    required BattlePlayerOptions playerOptions,
    List<BattleNikkeOptions> nikkeOptions = const [],
    required BattleRaptureOptions raptureOptions,
  }) {
    this.playerOptions = playerOptions.copy();
    this.nikkeOptions.addAll(nikkeOptions.map((option) => option.copy()));
    this.raptureOptions = raptureOptions.copy();
  }

  factory BattleSetup.fromJson(Map<String, dynamic> json) => _$BattleSetupFromJson(json);

  Map<String, dynamic> toJson() => _$BattleSetupToJson(this);
}
