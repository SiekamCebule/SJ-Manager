import 'package:sj_manager/features/competitions/domain/entities/scoring/score/competition_scores.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/score.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/simulation_season.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';
import 'package:sj_manager/to_embrace/competition/competition.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series.dart';
import 'package:sj_manager/core/core_classes/hill/hill.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/subjects/competition_team.dart';

abstract class CompetitionScoreCreatingContext<T> {
  const CompetitionScoreCreatingContext({
    required this.subject,
    required this.simulationDatabase,
    required this.season,
    required this.eventSeries,
    required this.competition,
    required this.currentRound,
    required this.hill,
    required this.currentScore,
  });
  final T subject;
  final SimulationDatabase simulationDatabase;
  final SimulationSeason season;
  final EventSeries eventSeries;
  final Competition<T> competition;
  final int currentRound;
  final Hill hill;
  final Score<T>? currentScore;
}

class IndividualCompetitionScoreCreatingContext
    extends CompetitionScoreCreatingContext<SimulationJumper> {
  const IndividualCompetitionScoreCreatingContext({
    required super.subject,
    required super.simulationDatabase,
    required super.season,
    required super.eventSeries,
    required super.competition,
    required super.currentRound,
    required super.hill,
    required super.currentScore,
    required this.lastJumpScore,
  });

  final CompetitionJumpScore lastJumpScore;
}

class TeamCompetitionScoreCreatingContext
    extends CompetitionScoreCreatingContext<CompetitionTeam> {
  const TeamCompetitionScoreCreatingContext({
    required super.subject,
    required super.simulationDatabase,
    required super.season,
    required super.eventSeries,
    required super.competition,
    required super.currentRound,
    required super.hill,
    required super.currentScore,
    required this.currentGroup,
    required this.lastJumpScore,
  });

  final int? currentGroup;
  final CompetitionJumpScore lastJumpScore;
}
