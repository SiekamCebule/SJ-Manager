import 'dart:math';

import 'package:sj_manager/models/simulation_db/competition/rules/utils/jump_score_creator/jump_score_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/jump_score_creator/util_functions.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/single_jump_score.dart';

class DefaultClassicJumpScoreCreator extends JumpScoreCreator {
  // TODO: JudgesCreator judgesCreator;
  late JumpScoreCreatingContext _context;

  @override
  SingleJumpScore compute(JumpScoreCreatingContext context) {
    _context = context;

    final gatePoints =
        (_context.gate - _context.initialGate) * _context.hill.pointsForGate;

    return SingleJumpScore(
      entity: _context.entity,
      distancePoints: _calculateDistancePoints(),
      judgesPoints: _calculateJudgesPoints(),
      gatePoints: gatePoints,
      windPoints: _calculateWindPoints(),
      jumpRecord: _context.jumpRecord,
    );
  }

  double _calculateDistancePoints() {
    final pointsForK = defaultHillPointsForK(_context.hill);
    final pointsForMeters =
        (_context.jumpRecord.distance * defaultHillPointsForMeter(_context.hill));
    return pointsForK + pointsForMeters;
  }

  double _calculateJudgesPoints() {
    // Retrieve the significant judges count and judges' scores from the context
    final significantJudgesCount = _context.competition.rules.competitionRules
        .rounds[_context.currentRound].significantJudgesCount;
    final judgesScores = List<double>.from(_context.judges);

    // Sort the judges' scores
    judgesScores.sort();

    // Calculate the number of scores to remove from each end
    int scoresToRemove = (judgesScores.length - significantJudgesCount) ~/ 2;

    // Handle removing the lowest scores
    for (int i = 0; i < scoresToRemove; i++) {
      // Find indices of the minimum score
      var minIndices = [];
      for (int j = 0; j < judgesScores.length; j++) {
        if (judgesScores[j] == judgesScores.first) {
          minIndices.add(j);
        }
      }
      // Randomly remove one of the lowest scores
      judgesScores.removeAt(minIndices[Random().nextInt(minIndices.length)]);
    }

    // Handle removing the highest scores
    for (int i = 0; i < scoresToRemove; i++) {
      // Find indices of the maximum score
      var maxIndices = [];
      for (int j = 0; j < judgesScores.length; j++) {
        if (judgesScores[j] == judgesScores.last) {
          maxIndices.add(j);
        }
      }
      // Randomly remove one of the highest scores
      judgesScores.removeAt(maxIndices[Random().nextInt(maxIndices.length)]);
    }

    // Calculate and return the sum of the remaining significant judges' scores
    return judgesScores.reduce((sum, element) => sum + element);
  }

  double _calculateWindPoints() {
    final mappedWindStrength = _context.averagedWind.mapStrengthByDirection();
    final windPoints = mappedWindStrength > 0
        ? mappedWindStrength * _context.hill.pointsForHeadwind
        : mappedWindStrength * _context.hill.pointsForTailwind;
    return windPoints;
  }
}
