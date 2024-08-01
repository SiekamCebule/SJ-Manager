import 'package:sj_manager/bloc/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/db/event_series/standings/score/concrete/simple_points_score.dart';
import 'package:sj_manager/models/db/event_series/standings/score/concrete/competition_scores.dart';
import 'package:sj_manager/models/db/event_series/standings/score/score.dart';
import 'package:sj_manager/models/db/event_series/standings/score/concrete/single_jump_score.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';

class ScoreLoader implements SimulationDbPartLoader<Score> {
  const ScoreLoader({
    required this.idsRepo,
  });

  final IdsRepo idsRepo;

  @override
  Score load(Json json) {
    final type = json['type'] as String;
    return switch (type) {
      'single_jump' => _loadSingleJumpScore(json),
      'jumper_score' => _loadJumperScore(json),
      'team_score' => _loadTeamScore(json),
      'simple_points_score' => _loadSimplePointsScore(json),
      _ => throw ArgumentError('Invalid score type: $type'),
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

  CompetitionJumperScore _loadJumperScore(Json json) {
    final entity = idsRepo.get(json['entityId']);
    final jumpScoresJson = json['jumpScores'] as List<Json>;
    final jumpScores = jumpScoresJson.map((json) {
      return _loadSingleJumpScore(json);
    }).toList();
    return CompetitionJumperScore(
      entity: entity,
      points: json['points'],
      jumpScores: jumpScores,
    );
  }

  CompetitionTeamScore _loadTeamScore(Json json) {
    final entity = idsRepo.get(json['entityId']);
    final jumperScoresJson = json['jumperScores'] as List<Json>;
    final jumperScores = jumperScoresJson.map((json) {
      return _loadJumperScore(json);
    }).toList();
    return CompetitionTeamScore(
      entity: entity,
      points: json['points'],
      jumperScores: jumperScores,
    );
  }

  SimplePointsScore _loadSimplePointsScore(Json json) {
    final entity = idsRepo.get(json['entityId']);
    return SimplePointsScore(
      json['points'],
      entity: entity,
    );
  }
}
