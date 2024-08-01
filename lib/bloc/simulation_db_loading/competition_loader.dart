import 'package:sj_manager/bloc/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/db/event_series/competition/competition.dart';
import 'package:sj_manager/models/db/event_series/competition/competition_type.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/competition_rules/competition_rules.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_repo.dart';
import 'package:sj_manager/models/db/hill/hill.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';

class CompetitionLoader implements SimulationDbPartLoader<Competition> {
  const CompetitionLoader({
    required this.idsRepo,
    required this.rulesLoader,
    required this.standingsLoader,
  });

  final IdsRepo idsRepo;
  final SimulationDbPartLoader<CompetitionRules> rulesLoader;
  final SimulationDbPartLoader<StandingsRepo> standingsLoader;

  @override
  Competition load(Json json) {
    final labelsJson = json['labels'] as List<String>?;
    Set<Object>? labels;
    if (labelsJson != null) {
      labels = labelsJson.map((json) => _label(json)).toSet();
    }
    final standings = standingsLoader.load(json);

    return Competition(
      // TODO: Maybe preserve the type?
      hill: idsRepo.get<Hill>(json['hillId']),
      date: DateTime.parse(json['date']),
      rules: rulesLoader.load(json['rules']),
      labels: labels ?? const {},
      standings: standings,
    );
  }

  Object _label(String jsonString) {
    return switch (jsonString) {
      'competition' => CompetitionType.competition,
      'qualifications' => CompetitionType.qualifications,
      'trialRound' => CompetitionType.trialRound,
      'training' => CompetitionType.training,
      _ => throw ArgumentError('Invalid competition label ID ($jsonString)'),
    };
  }
}
