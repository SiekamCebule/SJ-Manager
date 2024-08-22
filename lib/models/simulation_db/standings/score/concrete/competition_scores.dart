import 'package:sj_manager/models/simulation_db/standings/score/mixins/has_points_mixin.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/single_jump_score.dart';
import 'package:sj_manager/models/simulation_db/standings/score/score.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';

mixin CompetitionScore<E, SJS extends SingleJumpScore> on HasPointsMixin<E>, Score<E> {
  List<SJS> get jumpScores;
}

class CompetitionJumperScore<E extends Jumper> extends Score<E>
    with HasPointsMixin<E>, CompetitionScore<E, SingleJumpScore<E>> {
  const CompetitionJumperScore({
    required super.entity,
    required double points,
    required List<SingleJumpScore<E>> jumpScores,
  })  : _points = points,
        _jumpScores = jumpScores;

  final double _points;
  final List<SingleJumpScore<E>> _jumpScores;

  @override
  List<double> get components => [_points];

  @override
  List<SingleJumpScore<E>> get jumpScores => _jumpScores;

  @override
  List<Object?> get props => [
        ...super.props,
        _points,
        jumpScores,
      ];
}

class CompetitionTeamScore<E extends Team> extends Score<E>
    with HasPointsMixin<E>, CompetitionScore<E, SingleJumpScore<Jumper>> {
  const CompetitionTeamScore({
    required super.entity,
    required double points,
    required this.jumperScores,
  }) : _points = points;

  final double _points;
  final List<CompetitionJumperScore> jumperScores;

  CompetitionJumperScore jumperScore(Jumper jumper) {
    return jumperScores.singleWhere((score) => score.entity == jumper);
  }

  @override
  List<double> get components => [_points];

  @override
  List<SingleJumpScore<Jumper>> get jumpScores {
    return jumperScores.expand((score) => score.jumpScores).toList();
  }

  @override
  List<Object?> get props => [
        ...super.props,
        _points,
        jumperScores,
      ];
}
