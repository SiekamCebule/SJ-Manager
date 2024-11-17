import 'package:equatable/equatable.dart';
import 'package:sj_manager/domain/entities/simulation/classification/classification.dart';
import 'package:sj_manager/domain/entities/simulation/classification/default_classification_rules.dart';
import 'package:sj_manager/domain/entities/simulation/competition/competition.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/general/entity_related_algorithm_context.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/user_algorithms/unary_algorithm.dart';
import 'package:sj_manager/domain/entities/simulation/event_series/event_series.dart';
import 'package:sj_manager/domain/entities/simulation/standings/score/details/classification_score_details.dart';
import 'package:sj_manager/domain/entities/simulation/standings/score/details/competition_score_details.dart';
import 'package:sj_manager/domain/entities/simulation/standings/standings.dart';
import 'package:sj_manager/features/game_variants/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/domain/entities/simulation/team/team.dart';
import 'package:sj_manager/domain/entities/simulation/standings/score/typedefs.dart';

abstract class ClassificationScoreCreatingContext<
    E,
    C extends Classification<E, Standings<E, ClassificationScoreDetails>,
        ClassificationRules<E>>> extends EntityRelatedAlgorithmContext<E> {
  const ClassificationScoreCreatingContext({
    required super.entity,
    required this.eventSeries,
    required this.lastCompetition,
    required this.classification,
    required this.currentScore,
  });
  // TODO: final SimulationData simulationData;
  // TODO: final Season season;
  final EventSeries eventSeries;
  final Competition<E, Standings<E, CompetitionScoreDetails>> lastCompetition;
  final C classification;
  final ClassificationScore<E>? currentScore;
}

abstract class DefaultClassificationScoreCreatingContext<E>
    extends ClassificationScoreCreatingContext<E,
        DefaultClassification<E, Standings<E, ClassificationScoreDetails>>> {
  const DefaultClassificationScoreCreatingContext({
    required super.entity,
    required super.eventSeries,
    required super.lastCompetition,
    required super.classification,
    required super.currentScore,
  });
}

class DefaultTeamClassificationScoreCreatingContext
    extends DefaultClassificationScoreCreatingContext<Team> {
  const DefaultTeamClassificationScoreCreatingContext({
    required super.entity,
    required super.eventSeries,
    required super.lastCompetition,
    required super.classification,
    required super.currentScore,
    required this.teamJumpersForIndividualCompetitions,
  });

  final List<JumperDbRecord> teamJumpersForIndividualCompetitions;
}

class DefaultIndividualClassificationScoreCreatingContext
    extends DefaultClassificationScoreCreatingContext<JumperDbRecord> {
  const DefaultIndividualClassificationScoreCreatingContext({
    required super.entity,
    required super.eventSeries,
    required super.lastCompetition,
    required super.classification,
    required super.currentScore,
  });
}

abstract class ClassificationScoreCreator<
        E,
        C extends ClassificationScoreCreatingContext<
            E,
            Classification<E, Standings<E, ClassificationScoreDetails>,
                ClassificationRules<E>>>>
    with EquatableMixin
    implements UnaryAlgorithm<C, ClassificationScore<E>> {
  @override
  List<Object?> get props => [
        runtimeType,
      ];
}
