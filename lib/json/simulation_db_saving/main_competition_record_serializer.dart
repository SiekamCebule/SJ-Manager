import 'package:sj_manager/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/models/simulation/competition/rules/competition_rules/default_competition_rules_provider.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class MainCompetitionRecordSerializer
    implements SimulationDbPartSerializer<CalendarMainCompetitionRecord> {
  const MainCompetitionRecordSerializer({
    required this.idsRepo,
    required this.rulesProviderSerializer,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartSerializer<DefaultCompetitionRulesProvider>
      rulesProviderSerializer;

  @override
  Json serialize(CalendarMainCompetitionRecord record) {
    return {
      'hillId': idsRepo.id(record.hill),
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
