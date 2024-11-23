import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/core/general_utils/multilingual_string.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_mode.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/subteam_type.dart';

class SjmSimulationModel {
  const SjmSimulationModel({
    required this.id,
    required this.name,
    required this.saveTime,
    required this.mode,
    required this.currentDate,
    required this.chargesCount,
    required this.subteamCountryName,
    required this.subteamType,
  });

  final String id;
  final String name;
  final DateTime saveTime;
  final SimulationMode mode;
  final DateTime currentDate;
  final int? chargesCount;
  final MultilingualString? subteamCountryName;
  final SubteamType? subteamType;

  Json toJson() {
    return {
      'id': id,
      'name': name,
      'saveTime': saveTime.toIso8601String(),
      'mode': mode,
      'currentDate': currentDate.toString(),
      'chargesCount': chargesCount,
      'subteamCountryName': subteamCountryName?.toJson(),
      'subteamType': subteamType?.name,
    };
  }

  factory SjmSimulationModel.fromJson(Map<String, dynamic> json) {
    return SjmSimulationModel(
        id: json['id'] as String,
        name: json['name'] as String,
        saveTime: DateTime.parse(json['saveTime'] as String),
        mode: SimulationMode.values.firstWhere((mode) => mode.name == json['mode']),
        currentDate: DateTime.parse(json['currentDate']),
        chargesCount: json['chargesCount'],
        subteamCountryName: MultilingualString.fromJson(json['subteamCountryName']),
        subteamType: SubteamType.values
            .singleWhere((subteamType) => subteamType.name == json['subteamType']));
  }

  SjmSimulationModel copyWith({
    String? id,
    String? name,
    DateTime? saveTime,
    SimulationMode? mode,
    DateTime? currentDate,
    int? chargesCount,
    MultilingualString? subteamCountryName,
    SubteamType? subteamType,
  }) {
    return SjmSimulationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      saveTime: saveTime ?? this.saveTime,
      mode: mode ?? this.mode,
      currentDate: currentDate ?? this.currentDate,
      chargesCount: chargesCount ?? this.chargesCount,
      subteamCountryName: subteamCountryName ?? this.subteamCountryName,
      subteamType: subteamType ?? this.subteamType,
    );
  }
}
