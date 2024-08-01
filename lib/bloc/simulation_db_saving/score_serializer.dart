import 'package:sj_manager/bloc/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/classification_score.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/competition_scores.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/simple_points_score.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/single_jump_score.dart';
import 'package:sj_manager/models/simulation_db/standings/score/score.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';

class ScoreSerializer implements SimulationDbPartSerializer<Score> {
  const ScoreSerializer({
    required this.idsRepo,
  });

  final IdsRepo idsRepo;

  @override
  Json serialize(Score score) {
    return _serializeAppropriateScore(score);
  }

  Json _serializeAppropriateScore(Score score) {
    if (score is SingleJumpScore) {
      return _serializeSingleJumpScore(score);
    } else if (score is CompetitionJumperScore) {
      return _serializeCompetitionJumperScore(score);
    } else if (score is CompetitionTeamScore) {
      return _serializeCompetitionTeamScore(score);
    } else if (score is SimplePointsScore) {
      return _serializeSimplePointsScore(score);
    } else if (score is ClassificationScore) {
      return _serializeClassificationScore(score);
    } else {
      throw UnsupportedError('Unsupported score type: ${score.runtimeType}');
    }
  }

  Json _serializeSingleJumpScore(SingleJumpScore score) {
    return {
      'type': 'single_jump_score',
      'entityId': idsRepo.idOf(score.entity),
      'distancePoints': score.distancePoints,
      'judgesPoints': score.judgesPoints,
      'gatePoints': score.gatePoints,
      'windPoints': score.windPoints,
    };
  }

  Json _serializeCompetitionJumperScore(CompetitionJumperScore score) {
    final jumpScoreJson = score.jumpScores.map((score) {
      _serializeSingleJumpScore(score);
    });
    return {
      'type': 'jumper_competition_score',
      'entityId': idsRepo.idOf(score.entity),
      'jumpScores': jumpScoreJson,
      'points': score.points,
    };
  }

  Json _serializeCompetitionTeamScore(CompetitionTeamScore score) {
    final entityScoresJson = score.jumpScores.map((score) {
      _serializeAppropriateScore(score);
    });
    return {
      'type': 'team_competition_score',
      'entityId': idsRepo.idOf(score.entity),
      'entityScores': entityScoresJson,
      'points': score.points,
    };
  }

  Json _serializeSimplePointsScore(SimplePointsScore score) {
    return {
      'type': 'simple_points_score',
      'entityId': idsRepo.idOf(score.entity),
      'points': score.points,
    };
  }

  Json _serializeClassificationScore(ClassificationScore score) {
    final competitionScoresJson = score.competitionScores.map((score) {
      return _serializeAppropriateScore(score);
    });
    return {
      'type': 'classification_score',
      'entityId': idsRepo.idOf(score.entity),
      'competitionScores': competitionScoresJson,
      'points': score.points,
    };
  }
}
