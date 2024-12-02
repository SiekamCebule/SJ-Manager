import 'dart:async';

import 'package:sj_manager/core/general_utils/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/competition/competition.dart';
import 'package:sj_manager/to_embrace/competition/competition_labels.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_rules/default_competition_rules_provider.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/standings.dart';
import 'package:sj_manager/core/core_classes/hill/hill.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class CompetitionParser implements SimulationDbPartParser<Competition> {
  const CompetitionParser({
    required this.idsRepository,
    required this.rulesParser,
    required this.standingsParser,
  });

  final IdsRepository idsRepository;
  final SimulationDbPartParser<DefaultCompetitionRulesProvider> rulesParser;
  final SimulationDbPartParser<Standings> standingsParser;

  @override
  FutureOr<Competition> parse(Json json) async {
    final labelsJson = (json['labels'] as List?)?.cast<String>();
    List<Object>? labels;
    if (labelsJson != null) {
      labels = labelsJson.map((json) => _label(json)).toList();
    }
    final standingsJson = json['standings'] as Json?;
    final standings =
        standingsJson != null ? await standingsParser.parse(standingsJson) : null;

    return Competition(
      // TODO: Maybe preserve the type?
      hill: idsRepository.get<Hill>(json['hillId']),
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
