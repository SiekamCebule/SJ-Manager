// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:sj_manager/models/simulation_db/standings/score/mixins/has_points_mixin.dart';
import 'package:sj_manager/models/simulation_db/standings/score/score.dart';

class SimplePointsScore<E> extends Score<E> with HasPointsMixin<E> {
  const SimplePointsScore(double points, {required super.entity}) : _points = points;

  final double _points;

  @override
  List<Object?> get props => [
        ...super.props,
        points,
      ];

  @override
  List<double> get components => [_points];

  SimplePointsScore<E> copyWith({
    E? entity,
    double? points,
  }) {
    return SimplePointsScore<E>(
      points ?? this._points,
      entity: entity ?? this.entity,
    );
  }
}
