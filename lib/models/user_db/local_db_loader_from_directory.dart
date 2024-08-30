import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sj_manager/json/db_items_json.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules_preset.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/db_items_file_system_paths.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/items_repos_registry.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/countries/country_facts/teams_repo.dart';
import 'package:sj_manager/repositories/generic/db_items_json_configuration.dart';
import 'package:sj_manager/repositories/generic/editable_items_repo.dart';

class LocalDbLoaderFromDirectory {
  LocalDbLoaderFromDirectory({
    required this.directory,
  });

  final Directory directory;
  late final BuildContext _context;
  late final DbItemsFilePathsRegistry _filePaths;
  late final ItemsReposRegistry _registry;

  Future<ItemsReposRegistry> load({required BuildContext context}) async {
    _context = context;
    _filePaths = context.read<DbItemsFilePathsRegistry>();
    _registry = ItemsReposRegistry();
    await _registerEditableItemsRepos();
    await _registerCountries();
    await _registerTeams();
    return _registry;
  }

  Future<void> _registerEditableItemsRepos() async {
    _registry.register(await _loadEditableItemsRepo<MaleJumper>());
    _registry.register(await _loadEditableItemsRepo<FemaleJumper>());
    _registry.register(await _loadEditableItemsRepo<Hill>());
    _registry.register(await _loadEditableItemsRepo<EventSeriesSetup>());
    _registry.register(await _loadEditableItemsRepo<EventSeriesCalendarPreset>());
    _registry.register(await _loadEditableItemsRepo<DefaultCompetitionRulesPreset>());
  }

  Future<void> _registerCountries() async {
    final countries = CountriesRepo(
        initial: await loadItemsListFromJsonFile(
      file: _getFile(_filePaths.get<Country>()),
      fromJson: _context.read<DbItemsJsonConfiguration<Country>>().fromJson,
    ));
    _registry.register(countries);
  }

  Future<void> _registerTeams() async {
    final teams = await TeamsRepo.fromDirectory(
      directory,
      context: _context,
      fromJson: _context.read<DbItemsJsonConfiguration<Team>>().fromJson,
    );
    _registry.register(teams);
  }

  Future<EditableItemsRepo<T>> _loadEditableItemsRepo<T>() async {
    return EditableItemsRepo<T>(
      initial: await loadItemsListFromJsonFile(
        file: _getFile(_filePaths.get<T>()),
        fromJson: _context.read<DbItemsJsonConfiguration<T>>().fromJson,
      ),
    );
  }

  File _getFile(String fileName) => File('${directory.path}/$fileName');
}
