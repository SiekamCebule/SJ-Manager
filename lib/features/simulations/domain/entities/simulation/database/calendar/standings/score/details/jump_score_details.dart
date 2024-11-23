import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/score/details/score_details.dart';

abstract class JumpScoreDetails extends ScoreDetails {
  const JumpScoreDetails({
    required this.jumpRecord,
  });

  final JumpSimulationRecord jumpRecord;

  @override
  List<Object?> get props => [super.props, jumpRecord];
}

class SimpleJumpScoreDetails extends JumpScoreDetails {
  const SimpleJumpScoreDetails({
    required super.jumpRecord,
  });
}

class CompetitionJumpScoreDetails extends JumpScoreDetails {
  const CompetitionJumpScoreDetails({
    required super.jumpRecord,
    required this.distancePoints,
    required this.judgesPoints,
    required this.gatePoints,
    required this.windPoints,
  });

  final double? distancePoints;
  final double? judgesPoints;
  final double? gatePoints;
  final double? windPoints;

  double get totalCompensation => (gatePoints ?? 0) + (windPoints ?? 0);

  @override
  List<Object?> get props => [
        super.props,
        distancePoints,
        judgesPoints,
        gatePoints,
        windPoints,
      ];
}
