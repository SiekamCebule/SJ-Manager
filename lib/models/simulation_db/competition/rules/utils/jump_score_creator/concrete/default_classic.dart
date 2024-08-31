import 'dart:math';

import 'package:sj_manager/models/simulation_db/competition/rules/utils/jump_score_creator/jump_score_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/jump_score_creator/util_functions.dart';
import 'package:sj_manager/models/simulation_db/standings/score/details/jump_score_details.dart';
import 'package:sj_manager/models/simulation_db/standings/score/score.dart';
import 'package:sj_manager/utils/math.dart';

class DefaultClassicJumpScoreCreator<E> extends JumpScoreCreator<E> {
  late JumpScoreCreatingContext _context;

  @override
  Score<E, CompetitionJumpScoreDetails> compute(JumpScoreCreatingContext<E> context) {
    _context = context;

    final details = CompetitionJumpScoreDetails(
      jumpRecord: _context.jumpRecord,
      distancePoints: _calculateDistancePoints(),
      judgesPoints: _calculateJudgesPoints(),
      gatePoints: _calculateGatePoints(),
      windPoints: _calculateWindPoints(),
    );

    final componentsSum = [
      details.distancePoints ?? 0,
      details.judgesPoints ?? 0,
      details.gatePoints ?? 0,
      details.windPoints ?? 0,
    ].fold(0.0, (sum, value) => sum + value);
    final withOneDecimalPlace = componentsSum.toPrecision(1);
    final atLeastZero = max(0, withOneDecimalPlace).toDouble();

    return Score(
      entity: _context.entity,
      details: details,
      points: atLeastZero,
    );
  }

  double _calculateDistancePoints() {
    final pointsForK = defaultHillPointsForK(_context.hill);
    final behindK = (_context.jumpRecord.distance - _context.hill.k);
    final pointsForMeter = defaultHillPointsForMeter(_context.hill);
    return pointsForK + (behindK * pointsForMeter);
  }

  double _calculateGatePoints() {
    return (_context.initialGate - _context.gate) * _context.hill.pointsForGate;
  }

  double _calculateJudgesPoints() {
    final significantJudgesCount = _context.competition.rules.competitionRules
        .rounds[_context.currentRound].significantJudgesCount;
    final judgesScores = List<double>.from(_context.judges);
    judgesScores.sort();

    int scoresToRemove = (judgesScores.length - significantJudgesCount) ~/ 2;
    for (int i = 0; i < scoresToRemove; i++) {
      var minIndices = [];
      for (int j = 0; j < judgesScores.length; j++) {
        if (judgesScores[j] == judgesScores.first) {
          minIndices.add(j);
        }
      }
      judgesScores.removeAt(minIndices[Random().nextInt(minIndices.length)]);
    }

    for (int i = 0; i < scoresToRemove; i++) {
      var maxIndices = [];
      for (int j = 0; j < judgesScores.length; j++) {
        if (judgesScores[j] == judgesScores.last) {
          maxIndices.add(j);
        }
      }
      judgesScores.removeAt(maxIndices[Random().nextInt(maxIndices.length)]);
    }

    return judgesScores.reduce((sum, element) => sum + element);
  }

  double _calculateWindPoints() {
    final mappedWindStrength = _context.averagedWind;
    final windPoints = mappedWindStrength > 0
        ? -mappedWindStrength * _context.hill.pointsForHeadwind
        : mappedWindStrength * _context.hill.pointsForTailwind;
    return windPoints;
  }
}
