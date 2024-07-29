import 'package:sj_manager/models/db/event_series/standings/score/has_points_mixin.dart';
import 'package:sj_manager/models/db/event_series/standings/score/score.dart';

class JumpScore extends Score with HasPointsMixin {
  const JumpScore({
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
