import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/domain/entities/simulation/flow/simulation_mode.dart';
import 'package:sj_manager/domain/entities/simulation/database/simulation_database_and_models/simulation_database.dart';

class SimulationModel {
  const SimulationModel({
    required this.id,
    required this.name,
    required this.saveTime,
    required this.mode,
    required this.subteamCountryFlagName,
  });

  final String id;
  final String name;
  final DateTime saveTime;
  final SimulationMode mode;
  final String? subteamCountryFlagName;

  Json toJson() {
    return {
      'id': id,
      'name': name,
      'saveTime': saveTime.toIso8601String(),
      'subteamCountryFlagPath': subteamCountryFlagName,
      'mode': mode.name,
    };
  }

  factory SimulationModel.fromJson(Map<String, dynamic> json) {
    return SimulationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      saveTime: DateTime.parse(json['saveTime'] as String),
      mode: SimulationMode.values.singleWhere((mode) => mode.name == json['mode']),
      subteamCountryFlagName: json['subteamCountryFlagPath'],
    );
  }

  SimulationModel copyWith({
    String? id,
    String? name,
    DateTime? saveTime,
    SimulationMode? mode,
    String? subteamCountryFlagPath,
    SimulationDatabase? database,
  }) {
    return SimulationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      saveTime: saveTime ?? this.saveTime,
      mode: mode ?? this.mode,
      subteamCountryFlagName: subteamCountryFlagPath ?? this.subteamCountryFlagName,
    );
  }
}
