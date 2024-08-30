import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/models/simulation_db/standings/score/mixins/has_points_mixin.dart';
import 'package:sj_manager/models/simulation_db/standings/score/score.dart';

abstract class JumpScore<E> extends Score<E> with HasPointsMixin<E> {
  const JumpScore({
    required super.entity,
    required this.jumpRecord,
  });

  final JumpSimulationRecord jumpRecord;
}

class SimpleJumpScore<E> extends JumpScore<E> {
  const SimpleJumpScore(
      {required super.entity, required super.jumpRecord, required double points})
      : _points = points;

  final double _points;

  @override
  List<Object?> get props => [
        ...super.props,
        _points,
        jumpRecord,
      ];

  @override
  List<double> get components => [_points];
}

class DefaultJumpScore<E> extends JumpScore<E> {
  const DefaultJumpScore({
    required super.entity,
    required this.distancePoints,
    required this.judgesPoints,
    required this.gatePoints,
    required this.windPoints,
    required super.jumpRecord,
  });

  final double? distancePoints;
  final double? judgesPoints;
  final double? gatePoints;
  final double? windPoints;

  double get totalCompensation => (gatePoints ?? 0) + (windPoints ?? 0);

  @override
  List<Object?> get props => [
        ...super.props,
        distancePoints,
        judgesPoints,
        gatePoints,
        windPoints,
        jumpRecord,
      ];

  @override
  List<double> get components => [
        0,
        if (distancePoints != null) distancePoints!,
        if (judgesPoints != null) judgesPoints!,
        if (gatePoints != null) gatePoints!,
        if (windPoints != null) windPoints!,
      ];
}
