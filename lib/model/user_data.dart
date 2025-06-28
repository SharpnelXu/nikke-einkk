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
  BattlePlayerOptions globalPlayerOptions = BattlePlayerOptions();
  Map<int, BattleNikkeOptions> globalNikkeOptions = {};
  BattlePlayerOptions cnPlayerOptions = BattlePlayerOptions();
  Map<int, BattleNikkeOptions> cnNikkeOptions = {};

  UserData({
    this.language = Language.en,
    BattlePlayerOptions? globalPlayerOptions,
    Map<int, BattleNikkeOptions> globalNikkeOptions = const {},
    BattlePlayerOptions? cnPlayerOptions,
    Map<int, BattleNikkeOptions> cnNikkeOptions = const {},
    List<BattleHarmonyCubeOption> cubes = const [],
  }) {
    if (globalPlayerOptions != null) {
      this.globalPlayerOptions = globalPlayerOptions.copy();
    }
    for (final id in globalNikkeOptions.keys) {
      this.globalNikkeOptions[id] = globalNikkeOptions[id]!.copy();
    }
    if (cnPlayerOptions != null) {
      this.cnPlayerOptions = cnPlayerOptions.copy();
    }
    for (final id in cnNikkeOptions.keys) {
      this.cnNikkeOptions[id] = cnNikkeOptions[id]!.copy();
    }
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
