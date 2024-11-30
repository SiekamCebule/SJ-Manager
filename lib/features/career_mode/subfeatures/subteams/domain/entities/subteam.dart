import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam_type.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/country_team.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/simulation_team.dart';

class Subteam extends SimulationTeam {
  Subteam({
    required this.parentTeam,
    required this.type,
    required this.jumpers,
    required this.limit,
  });

  CountryTeam parentTeam;
  SubteamType type;
  Iterable<SimulationJumper> jumpers;
  int limit;

  @override
  List<Object?> get props => [
        parentTeam,
        type,
        jumpers,
        limit,
      ];
}
