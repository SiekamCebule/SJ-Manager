import 'package:equatable/equatable.dart';

import 'package:sj_manager/data/models/simulation/flow/simulation_mode.dart';
import 'package:sj_manager/data/models/database/team/personal_coach_team.dart';
import 'package:sj_manager/data/models/database/team/subteam.dart';

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
