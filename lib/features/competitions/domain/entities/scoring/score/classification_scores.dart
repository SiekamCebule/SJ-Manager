import 'package:sj_manager/features/competitions/domain/entities/scoring/score/competition_scores.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/score.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/subjects/classification_team.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/to_embrace/classification/classification.dart';

abstract class ClassificationScore<T> extends Score<T> {
  const ClassificationScore({
    required super.subject,
    required this.classification,
  });

  final Classification classification;
}

class ClassificationJumperScore extends ClassificationScore<SimulationJumper> {
  const ClassificationJumperScore({
    required super.subject,
    required super.classification,
    required this.competitionScores,
    required this.points,
  });

  final List<CompetitionScore> competitionScores;

  @override
  final double points;

  @override
  List<Object?> get props => [subject, competitionScores, points];
}

class ClassificationTeamScore extends ClassificationScore<ClassificationTeam> {
  const ClassificationTeamScore({
    required super.subject,
    required super.classification,
    required this.competitionScores,
    required this.points,
  });

  final List<CompetitionScore> competitionScores;

  @override
  final double points;

  @override
  List<Object?> get props => [subject, competitionScores, points];
}
