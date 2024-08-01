import 'package:sj_manager/models/simulation_db/standings/score/mixins/has_points_mixin.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/single_jump_score.dart';
import 'package:sj_manager/models/simulation_db/standings/score/score.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';

mixin CompetitionScore<E> on HasPointsMixin<E>, Score<E> {
  List<SingleJumpScore> get jumpScores;
}

class CompetitionJumperScore<E extends Jumper> extends Score<E>
    with HasPointsMixin<E>, CompetitionScore<E> {
  const CompetitionJumperScore({
    required super.entity,
    required double points,
    required List<SingleJumpScore> jumpScores,
  })  : _points = points,
        _jumpScores = jumpScores;

  final double _points;
  final List<SingleJumpScore> _jumpScores;

  @override
  List<double> get components => [_points];

  @override
  List<SingleJumpScore> get jumpScores => _jumpScores;

  @override
  List<Object?> get props => [
        ...super.props,
        _points,
        jumpScores,
      ];
}

class CompetitionTeamScore<E> extends Score<E>
    with HasPointsMixin<E>, CompetitionScore<E> {
  const CompetitionTeamScore({
    required super.entity,
    required double points,
    required this.entityScores,
  }) : _points = points;

  final double _points;
  final List<CompetitionJumperScore> entityScores;

  @override
  List<double> get components => [_points];

  @override
  List<SingleJumpScore> get jumpScores {
    return entityScores.expand((score) => score.jumpScores).toList();
  }

  @override
  List<Object?> get props => [
        ...super.props,
        _points,
        entityScores,
      ];
}
