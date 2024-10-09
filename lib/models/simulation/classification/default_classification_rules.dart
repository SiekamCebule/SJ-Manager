import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/simulation/classification/classification.dart';
import 'package:sj_manager/models/simulation/competition/competition.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/classification_score_creator/classification_score_creator.dart';
import 'package:sj_manager/models/simulation/standings/score/details/classification_score_details.dart';
import 'package:sj_manager/models/simulation/standings/standings.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';

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

class DefaultIndividualClassificationRules extends DefaultClassificationRules<Jumper> {
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
