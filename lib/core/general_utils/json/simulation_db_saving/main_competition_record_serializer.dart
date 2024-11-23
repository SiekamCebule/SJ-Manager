import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_rules/default_competition_rules_provider.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class MainCompetitionRecordSerializer
    implements SimulationDbPartSerializer<CalendarMainCompetitionRecord> {
  const MainCompetitionRecordSerializer({
    required this.idsRepository,
    required this.rulesProviderSerializer,
  });

  final IdsRepository idsRepository;
  final SimulationDbPartSerializer<DefaultCompetitionRulesProvider>
      rulesProviderSerializer;

  @override
  Json serialize(CalendarMainCompetitionRecord record) {
    return {
      'hillId': idsRepository.id(record.hill),
      //'date': record.date.toString(),
      'mainCompetitionRules':
          rulesProviderSerializer.serialize(record.setup.mainCompRules),
      'qualsRules': record.setup.qualificationsRules != null
          ? rulesProviderSerializer.serialize(record.setup.qualificationsRules!)
          : null,
      'trialRoundRules': record.setup.trialRoundRules != null
          ? rulesProviderSerializer.serialize(record.setup.trialRoundRules!)
          : null,
      'trainingsRules': record.setup.trainingsRules != null
          ? rulesProviderSerializer.serialize(record.setup.trainingsRules!)
          : null,
      'trainingsCount': record.setup.trainingsCount,
    };
  }
}
