import 'package:sj_manager/models/simulation_db/competition/competition.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/user_algorithms/entity_related_algorithm_context.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/user_algorithms/unary_algorithm.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/competition_scores.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/single_jump_score.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';

abstract class CompetitionScoreCreatingContext<T>
    extends EntityRelatedAlgorithmContext<T> {
  const CompetitionScoreCreatingContext({
    required super.entity,
    required this.eventSeries,
    required this.competition,
    required this.currentRound,
    required this.hill,
    required this.currentCompetitionScore,
  });

  // TODO: final SimulationData simulationData;
  // TODO: final Season season;
  final EventSeries eventSeries;
  final Competition<T> competition;
  final int currentRound;
  final Hill hill;
  final CompetitionScore<T, dynamic>? currentCompetitionScore;
}

class IndividualCompetitionScoreCreatingContext
    extends CompetitionScoreCreatingContext<Jumper> {
  const IndividualCompetitionScoreCreatingContext({
    required super.entity,
    required super.eventSeries,
    required super.competition,
    required super.currentRound,
    required super.hill,
    required super.currentCompetitionScore,
    required this.lastJumpScore,
  });

  final SingleJumpScore<Jumper> lastJumpScore;
}

class TeamCompetitionScoreCreatingContext extends CompetitionScoreCreatingContext<Team> {
  const TeamCompetitionScoreCreatingContext({
    required super.entity,
    required super.eventSeries,
    required super.competition,
    required super.currentRound,
    required super.hill,
    required super.currentCompetitionScore,
    required this.currentGroup,
    required this.lastJumpScore,
  });

  final int? currentGroup;
  final SingleJumpScore<Jumper> lastJumpScore;
}

abstract class CompetitionScoreCreator<S extends CompetitionScore>
    implements UnaryAlgorithm<CompetitionScoreCreatingContext, S> {}
