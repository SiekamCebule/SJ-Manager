import 'package:sj_manager/utilities/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/domain/entities/simulation/competition/competition.dart';
import 'package:sj_manager/domain/entities/simulation/competition/competition_labels.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/competition_rules/default_competition_rules_provider.dart';
import 'package:sj_manager/domain/entities/simulation/standings/standings.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';

class CompetitionSerializer implements SimulationDbPartSerializer<Competition> {
  const CompetitionSerializer({
    required this.idsRepo,
    required this.competitionRulesSerializer,
    required this.standingsSerializer,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartSerializer<DefaultCompetitionRulesProvider>
      competitionRulesSerializer;
  final SimulationDbPartSerializer<Standings> standingsSerializer;

  @override
  Json serialize(Competition competition) {
    final labelsJson =
        competition.labels.map((label) => _labelJsonString(label)).toList();
    return {
      'hillId': idsRepo.id(competition.hill),
      'labels': labelsJson,
      'date': competition.date.toIso8601String(),
      'rules': competitionRulesSerializer.serialize(competition.rules),
      if (competition.standings != null)
        'standings': standingsSerializer.serialize(competition.standings!),
      if (competition.standings == null) 'standings': null,
    };
  }

  String _labelJsonString(Object label) {
    return switch (label) {
      DefaultCompetitionType.competition => 'competition',
      DefaultCompetitionType.qualifications => 'qualifications',
      DefaultCompetitionType.trialRound => 'trialRound',
      DefaultCompetitionType.training => 'training',
      _ => throw ArgumentError('Invalid competition label: $label'),
    };
  }
}
