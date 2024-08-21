import 'package:sj_manager/models/simulation_db/standings/score/concrete/competition_scores.dart';
import 'package:sj_manager/models/simulation_db/standings/score/mixins/has_points_mixin.dart';
import 'package:sj_manager/models/simulation_db/standings/score/score.dart';

class ClassificationScore<E> extends Score<E> with HasPointsMixin<E> {
  const ClassificationScore({
    required super.entity,
    required double points,
    required this.competitionScores,
  }) : _points = points;

  final double _points;
  final List<CompetitionScore<E, dynamic>> competitionScores;

  ClassificationScore<R> cast<R>() {
    return ClassificationScore<R>(
      entity: entity as dynamic,
      points: points,
      competitionScores: competitionScores.cast(),
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        _points,
        competitionScores,
      ];

  @override
  List<double> get components => [_points];
}
