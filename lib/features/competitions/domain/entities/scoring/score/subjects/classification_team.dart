import 'package:equatable/equatable.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/simulation_team.dart';

class ClassificationTeam<T extends SimulationTeam> with EquatableMixin {
  const ClassificationTeam({
    required this.parentTeam,
  });

  final T parentTeam;

  @override
  List<Object?> get props => [
        parentTeam,
      ];

  ClassificationTeam<T> copyWith({
    T? parentTeam,
  }) {
    return ClassificationTeam<T>(
      parentTeam: parentTeam ?? this.parentTeam,
    );
  }
}
