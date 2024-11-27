import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam_type.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/team.dart';

class Subteam extends Team {
  Subteam({
    required this.parentTeam,
    required this.type,
    required this.jumpers,
  });

  Team parentTeam;
  SubteamType type;
  Iterable<SimulationJumper> jumpers;

  @override
  List<Object?> get props => [
        parentTeam,
        type,
      ];
}
