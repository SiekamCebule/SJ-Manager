import 'package:equatable/equatable.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/simulation_team.dart';

class CompetitionTeam<T extends SimulationTeam> with EquatableMixin {
  const CompetitionTeam({
    required this.parentTeam,
    required this.jumpers,
  });

  final T parentTeam;
  final List<SimulationJumper> jumpers;

  CompetitionTeam<T> copyWith({T? parentTeam, List<SimulationJumper>? jumpers}) {
    return CompetitionTeam(
      parentTeam: parentTeam ?? this.parentTeam,
      jumpers: jumpers ?? this.jumpers,
    );
  }

  @override
  List<Object?> get props => [
        parentTeam,
        jumpers,
      ];
}
