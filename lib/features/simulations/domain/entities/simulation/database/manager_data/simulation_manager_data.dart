import 'package:equatable/equatable.dart';

import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_mode.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/specific_teams/personal_coach_team.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam.dart';

class SimulationManagerData with EquatableMixin {
  SimulationManagerData({
    required this.mode,
    required this.userSubteam,
    required this.personalCoachTeam,
  });

  SimulationMode mode;

  // For classic coach
  Subteam? userSubteam;

  // For personal coach
  PersonalCoachTeam? personalCoachTeam;

  @override
  List<Object?> get props => [
        mode,
        userSubteam,
        personalCoachTeam,
      ];

  SimulationManagerData copyWith({
    SimulationMode? mode,
    Subteam? userSubteam,
    PersonalCoachTeam? personalCoachTeam,
  }) {
    return SimulationManagerData(
      mode: mode ?? this.mode,
      userSubteam: userSubteam ?? this.userSubteam,
      personalCoachTeam: personalCoachTeam ?? this.personalCoachTeam,
    );
  }
}
