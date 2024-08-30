import 'package:sj_manager/models/simulation_db/standings/score/mixins/has_points_mixin.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/jump_score.dart';
import 'package:sj_manager/models/simulation_db/standings/score/score.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';

mixin CompetitionScore<E, SJS extends JumpScore> on HasPointsMixin<E>, Score<E> {
  List<SJS> get jumpScores;
}

class CompetitionJumperScore<E extends Jumper> extends Score<E>
    with HasPointsMixin<E>, CompetitionScore<E, JumpScore<E>> {
  const CompetitionJumperScore({
    required super.entity,
    required double points,
    required List<JumpScore<E>> jumpScores,
  })  : _points = points,
        _jumpScores = jumpScores;

  final double _points;
  final List<JumpScore<E>> _jumpScores;

  @override
  List<double> get components => [_points];

  @override
  List<JumpScore<E>> get jumpScores => _jumpScores;

  @override
  List<Object?> get props => [
        ...super.props,
        _points,
        jumpScores,
      ];
}

class CompetitionTeamScore<E extends Team> extends Score<E>
    with HasPointsMixin<E>, CompetitionScore<E, JumpScore<Jumper>> {
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
  List<JumpScore<Jumper>> get jumpScores {
    return jumperScores.expand((score) => score.jumpScores).toList();
  }

  @override
  List<Object?> get props => [
        ...super.props,
        _points,
        jumperScores,
      ];
}
