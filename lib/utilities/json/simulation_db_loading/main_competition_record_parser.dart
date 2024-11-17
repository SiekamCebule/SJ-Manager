import 'dart:async';

import 'package:sj_manager/utilities/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/domain/entities/simulation/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/domain/entities/simulation/competition/calendar_records/calendar_main_competition_record_setup.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/competition_rules/default_competition_rules_provider.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';
import 'package:sj_manager/utilities/utils/id_generator.dart';

class MainCompetitionRecordParser
    implements SimulationDbPartParser<CalendarMainCompetitionRecord> {
  const MainCompetitionRecordParser({
    required this.idsRepo,
    required this.idGenerator,
    required this.rulesProviderParser,
  });

  final ItemsIdsRepo idsRepo;
  final IdGenerator idGenerator;
  final SimulationDbPartParser<DefaultCompetitionRulesProvider> rulesProviderParser;

  @override
  FutureOr<CalendarMainCompetitionRecord> parse(Json json) async {
    final mainCompetitionRules =
        await rulesProviderParser.parse(json['mainCompetitionRules']);
    final qualsRulesJson = json['qualsRules'] as Json?;
    final qualsRules =
        qualsRulesJson != null ? await rulesProviderParser.parse(qualsRulesJson) : null;
    final trialRoundRulesJson = json['trialRoundRules'] as Json?;
    final trialRoundRules = trialRoundRulesJson != null
        ? await rulesProviderParser.parse(trialRoundRulesJson)
        : null;
    final trainingsRulesJson = json['trainingsRules'] as Json?;
    final trainingsRules = trainingsRulesJson != null
        ? await rulesProviderParser.parse(trainingsRulesJson)
        : null;

    return CalendarMainCompetitionRecord(
      hill: idsRepo.get(json['hillId']),
      date: DateTime.parse(json['date']),
      setup: CalendarMainCompetitionRecordSetup(
        mainCompRules: mainCompetitionRules,
        qualificationsRules: qualsRules,
        trialRoundRules: trialRoundRules,
        trainingsRules: trainingsRules,
        trainingsCount: json['trainingsCount'] ?? 0,
      ),
    );
  }
}
