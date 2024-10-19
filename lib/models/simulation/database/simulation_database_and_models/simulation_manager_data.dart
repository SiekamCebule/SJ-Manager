import 'package:equatable/equatable.dart';

import 'package:sj_manager/models/simulation/flow/simulation_mode.dart';
import 'package:sj_manager/models/user_db/team/personal_coach_team.dart';
import 'package:sj_manager/models/user_db/team/subteam.dart';

class SimulationManagerData with EquatableMixin {
  const SimulationManagerData({
    required this.mode,
    required this.userSubteam,
    required this.personalCoachTeam,
    required this.trainingPoints,
  });

  final SimulationMode mode;

  // For classic coach
  final Subteam? userSubteam;

  // For personal coach
  final PersonalCoachTeam? personalCoachTeam;

  // For training purposes
  final int trainingPoints;

  @override
  List<Object?> get props => [
        mode,
        userSubteam,
        personalCoachTeam,
        trainingPoints,
      ];

  SimulationManagerData copyWith({
    SimulationMode? mode,
    Subteam? userSubteam,
    PersonalCoachTeam? personalCoachTeam,
    int? trainingPoints,
  }) {
    return SimulationManagerData(
      mode: mode ?? this.mode,
      userSubteam: userSubteam ?? this.userSubteam,
      personalCoachTeam: personalCoachTeam ?? this.personalCoachTeam,
      trainingPoints: trainingPoints ?? this.trainingPoints,
    );
  }
}
