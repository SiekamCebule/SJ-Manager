import 'package:sj_manager/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/standings/score/details/jump_score_details.dart';
import 'package:sj_manager/models/simulation_db/standings/score/details/score_details.dart';
import 'package:sj_manager/models/simulation_db/standings/score/score.dart';
import 'package:sj_manager/models/simulation_db/standings/score/typedefs.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class ScoreSerializer implements SimulationDbPartSerializer<Score> {
  const ScoreSerializer({
    required this.idsRepo,
  });

  final ItemsIdsRepo idsRepo;

  @override
  Json serialize(Score score) {
    return _serializeAppropriateScore(score);
  }

  Json _serializeAppropriateScore(Score score) {
    if (score is Score<dynamic, JumpScoreDetails>) {
      return _serializeSingleJumpScore(score);
    } else if (score is CompetitionJumperScore) {
      return _serializeCompetitionJumperScore(score);
    } else if (score is CompetitionTeamScore) {
      return _serializeCompetitionTeamScore(score);
    } else if (score is Score<dynamic, SimplePointsScoreDetails>) {
      return _serializeSimplePointsScore(score);
    } else if (score is ClassificationScore) {
      return _serializeClassificationScore(score);
    } else {
      throw UnsupportedError('Unsupported score type: ${score.runtimeType}');
    }
  }

  Json _serializeSingleJumpScore(Score<dynamic, JumpScoreDetails> score) {
    if (score is CompetitionJumpScore) {
      return {
        'type': 'competition_jump_score',
        'entityId': idsRepo.idOf(score.entity),
        'distancePoints': score.details.distancePoints,
        'judgesPoints': score.details.judgesPoints,
        'gatePoints': score.details.gatePoints,
        'windPoints': score.details.windPoints,
        'jumpRecordId': idsRepo.idOf(score.details.jumpRecord),
      };
    } else if (score is Score<dynamic, SimpleJumpScoreDetails>) {
      return {
        'type': 'simple_jump_score',
        'entityId': idsRepo.idOf(score.entity),
        'points': score.points,
        'jumpRecordId': idsRepo.idOf(score.details.jumpRecord),
      };
    } else {
      throw ArgumentError(
        'An invalid type of JumpScore when serializing (we do not have a proper serializer for ${score.runtimeType} class)',
      );
    }
  }

  Json _serializeCompetitionJumperScore(CompetitionJumperScore score) {
    final jumpScoreJson = score.details.jumpScores.map((score) {
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
    final entityScoresJson = score.details.jumpScores.map((score) {
      _serializeAppropriateScore(score);
    });
    return {
      'type': 'team_competition_score',
      'entityId': idsRepo.idOf(score.entity),
      'entityScores': entityScoresJson,
      'points': score.points,
    };
  }

  Json _serializeSimplePointsScore(Score<dynamic, SimplePointsScoreDetails> score) {
    return {
      'type': 'simple_points_score',
      'entityId': idsRepo.idOf(score.entity),
      'points': score.points,
    };
  }

  Json _serializeClassificationScore(ClassificationScore score) {
    final competitionScoresJson = score.details.competitionScores.map((score) {
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
