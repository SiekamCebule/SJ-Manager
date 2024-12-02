import 'package:sj_manager/core/general_utils/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/classification_scores.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/competition_scores.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/score.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/test_scores.dart';

class ScoreParser implements SimulationDbPartParser<Score> {
  const ScoreParser({
    required this.idsRepository,
  });

  final IdsRepository idsRepository;

  @override
  Score parse(Json json) {
    return _loadAppropriate(json);
  }

  Score _loadAppropriate(Json json) {
    final type = json['type'] as String;
    return switch (type) {
      'competition_jump_score' => _loadCompetitionJumpScore(json),
      'competition_jumper_score' => _loadCompetitionJumperScore(json),
      'competition_team_score' => _loadCompetitionTeamScore(json),
      'simple_score' => _loadSimpleScore(json),
      'classification_jumper_score' => _loadClassificationJumperScore(json),
      'classification_team_score' => _loadClassificationTeamScore(json),
      _ => throw UnsupportedError('Unsupported score type: $type'),
    };
  }

  CompetitionJumpScore _loadCompetitionJumpScore(Json json) {
    return CompetitionJumpScore(
      subject: idsRepository.get(json['subjectId']),
      jump: idsRepository.get(json['jumpId']),
      distancePoints: json['distancePoints'],
      judgePoints: json['judgesPoints'],
      gatePoints: json['gatePoints'],
      windPoints: json['windPoints'],
      points: json['points'],
      competition: idsRepository.get(json['competitionId']),
    );
  }

  SimpleScore _loadSimpleScore(Json json) {
    return SimpleScore(
      subject: idsRepository.get(json['subjectId']),
      points: json['points'],
    );
  }

  CompetitionJumperScore _loadCompetitionJumperScore(Json json) {
    final jumpScoresJson = json['jumpScores'] as List<Json>;
    final jumpScores = jumpScoresJson.map((json) {
      return _loadAppropriate(json);
    }).toList();
    return CompetitionJumperScore(
      subject: idsRepository.get(json['subjectId']),
      points: json['points'],
      jumps: jumpScores.cast(),
      competition: idsRepository.get(json['competitionId']),
    );
  }

  CompetitionTeamScore _loadCompetitionTeamScore(Json json) {
    final jumperScoresJson = json['entityScores'] as List<Json>;
    final jumperScores = jumperScoresJson.map((json) {
      return _loadCompetitionJumperScore(json);
    }).toList();
    return CompetitionTeamScore(
      subject: idsRepository.get(json['subjectId']),
      points: json['points'],
      subscores: jumperScores,
      competition: idsRepository.get(json['competitionId']),
    );
  }

  ClassificationJumperScore _loadClassificationJumperScore(Json json) {
    final competitionScoresJson = json['competitionScores'] as List<Json>;
    final competitionScores = competitionScoresJson.map((json) {
      return _loadAppropriate(json);
    }).toList();
    return ClassificationJumperScore(
      subject: idsRepository.get(json['subjectId']),
      points: json['points'],
      competitionScores: competitionScores.cast(),
      classification: idsRepository.get('classificationId'),
    );
  }

  ClassificationTeamScore _loadClassificationTeamScore(Json json) {
    final competitionScoresJson = json['competitionScores'] as List<Json>;
    final competitionScores = competitionScoresJson.map((json) {
      return _loadAppropriate(json);
    }).toList();
    return ClassificationTeamScore(
      subject: idsRepository.get(json['subjectId']),
      points: json['points'],
      competitionScores: competitionScores.cast(),
      classification: idsRepository.get('classificationId'),
    );
  }
}
