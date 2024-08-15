import 'package:sj_manager/bloc/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/competition/competition.dart';
import 'package:sj_manager/models/simulation_db/competition/competition_type.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules_provider.dart';
import 'package:sj_manager/models/simulation_db/standings/standings.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';

class CompetitionSerializer implements SimulationDbPartSerializer<Competition> {
  const CompetitionSerializer({
    required this.idsRepo,
    required this.competitionRulesSerializer,
    required this.standingsSerializer,
  });

  final IdsRepo idsRepo;
  final SimulationDbPartSerializer<CompetitionRulesProvider> competitionRulesSerializer;
  final SimulationDbPartSerializer<Standings> standingsSerializer;

  @override
  Json serialize(Competition competition) {
    final labelsJson = competition.labels.map((label) => _labelJsonString(label));
    return {
      'hillId': idsRepo.idOf(competition.hill),
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
      CompetitionType.competition => 'competition',
      CompetitionType.qualifications => 'qualifications',
      CompetitionType.trialRound => 'trialRound',
      CompetitionType.training => 'training',
      _ => throw ArgumentError('Invalid competition label: $label'),
    };
  }
}
