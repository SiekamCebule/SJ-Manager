import 'package:equatable/equatable.dart';
import 'package:sj_manager/to_embrace/competition/competition.dart';
import 'package:sj_manager/to_embrace/competition/rules/utils/general/entity_related_algorithm_context.dart';
import 'package:sj_manager/to_embrace/competition/rules/user_algorithms/unary_algorithm.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/score/details/competition_score_details.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/score/details/jump_score_details.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/score/score.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/standings.dart';
import 'package:sj_manager/core/core_classes/hill/hill.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/specific_teams/competition_team.dart';

abstract class CompetitionScoreCreatingContext<T>
    extends EntityRelatedAlgorithmContext<T> {
  const CompetitionScoreCreatingContext({
    required super.entity,
    required this.eventSeries,
    required this.competition,
    required this.currentRound,
    required this.hill,
    required this.currentScore,
  });

  // TODO: final SimulationData simulationData;
  // TODO: final Season season;
  final EventSeries eventSeries;
  final Competition<T, Standings> competition;
  final int currentRound;
  final Hill hill;
  final Score<T, dynamic>? currentScore;
}

class IndividualCompetitionScoreCreatingContext
    extends CompetitionScoreCreatingContext<JumperDbRecord> {
  const IndividualCompetitionScoreCreatingContext({
    required super.entity,
    required super.eventSeries,
    required super.competition,
    required super.currentRound,
    required super.hill,
    required super.currentScore,
    required this.lastJumpScore,
  });

  final Score<JumperDbRecord, JumpScoreDetails> lastJumpScore;
}

class TeamCompetitionScoreCreatingContext
    extends CompetitionScoreCreatingContext<CompetitionTeam> {
  const TeamCompetitionScoreCreatingContext({
    required super.entity,
    required super.eventSeries,
    required super.competition,
    required super.currentRound,
    required super.hill,
    required super.currentScore,
    required this.currentGroup,
    required this.lastJumpScore,
  });

  final int? currentGroup;
  final Score<JumperDbRecord, JumpScoreDetails> lastJumpScore;
}

abstract class CompetitionScoreCreator<S extends Score<dynamic, CompetitionScoreDetails>>
    with EquatableMixin
    implements UnaryAlgorithm<CompetitionScoreCreatingContext, S> {
  @override
  List<Object?> get props => [
        runtimeType,
      ];
}
