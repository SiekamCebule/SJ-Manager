import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/data/models/simulation/flow/simulation_mode.dart';
import 'package:sj_manager/data/models/simulation/database/simulation_database_and_models/simulation_database.dart';

class UserSimulationModel {
  const UserSimulationModel({
    required this.id,
    required this.name,
    required this.saveTime,
    required this.mode,
    required this.subteamCountryFlagPath,
  });

  final String id;
  final String name;
  final DateTime saveTime;
  final SimulationMode mode;
  final String? subteamCountryFlagPath;

  Json toJson() {
    return {
      'id': id,
      'name': name,
      'saveTime': saveTime.toIso8601String(),
      'subteamCountryFlagPath': subteamCountryFlagPath,
      'mode': mode.name,
    };
  }

  factory UserSimulationModel.fromJson(Map<String, dynamic> json) {
    return UserSimulationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      saveTime: DateTime.parse(json['saveTime'] as String),
      mode: SimulationMode.values.singleWhere((mode) => mode.name == json['mode']),
      subteamCountryFlagPath: json['subteamCountryFlagPath'],
    );
  }

  UserSimulationModel copyWith({
    String? id,
    String? name,
    DateTime? saveTime,
    SimulationMode? mode,
    String? subteamCountryFlagPath,
    SimulationDatabase? database,
  }) {
    return UserSimulationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      saveTime: saveTime ?? this.saveTime,
      mode: mode ?? this.mode,
      subteamCountryFlagPath: subteamCountryFlagPath ?? this.subteamCountryFlagPath,
    );
  }
}
