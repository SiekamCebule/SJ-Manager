import 'package:sj_manager/core/general_utils/multilingual_string.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_mode.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/subteam_type.dart';

class SjmSimulation {
  const SjmSimulation({
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

  SjmSimulation copyWith({
    String? id,
    String? name,
    DateTime? saveTime,
    SimulationMode? mode,
    DateTime? currentDate,
    int? chargesCount,
    MultilingualString? subteamCountryName,
    SubteamType? subteamType,
  }) {
    return SjmSimulation(
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
