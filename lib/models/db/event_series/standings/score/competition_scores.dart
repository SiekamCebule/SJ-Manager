import 'package:sj_manager/models/db/event_series/standings/score/has_points_mixin.dart';
import 'package:sj_manager/models/db/event_series/standings/score/jump_score.dart';
import 'package:sj_manager/models/db/event_series/standings/score/score.dart';

mixin CompetitionScore on Score {
  List<JumpScore> get jumpScores;
}

class CompetitionJumperScore extends Score with CompetitionScore, HasPointsMixin {
  const CompetitionJumperScore({
    required double points,
    required List<JumpScore> jumperScores,
  })  : _points = points,
        _jumperScores = jumperScores;

  final double _points;
  final List<JumpScore> _jumperScores;

  @override
  List<double> get components => [_points];

  @override
  List<JumpScore> get jumpScores => _jumperScores;

  @override
  List<Object?> get props => [
        _points,
        jumpScores,
      ];
}

class CompetitionTeamScore<E> extends Score with CompetitionScore, HasPointsMixin {
  const CompetitionTeamScore({
    required double points,
    required this.jumperScores,
  }) : _points = points;

  final double _points;
  final Map<E, CompetitionJumperScore> jumperScores;

  @override
  List<double> get components => [_points];

  @override
  List<JumpScore> get jumpScores {
    return jumperScores.values.expand((score) => score.jumpScores).toList();
  }

  @override
  List<Object?> get props => [
        _points,
        jumperScores,
      ];
}
