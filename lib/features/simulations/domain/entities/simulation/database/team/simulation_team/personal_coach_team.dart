import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/simulation_team.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

class PersonalCoachTeam extends SimulationTeam {
  PersonalCoachTeam({
    required this.jumpers,
    required super.reports,
  });

  @override
  List<SimulationJumper> jumpers;

  @override
  List<Object?> get props => [
        ...super.props,
        jumpers,
      ];
}
