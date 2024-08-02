// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:sj_manager/enums/db_editable_item_type.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules_preset.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';

class LocalDbFilteredItemsState extends Equatable {
  const LocalDbFilteredItemsState({
    required this.maleJumpers,
    required this.femaleJumpers,
    required this.hills,
    required this.eventSeriesSetups,
    required this.eventSeriesCalendars,
    required this.competitionRulesPresets,
  });

  final List<MaleJumper> maleJumpers;
  final List<FemaleJumper> femaleJumpers;
  final List<Hill> hills;
  final List<EventSeriesSetup> eventSeriesSetups;
  final List<EventSeriesCalendarPreset> eventSeriesCalendars;
  final List<CompetitionRulesPreset> competitionRulesPresets;

  List<dynamic> byType(DbEditableItemType type) {
    return switch (type) {
      DbEditableItemType.maleJumper => maleJumpers,
      DbEditableItemType.femaleJumper => femaleJumpers,
      DbEditableItemType.hill => hills,
      DbEditableItemType.eventSeriesSetup => eventSeriesSetups,
      DbEditableItemType.eventSeriesCalendarPreset => eventSeriesCalendars,
      DbEditableItemType.competitionRulesPreset => competitionRulesPresets,
    };
  }

  @override
  List<Object?> get props => [
        maleJumpers,
        femaleJumpers,
        hills,
        eventSeriesSetups,
        eventSeriesCalendars,
        competitionRulesPresets
      ];

  LocalDbFilteredItemsState copyWith({
    List<MaleJumper>? maleJumpers,
    List<FemaleJumper>? femaleJumpers,
    List<Hill>? hills,
    List<EventSeriesSetup>? eventSeriesSetups,
    List<EventSeriesCalendarPreset>? eventSeriesCalendars,
    List<CompetitionRulesPreset>? competitionRulesPresets,
  }) {
    return LocalDbFilteredItemsState(
      maleJumpers: maleJumpers ?? this.maleJumpers,
      femaleJumpers: femaleJumpers ?? this.femaleJumpers,
      hills: hills ?? this.hills,
      eventSeriesSetups: eventSeriesSetups ?? this.eventSeriesSetups,
      eventSeriesCalendars: eventSeriesCalendars ?? this.eventSeriesCalendars,
      competitionRulesPresets: competitionRulesPresets ?? this.competitionRulesPresets,
    );
  }
}
