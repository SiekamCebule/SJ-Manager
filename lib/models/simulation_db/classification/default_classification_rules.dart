import 'package:sj_manager/models/simulation_db/classification/classification.dart';
import 'package:sj_manager/models/simulation_db/competition/competition.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/classification_score_creator/classification_score_creator.dart';
import 'package:sj_manager/models/simulation_db/standings/score/details/classification_score_details.dart';
import 'package:sj_manager/models/simulation_db/standings/standings.dart';
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

abstract class DefaultClassificationRules<E> extends ClassificationRules<E> {
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
}

enum DefaultClassificationScoringType {
  pointsFromCompetitions,
  pointsFromMap,
}
