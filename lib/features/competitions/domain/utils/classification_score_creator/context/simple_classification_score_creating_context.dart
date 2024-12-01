import 'package:sj_manager/features/competitions/domain/entities/scoring/score/classification_scores.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/subjects/classification_team.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/simulation_season.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/simulation_team.dart';
import 'package:sj_manager/to_embrace/classification/classification.dart';
import 'package:sj_manager/to_embrace/competition/competition.dart';

abstract class SimpleClassificationScoreCreatingContext<T> {
  const SimpleClassificationScoreCreatingContext({
    required this.subject,
    required this.simulationDatabase,
    required this.season,
    required this.eventSeries,
    required this.lastCompetition,
    required this.classification,
    required this.currentScore,
  });

  final T subject;
  final SimulationDatabase simulationDatabase;
  final SimulationSeason season;
  final EventSeries eventSeries;
  final Competition lastCompetition;
  final SimpleClassification<T> classification;
  final ClassificationScore? currentScore;
}

class SimpleClassificationJumperScoreCreatingContext
    extends SimpleClassificationScoreCreatingContext<SimulationJumper> {
  const SimpleClassificationJumperScoreCreatingContext({
    required super.subject,
    required super.simulationDatabase,
    required super.season,
    required super.eventSeries,
    required super.lastCompetition,
    required super.classification,
    required super.currentScore,
  });
}

class SimpleClassificationTeamScoreCreatingContext
    extends SimpleClassificationScoreCreatingContext<ClassificationTeam> {
  const SimpleClassificationTeamScoreCreatingContext({
    required super.subject,
    required super.simulationDatabase,
    required super.season,
    required super.eventSeries,
    required super.lastCompetition,
    required super.classification,
    required super.currentScore,
    required this.simulationTeam,
  });

  final SimulationTeam simulationTeam;
}
