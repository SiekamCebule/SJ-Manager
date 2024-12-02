import 'package:equatable/equatable.dart';
import 'package:sj_manager/features/competitions/domain/utils/classification_score_creator/classification_score_creator.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/to_embrace/competition/competition.dart';

abstract class ClassificationRules<E> {
  const ClassificationRules({
    required this.scoreCreator,
  });

  final ClassificationScoreCreator<E> scoreCreator;
}

abstract class SimpleClassificationRules<E> extends ClassificationRules<E>
    with EquatableMixin {
  const SimpleClassificationRules({
    required super.scoreCreator,
    required this.scoringType,
    required this.pointsMap,
    required this.competitions,
    required this.pointsModifiers,
  });

  final SimpleClassificationScoringType scoringType;
  final Map<int, double>? pointsMap;
  final List<Competition> competitions;
  final Map<Competition, double> pointsModifiers;

  @override
  List<Object?> get props => [
        scoringType,
        pointsMap,
        competitions,
        pointsModifiers,
      ];
}

class SimpleIndividualClassificationRules
    extends SimpleClassificationRules<SimulationJumper> {
  const SimpleIndividualClassificationRules({
    required super.scoreCreator,
    required super.scoringType,
    required super.pointsMap,
    required super.competitions,
    required super.pointsModifiers,
    required this.includeApperancesInTeamCompetitions,
  });

  final bool includeApperancesInTeamCompetitions;

  @override
  List<Object?> get props => [
        ...super.props,
        includeApperancesInTeamCompetitions,
      ];
}

class SimpleTeamClassificationRules extends SimpleClassificationRules<dynamic> {
  const SimpleTeamClassificationRules({
    required super.scoreCreator,
    required super.scoringType,
    required super.pointsMap,
    required super.competitions,
    required super.pointsModifiers,
    required this.includeJumperPointsFromIndividualCompetitions,
  });

  final bool includeJumperPointsFromIndividualCompetitions;

  @override
  List<Object?> get props => [
        ...super.props,
        includeJumperPointsFromIndividualCompetitions,
      ];
}

enum SimpleClassificationScoringType {
  pointsFromCompetitions,
  pointsFromMap,
}
