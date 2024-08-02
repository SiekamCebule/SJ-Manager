// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sj_manager/enums/db_editable_item_type.dart';
import 'package:sj_manager/json/db_items_json.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules_preset.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/db_file_system_entity_names.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/countries/country_facts/teams_repo.dart';
import 'package:sj_manager/repositories/generic/db_items_json_configuration.dart';
import 'package:sj_manager/repositories/generic/editable_items_repo.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';

class LocalDbRepo with EquatableMixin {
  const LocalDbRepo({
    required this.maleJumpers,
    required this.femaleJumpers,
    required this.hills,
    required this.eventSeriesSetups,
    required this.eventSeriesCalendars,
    required this.competitionRulesPresets,
    required this.countries,
    required this.teams,
  });

  final EditableItemsRepo<MaleJumper> maleJumpers;
  final EditableItemsRepo<FemaleJumper> femaleJumpers;
  final EditableItemsRepo<Hill> hills;
  final EditableItemsRepo<EventSeriesSetup> eventSeriesSetups;
  final EditableItemsRepo<EventSeriesCalendarPreset> eventSeriesCalendars;
  final EditableItemsRepo<CompetitionRulesPreset> competitionRulesPresets;
  final CountriesRepo countries;
  final TeamsRepo<Team> teams;

  EditableItemsRepo<dynamic> editableByType(DbEditableItemType type) {
    return switch (type) {
      DbEditableItemType.maleJumper => maleJumpers,
      DbEditableItemType.femaleJumper => femaleJumpers,
      DbEditableItemType.hill => hills,
      DbEditableItemType.eventSeriesSetup => eventSeriesSetups,
      DbEditableItemType.eventSeriesCalendarPreset => eventSeriesCalendars,
      DbEditableItemType.competitionRulesPreset => competitionRulesPresets,
    };
  }

  EditableItemsRepo<T> editableByGenericType<T>() {
    if (T == MaleJumper) return maleJumpers as EditableItemsRepo<T>;
    if (T == FemaleJumper) return femaleJumpers as EditableItemsRepo<T>;
    if (T == Hill) return hills as EditableItemsRepo<T>;
    if (T == EventSeriesSetup) return eventSeriesSetups as EditableItemsRepo<T>;
    if (T == EventSeriesCalendarPreset) {
      return eventSeriesCalendars as EditableItemsRepo<T>;
    }
    if (T == CompetitionRulesPreset) {
      return competitionRulesPresets as EditableItemsRepo<T>;
    }
    return throw ArgumentError('Invalid type of LocalDbRepo\'s item: $T');
  }

  ItemsRepo<T> byType<T>() {
    if (T == MaleJumper) return maleJumpers as ItemsRepo<T>;
    if (T == FemaleJumper) return femaleJumpers as ItemsRepo<T>;
    if (T == Hill) return hills as ItemsRepo<T>;
    if (T == Country) return countries as ItemsRepo<T>;
    if (T == Team) return teams as ItemsRepo<T>;
    if (T == EventSeriesSetup) return eventSeriesSetups as ItemsRepo<T>;
    if (T == EventSeriesCalendarPreset) return eventSeriesCalendars as ItemsRepo<T>;
    if (T == CompetitionRulesPreset) return competitionRulesPresets as ItemsRepo<T>;
    throw ArgumentError('Invalid type of LocalDbRepo\'s item: $T');
  }

  static Future<LocalDbRepo> fromDirectory(Directory dir,
      {required BuildContext context}) async {
    final dbFsEntityNames = context.read<DbFileSystemEntityNames>();
    File getFile(String fileName) => File('${dir.path}/$fileName');

    final maleJumpers = EditableItemsRepo(
        initial: await loadItemsListFromJsonFile(
      file: getFile(dbFsEntityNames.maleJumpers),
      fromJson: context.read<DbItemsJsonConfiguration<MaleJumper>>().fromJson,
    ));
    if (!context.mounted) throw StateError('The context is unmounted');
    final femaleJumpers = EditableItemsRepo(
        initial: await loadItemsListFromJsonFile(
      file: getFile(dbFsEntityNames.femaleJumpers),
      fromJson: context.read<DbItemsJsonConfiguration<FemaleJumper>>().fromJson,
    ));
    if (!context.mounted) throw StateError('The context is unmounted');
    final hills = EditableItemsRepo(
        initial: await loadItemsListFromJsonFile(
      file: getFile(dbFsEntityNames.hills),
      fromJson: context.read<DbItemsJsonConfiguration<Hill>>().fromJson,
    ));
    if (!context.mounted) throw StateError('The context is unmounted');
    final eventSeriesSetups = EditableItemsRepo(
        initial: await loadItemsListFromJsonFile(
      file: getFile(dbFsEntityNames.eventSeriesSetups),
      fromJson: context.read<DbItemsJsonConfiguration<EventSeriesSetup>>().fromJson,
    ));
    if (!context.mounted) throw StateError('The context is unmounted');
    final eventSeriesCalendars = EditableItemsRepo(
      initial: await loadItemsListFromJsonFile(
        file: getFile(dbFsEntityNames.eventSeriesCalendars),
        fromJson:
            context.read<DbItemsJsonConfiguration<EventSeriesCalendarPreset>>().fromJson,
      ),
    );
    if (!context.mounted) throw StateError('The context is unmounted');
    final competitionRulesPresets = EditableItemsRepo(
      initial: await loadItemsListFromJsonFile(
        file: getFile(dbFsEntityNames.competitionRulesPresets),
        fromJson:
            context.read<DbItemsJsonConfiguration<CompetitionRulesPreset>>().fromJson,
      ),
    );
    if (!context.mounted) throw StateError('The context is unmounted');
    final countries = CountriesRepo(
        initial: await loadItemsListFromJsonFile(
      file: getFile(dbFsEntityNames.countries),
      fromJson: context.read<DbItemsJsonConfiguration<Country>>().fromJson,
    ));
    if (!context.mounted) throw StateError('The context is unmounted');
    final teams = await TeamsRepo.fromDirectory(
      dir,
      context: context,
      fromJson: context.read<DbItemsJsonConfiguration<Team>>().fromJson,
    );
    return LocalDbRepo(
      maleJumpers: maleJumpers,
      femaleJumpers: femaleJumpers,
      hills: hills,
      eventSeriesSetups: eventSeriesSetups,
      eventSeriesCalendars: eventSeriesCalendars,
      competitionRulesPresets: competitionRulesPresets,
      countries: countries,
      teams: TeamsRepo<Team>(initial: teams.last.cast()),
    );
  }

  @override
  List<Object?> get props => [
        maleJumpers,
        femaleJumpers,
        hills,
        countries,
      ];

  LocalDbRepo copyWith({
    EditableItemsRepo<MaleJumper>? maleJumpers,
    EditableItemsRepo<FemaleJumper>? femaleJumpers,
    EditableItemsRepo<Hill>? hills,
    EditableItemsRepo<EventSeriesSetup>? eventSeriesSetups,
    EditableItemsRepo<EventSeriesCalendarPreset>? eventSeriesCalendars,
    EditableItemsRepo<CompetitionRulesPreset>? competitionRulesPresets,
    CountriesRepo? countries,
    TeamsRepo<Team>? teams,
  }) {
    return LocalDbRepo(
      maleJumpers: maleJumpers ?? this.maleJumpers,
      femaleJumpers: femaleJumpers ?? this.femaleJumpers,
      hills: hills ?? this.hills,
      eventSeriesSetups: eventSeriesSetups ?? this.eventSeriesSetups,
      eventSeriesCalendars: eventSeriesCalendars ?? this.eventSeriesCalendars,
      competitionRulesPresets: competitionRulesPresets ?? this.competitionRulesPresets,
      countries: countries ?? this.countries,
      teams: teams ?? this.teams,
    );
  }

  void dispose() {
    print('LocalDbRepo dispose()');
    maleJumpers.dispose();
    femaleJumpers.dispose();
    hills.dispose();
    countries.dispose();
    teams.dispose();
  }
}
