// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation/enums.dart';
import 'package:sj_manager/models/simulation/database/simulation_database.dart';

class UserSimulation {
  const UserSimulation({
    required this.id,
    required this.name,
    required this.saveTime,
    required this.mode,
    required this.subteamCountryFlagPath,
    required this.database,
  });

  final String id;
  final String name;
  final DateTime saveTime;
  final SimulationMode mode;
  final String? subteamCountryFlagPath;
  final SimulationDatabase? database;

  bool get loaded => database != null;

  Json toJson() {
    return {
      'id': id,
      'name': name,
      'saveTime': saveTime.toIso8601String(),
      'subteamCountryFlagPath': subteamCountryFlagPath,
      'mode': mode.name,
    };
  }

  factory UserSimulation.fromJson(Map<String, dynamic> json) {
    return UserSimulation(
      id: json['id'] as String,
      name: json['name'] as String,
      saveTime: DateTime.parse(json['saveTime'] as String),
      mode: SimulationMode.values.singleWhere((mode) => mode.name == json['mode']),
      subteamCountryFlagPath: json['subteamCountryFlagPath'],
      database: null,
    );
  }

  UserSimulation copyWith({
    String? id,
    String? name,
    DateTime? saveTime,
    SimulationMode? mode,
    String? subteamCountryFlagPath,
    SimulationDatabase? database,
  }) {
    return UserSimulation(
      id: id ?? this.id,
      name: name ?? this.name,
      saveTime: saveTime ?? this.saveTime,
      mode: mode ?? this.mode,
      subteamCountryFlagPath: subteamCountryFlagPath ?? this.subteamCountryFlagPath,
      database: database ?? this.database,
    );
  }
}
