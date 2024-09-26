import 'dart:async';

import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/competition/competition.dart';
import 'package:sj_manager/models/simulation_db/competition/competition_labels.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules_provider.dart';
import 'package:sj_manager/models/simulation_db/standings/standings.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class CompetitionParser implements SimulationDbPartParser<Competition> {
  const CompetitionParser({
    required this.idsRepo,
    required this.rulesParser,
    required this.standingsParser,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartParser<DefaultCompetitionRulesProvider> rulesParser;
  final SimulationDbPartParser<Standings> standingsParser;

  @override
  FutureOr<Competition> parse(Json json) async {
    final labelsJson = json['labels'] as List<String>?;
    List<Object>? labels;
    if (labelsJson != null) {
      labels = labelsJson.map((json) => _label(json)).toList();
    }
    final standings = await standingsParser.parse(json);

    return Competition(
      // TODO: Maybe preserve the type?
      hill: idsRepo.get<Hill>(json['hillId']),
      date: DateTime.parse(json['date']),
      rules: await rulesParser.parse(json['rules']),
      labels: labels ?? const [],
      standings: standings,
    );
  }

  Object _label(String jsonString) {
    return switch (jsonString) {
      'competition' => DefaultCompetitionType.competition,
      'qualifications' => DefaultCompetitionType.qualifications,
      'trialRound' => DefaultCompetitionType.trialRound,
      'training' => DefaultCompetitionType.training,
      _ => throw ArgumentError('Invalid competition label ID ($jsonString)'),
    };
  }
}
