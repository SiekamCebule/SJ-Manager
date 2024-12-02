import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/classification_scores.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/competition_scores.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/score.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/test_scores.dart';

class ScoreSerializer implements SimulationDbPartSerializer<Score> {
  const ScoreSerializer({
    required this.idsRepository,
  });

  final IdsRepository idsRepository;

  @override
  Json serialize(Score score) {
    return _serializeAppropriateScore(score);
  }

  Json _serializeAppropriateScore(Score score) {
    if (score is CompetitionJumpScore) {
      return _serializeCompetitionJumpScore(score);
    } else if (score is CompetitionJumperScore) {
      return _serializeCompetitionJumperScore(score);
    } else if (score is CompetitionTeamScore) {
      return _serializeCompetitionTeamScore(score);
    } else if (score is SimpleScore) {
      return serializeSimpleScore(score);
    } else if (score is ClassificationJumperScore) {
      return _serializeClassificationJumperScore(score);
    } else if (score is ClassificationTeamScore) {
      return _serializeClassificationTeamScore(score);
    } else {
      throw UnsupportedError('Unsupported score type: ${score.runtimeType}');
    }
  }

  Json _serializeCompetitionJumpScore(CompetitionJumpScore score) {
    return {
      'type': 'competition_jump_score',
      'subjectId': idsRepository.id(score.subject),
      'distancePoints': score.distancePoints,
      'judgesPoints': score.judgePoints,
      'gatePoints': score.gatePoints,
      'windPoints': score.windPoints,
      'jumpId': idsRepository.id(score.jump),
    };
  }

  Json _serializeCompetitionJumperScore(CompetitionJumperScore score) {
    final jumpScoreJson = score.jumps.map((score) {
      _serializeCompetitionJumpScore(score);
    }).toList();
    return {
      'type': 'jumper_competition_score',
      'subjectId': idsRepository.id(score.subject),
      'jumpScores': jumpScoreJson,
      'points': score.points,
    };
  }

  Json _serializeCompetitionTeamScore(CompetitionTeamScore score) {
    final subscores = score.subscores.map((score) {
      _serializeAppropriateScore(score);
    }).toList();
    return {
      'type': 'team_competition_score',
      'subjectId': idsRepository.id(score.subject),
      'subscores': subscores,
      'points': score.points,
    };
  }

  Json serializeSimpleScore(SimpleScore score) {
    return {
      'type': 'simple_score',
      'subjectId': idsRepository.id(score.subject),
      'points': score.points,
    };
  }

  Json _serializeClassificationJumperScore(ClassificationJumperScore score) {
    final competitionScoresJson = score.competitionScores.map((score) {
      return _serializeAppropriateScore(score);
    }).toList();
    return {
      'type': 'classification_jumper_score',
      'subjectId': idsRepository.id(score.subject),
      'competitionScores': competitionScoresJson,
      'points': score.points,
    };
  }

  Json _serializeClassificationTeamScore(ClassificationTeamScore score) {
    final competitionScoresJson = score.competitionScores.map((score) {
      return _serializeAppropriateScore(score);
    }).toList();
    return {
      'type': 'classification_team_score',
      'subjectId': idsRepository.id(score.subject),
      'competitionScores': competitionScoresJson,
      'points': score.points,
    };
  }
}
