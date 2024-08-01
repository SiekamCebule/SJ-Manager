import 'package:sj_manager/models/simulation_db/standings/score/mixins/has_points_mixin.dart';
import 'package:sj_manager/models/simulation_db/standings/score/score.dart';

class SingleJumpScore<E> extends Score<E> with HasPointsMixin<E> {
  const SingleJumpScore({
    required super.entity,
    required this.distancePoints,
    required this.judgesPoints,
    required this.gatePoints,
    required this.windPoints,
  });

  final double distancePoints;
  final double judgesPoints;
  final double gatePoints;
  final double windPoints;

  double get totalCompensation => gatePoints + windPoints;

  @override
  List<Object?> get props => [
        ...super.props,
        distancePoints,
        judgesPoints,
        gatePoints,
        windPoints,
      ];

  @override
  List<double> get components => [
        distancePoints,
        judgesPoints,
        gatePoints,
        windPoints,
      ];
}
