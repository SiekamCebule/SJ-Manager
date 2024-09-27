import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/enums.dart';
import 'package:sj_manager/models/simulation_db/simulation_database.dart';

class UserSimulation {
  const UserSimulation({
    required this.id,
    required this.name,
    required this.saveTime,
    required this.mode,
    required this.database,
  });

  final String id;
  final String name;
  final DateTime saveTime;
  final SimulationMode mode;
  final SimulationDatabase? database;

  bool get loaded => database != null;

  UserSimulation copyWith({
    String? id,
    String? name,
    SimulationDatabase? database,
    SimulationMode? mode,
  }) {
    return UserSimulation(
      id: id ?? this.id,
      name: name ?? this.name,
      saveTime: saveTime,
      database: database ?? this.database,
      mode: mode ?? this.mode,
    );
  }

  Json toJson() {
    return {
      'id': id,
      'name': name,
      'saveTime': saveTime.toIso8601String(),
      'mode': mode.name,
    };
  }

  factory UserSimulation.fromJson(Map<String, dynamic> json) {
    return UserSimulation(
      id: json['id'] as String,
      name: json['name'] as String,
      saveTime: DateTime.parse(json['saveTime'] as String),
      mode: SimulationMode.values.singleWhere((mode) => mode.name == json['mode']),
      database: null,
    );
  }
}
