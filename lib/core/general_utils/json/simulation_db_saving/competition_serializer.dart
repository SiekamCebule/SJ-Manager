import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/competition/competition.dart';
import 'package:sj_manager/to_embrace/competition/competition_labels.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_rules/default_competition_rules_provider.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/standings.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class CompetitionSerializer implements SimulationDbPartSerializer<Competition> {
  const CompetitionSerializer({
    required this.idsRepository,
    required this.competitionRulesSerializer,
    required this.standingsSerializer,
  });

  final IdsRepository idsRepository;
  final SimulationDbPartSerializer<DefaultCompetitionRulesProvider>
      competitionRulesSerializer;
  final SimulationDbPartSerializer<Standings> standingsSerializer;

  @override
  Json serialize(Competition competition) {
    final labelsJson =
        competition.labels.map((label) => _labelJsonString(label)).toList();
    return {
      'hillId': idsRepository.id(competition.hill),
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
