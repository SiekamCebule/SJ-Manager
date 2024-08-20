import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/classification_score.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/simple_points_score.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/competition_scores.dart';
import 'package:sj_manager/models/simulation_db/standings/score/score.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/single_jump_score.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class ScoreLoader implements SimulationDbPartLoader<Score> {
  const ScoreLoader({
    required this.idsRepo,
  });

  final ItemsIdsRepo idsRepo;

  @override
  Score load(Json json) {
    return _loadAppropriate(json);
  }

  Score _loadAppropriate(Json json) {
    final type = json['type'] as String;
    return switch (type) {
      'single_jump_score' => _loadSingleJumpScore(json),
      'jumper_competition_score' => _loadCompetitionJumperScore(json),
      'team_competition_score' => _loadCompetitionTeamScore(json),
      'simple_points_score' => _loadSimplePointsScore(json),
      'classification_score' => _loadClassificationScore(json),
      _ => throw UnsupportedError('Unsupported score type: $type'),
    };
  }

  SingleJumpScore _loadSingleJumpScore(Json json) {
    final entity = idsRepo.get(json['entityId']);
    return SingleJumpScore(
      entity: entity,
      distancePoints: json['distancePoints'],
      judgesPoints: json['judgesPoints'],
      gatePoints: json['gatePoints'],
      windPoints: json['windPoints'],
    );
  }

  CompetitionJumperScore _loadCompetitionJumperScore(Json json) {
    final entity = idsRepo.get(json['entityId']);
    final jumpScoresJson = json['jumpScores'] as List<Json>;
    final jumpScores = jumpScoresJson.map((json) {
      return _loadSingleJumpScore(json);
    }).toList();
    return CompetitionJumperScore(
      entity: entity,
      points: json['points'],
      jumpScores: jumpScores.cast(),
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
      entityScores: jumperScores,
    );
  }

  SimplePointsScore _loadSimplePointsScore(Json json) {
    final entity = idsRepo.get(json['entityId']);
    return SimplePointsScore(
      json['points'],
      entity: entity,
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
      competitionScores: competitionScores.cast<CompetitionScore>(),
    );
  }
}
