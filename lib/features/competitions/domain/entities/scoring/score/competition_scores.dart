import 'package:collection/collection.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/score.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/subjects/competition_team.dart';
import 'package:sj_manager/to_embrace/competition/competition.dart';

abstract class CompetitionScore<T> extends Score<T> {
  const CompetitionScore({
    required super.subject,
    required this.competition,
  });

  final Competition competition;
}

class CompetitionJumpScore extends CompetitionScore<SimulationJumper> {
  const CompetitionJumpScore({
    required super.subject,
    required super.competition,
    required this.points,
    this.distancePoints,
    this.judgePoints,
    this.windPoints,
    this.gatePoints,
  });

  final double? distancePoints;
  final double? judgePoints;
  final double? windPoints;
  final double? gatePoints;

  @override
  final double points;

  @override
  List<Object?> get props =>
      [subject, competition, distancePoints, judgePoints, windPoints, gatePoints, points];
}

class CompetitionJumperScore extends CompetitionScore<SimulationJumper> {
  const CompetitionJumperScore({
    required super.subject,
    required super.competition,
    required this.jumps,
    required this.points,
  });

  final List<CompetitionJumpScore> jumps;

  @override
  final double points;

  @override
  List<Object?> get props => [subject, competition, jumps, points];
}

class CompetitionTeamScore extends CompetitionScore<CompetitionTeam> {
  const CompetitionTeamScore({
    required super.subject,
    required super.competition,
    required this.subscores,
    required this.points,
  });

  final List<Score> subscores;

  @override
  final double points;

  CompetitionJumperScore? jumperScore(SimulationJumper jumper) {
    return subscores.singleWhereOrNull((score) => score.subject == jumper)
        as CompetitionJumperScore?;
  }

  @override
  List<Object?> get props => [subject, competition, subscores, points];
}
