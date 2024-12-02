import 'dart:math';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/competition_scores.dart';
import 'package:sj_manager/features/competitions/domain/utils/jump_score_creator/jump_score_creator.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_round_rules/default_competition_round_rules.dart';
import 'package:sj_manager/features/competitions/domain/utils/jump_score_creator/context/jump_score_creating_context.dart';
import 'package:sj_manager/core/general_utils/hill_points_utils.dart';
import 'package:sj_manager/core/general_utils/math.dart';

class DefaultClassicJumpScoreCreator
    implements JumpScoreCreator<JumpScoreCreatingContext> {
  late JumpScoreCreatingContext _context;

  @override
  CompetitionJumpScore create(JumpScoreCreatingContext context) {
    _context = context;

    final distancePoints = _calculateDistancePoints();
    final judgesPoints = _calculateJudgesPoints();
    final gatePoints = _calculateGatePoints();
    final windPoints = _calculateWindPoints();

    final points = [
      distancePoints ?? 0,
      judgesPoints ?? 0,
      gatePoints ?? 0,
      windPoints ?? 0,
    ].reduce((value, element) => value + element).toPrecision(1);

    return CompetitionJumpScore(
      subject: context.subject,
      jump: context.jump,
      competition: context.competition,
      points: points.clamp(0, double.infinity),
    );
  }

  double? _calculateDistancePoints() {
    final pointsForK = defaultHillPointsForK(_context.hill);
    final behindK = (_context.jump.distance - _context.hill.k);
    final pointsForMeter = defaultHillPointsForMeter(_context.hill);
    return pointsForK + (behindK * pointsForMeter);
  }

  double? _calculateGatePoints() {
    return _currentRoundRules.gateCompensationsEnabled
        ? (_context.initialGate - _context.gate) * _context.hill.pointsForGate
        : null;
  }

  double? _calculateJudgesPoints() {
    if (!_currentRoundRules.judgesEnabled) {
      return null;
    } else {
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
  }

  double? _calculateWindPoints() {
    if (!_currentRoundRules.windCompensationsEnabled) {
      return null;
    }
    final mappedWindStrength = _context.averagedWind;
    final windPoints = mappedWindStrength > 0
        ? -mappedWindStrength * _context.hill.pointsForHeadwind
        : mappedWindStrength * _context.hill.pointsForTailwind;
    return windPoints;
  }

  DefaultCompetitionRoundRules get _currentRoundRules {
    return _context.competition.rules.competitionRules.rounds[_context.currentRound];
  }
}
