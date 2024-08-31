import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/standings/score/details/classification_score_details.dart';
import 'package:sj_manager/models/simulation_db/standings/score/details/competition_score_details.dart';
import 'package:sj_manager/models/simulation_db/standings/score/details/jump_score_details.dart';
import 'package:sj_manager/models/simulation_db/standings/score/details/score_details.dart';
import 'package:sj_manager/models/simulation_db/standings/score/score.dart';
import 'package:sj_manager/models/simulation_db/standings/score/typedefs.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class ScoreParser implements SimulationDbPartParser<Score> {
  const ScoreParser({
    required this.idsRepo,
  });

  final ItemsIdsRepo idsRepo;

  @override
  Score parse(Json json) {
    return _loadAppropriate(json);
  }

  Score _loadAppropriate(Json json) {
    final type = json['type'] as String;
    return switch (type) {
      'competition_jump_score' => _loadCompetitionJumpScore(json),
      'jump_score' => _loadSimpleJumpScore(json),
      'jumper_competition_score' => _loadCompetitionJumperScore(json),
      'team_competition_score' => _loadCompetitionTeamScore(json),
      'simple_points_score' => _loadSimplePointsScore(json),
      'classification_score' => _loadClassificationScore(json),
      _ => throw UnsupportedError('Unsupported score type: $type'),
    };
  }

  CompetitionJumpScore _loadCompetitionJumpScore(Json json) {
    final entity = idsRepo.get(json['entityId']);
    final jumpRecord = idsRepo.get(json['jumpRecordId']);
    return CompetitionJumpScore(
      entity: entity,
      details: CompetitionJumpScoreDetails(
        jumpRecord: jumpRecord,
        distancePoints: json['distancePoints'],
        judgesPoints: json['judgesPoints'],
        gatePoints: json['gatePoints'],
        windPoints: json['windPoints'],
      ),
      points: json['points'],
    );
  }

  Score<dynamic, SimpleJumpScoreDetails> _loadSimpleJumpScore(Json json) {
    final entity = idsRepo.get(json['entityId']);
    final jumpRecord = idsRepo.get(json['jumpRecordId']);
    return Score<dynamic, SimpleJumpScoreDetails>(
      entity: entity,
      details: SimpleJumpScoreDetails(jumpRecord: jumpRecord),
      points: json['points'],
    );
  }

  CompetitionJumperScore _loadCompetitionJumperScore(Json json) {
    final entity = idsRepo.get(json['entityId']);
    final jumpScoresJson = json['jumpScores'] as List<Json>;
    final jumpScores = jumpScoresJson.map((json) {
      return _loadAppropriate(json);
    }).toList();
    return CompetitionJumperScore(
      entity: entity,
      points: json['points'],
      details: CompetitionJumperScoreDetails(
        jumpScores: jumpScores.cast(),
      ),
    );
  }

  CompetitionTeamScore _loadCompetitionTeamScore(Json json) {
    final entity = idsRepo.get(json['entityId']);
    final jumperScoresJson = json['entityScores'] as List<Json>;
    final jumperScores = jumperScoresJson.map((json) {
      return _loadCompetitionJumperScore(json);
    }).toList();
    return CompetitionTeamScore(
      entity: entity,
      points: json['points'],
      details: CompetitionTeamScoreDetails(
        jumperScores: jumperScores,
      ),
    );
  }

  Score<dynamic, SimplePointsScoreDetails> _loadSimplePointsScore(Json json) {
    final entity = idsRepo.get(json['entityId']);
    return Score<dynamic, SimplePointsScoreDetails>(
      entity: entity,
      points: json['points'],
      details: const SimplePointsScoreDetails(),
    );
  }

  ClassificationScore _loadClassificationScore(Json json) {
    final competitionScoresJson = json['competitionScores'] as List<Json>;
    final competitionScores = competitionScoresJson.map((json) {
      return _loadAppropriate(json);
    }).toList();
    return ClassificationScore(
      entity: idsRepo.get(json['entityId']),
      points: json['points'],
      details: ClassificationScoreDetails(
        competitionScores: competitionScores.cast<CompetitionScore>(),
      ),
    );
  }
}
