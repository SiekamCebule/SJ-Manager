import 'package:equatable/equatable.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/simulation_team.dart';

class CompetitionTeam<T extends SimulationTeam> with EquatableMixin {
  const CompetitionTeam({
    required this.parentTeam,
    required this.subjects,
  });

  final T parentTeam;
  final List<dynamic> subjects;

  CompetitionTeam<T> copyWith({T? parentTeam, List<dynamic>? subjects}) {
    return CompetitionTeam(
      parentTeam: parentTeam ?? this.parentTeam,
      subjects: subjects ?? this.subjects,
    );
  }

  @override
  List<Object?> get props => [
        parentTeam,
        subjects,
      ];
}
