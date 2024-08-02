import 'package:sj_manager/enums/db_editable_item_type.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';

class DefaultItemsRepo {
  DefaultItemsRepo({
    required this.defaultFemaleJumper,
    required this.defaultMaleJumper,
    required this.defaultHill,
    required this.defaultEventSeriesSetup,
    required this.defaultEventSeriesCalendar,
    required this.defaultCompetitionRules,
  });

  final MaleJumper defaultMaleJumper;
  final FemaleJumper defaultFemaleJumper;
  final Hill defaultHill;
  final EventSeriesSetup defaultEventSeriesSetup;
  final EventSeriesCalendarPreset defaultEventSeriesCalendar;
  final CompetitionRules defaultCompetitionRules;

  dynamic byDatabaseItemType(DbEditableItemType type) {
    return switch (type) {
      DbEditableItemType.maleJumper => defaultMaleJumper,
      DbEditableItemType.femaleJumper => defaultFemaleJumper,
      DbEditableItemType.hill => defaultHill,
      DbEditableItemType.eventSeriesSetup => defaultEventSeriesSetup,
      DbEditableItemType.eventSeriesCalendarPreset => defaultEventSeriesCalendar,
      DbEditableItemType.competitionRulesPreset => defaultCompetitionRules,
    };
  }
}
