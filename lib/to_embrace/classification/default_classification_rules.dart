import 'package:equatable/equatable.dart';
import 'package:sj_manager/to_embrace/classification/classification.dart';
import 'package:sj_manager/to_embrace/competition/competition.dart';
import 'package:sj_manager/to_embrace/competition/rules/utils/classification_score_creator/classification_score_creator.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/score/details/classification_score_details.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/standings.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/team.dart';

abstract class ClassificationRules<E> {
  const ClassificationRules({
    required this.classificationScoreCreator,
  });

  final ClassificationScoreCreator<
      E,
      ClassificationScoreCreatingContext<
          E,
          Classification<E, Standings<E, ClassificationScoreDetails>,
              ClassificationRules<E>>>> classificationScoreCreator;
}

abstract class DefaultClassificationRules<E> extends ClassificationRules<E>
    with EquatableMixin {
  const DefaultClassificationRules({
    required super.classificationScoreCreator,
    required this.scoringType,
    required this.pointsMap,
    required this.competitions,
    required this.pointsModifiers,
  });

  final DefaultClassificationScoringType scoringType;
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

class DefaultIndividualClassificationRules
    extends DefaultClassificationRules<JumperDbRecord> {
  const DefaultIndividualClassificationRules({
    required super.classificationScoreCreator,
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

class DefaultTeamClassificationRules extends DefaultClassificationRules<Team> {
  const DefaultTeamClassificationRules({
    required super.classificationScoreCreator,
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

enum DefaultClassificationScoringType {
  pointsFromCompetitions,
  pointsFromMap,
}
