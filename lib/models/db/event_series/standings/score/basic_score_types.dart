import 'package:sj_manager/models/db/event_series/standings/score/has_points_mixin.dart';
import 'package:sj_manager/models/db/event_series/standings/score/score.dart';

class SimplePointsScore extends Score with HasPointsMixin {
  const SimplePointsScore(double points) : _points = points;

  final double _points;

  @override
  List<Object?> get props => [points];

  @override
  List<double> get components => [_points];
}
