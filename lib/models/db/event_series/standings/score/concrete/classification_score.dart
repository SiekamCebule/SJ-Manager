import 'package:sj_manager/models/db/event_series/standings/score/concrete/competition_scores.dart';
import 'package:sj_manager/models/db/event_series/standings/score/mixins/has_points_mixin.dart';
import 'package:sj_manager/models/db/event_series/standings/score/score.dart';

class ClassificationScore<E> extends Score<E> with HasPointsMixin<E> {
  const ClassificationScore({
    required super.entity,
    required double points,
    required this.competitionScores,
  }) : _points = points;

  final double _points;
  final List<CompetitionScore> competitionScores;

  @override
  List<Object?> get props => [
        ...super.props,
        _points,
        competitionScores,
      ];

  @override
  List<double> get components => [_points];
}
