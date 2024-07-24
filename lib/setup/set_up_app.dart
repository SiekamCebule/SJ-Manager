import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/json/db_items_json.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/models/db/country/country.dart';
import 'package:sj_manager/models/db/country/country_facts.dart';
import 'package:sj_manager/models/db/db_file_system_entity_names.dart';
import 'package:sj_manager/models/db/hill/hill.dart';
import 'package:sj_manager/models/db/jumper/jumper.dart';
import 'package:sj_manager/models/db/local_db_repo.dart';
import 'package:sj_manager/repositories/generic/db_items_json_configuration.dart';
import 'package:sj_manager/ui/dialogs/loading_items_failed_dialog.dart';
import 'package:sj_manager/ui/navigation/routes.dart';
import 'package:sj_manager/utils/file_system.dart';

class AppConfigurator {
  AppConfigurator({
    required this.shouldSetUpRouting,
    required this.shouldSetUpUserData,
    required this.shouldLoadDatabase,
  });

  final bool shouldSetUpRouting;
  final bool shouldSetUpUserData;
  final bool shouldLoadDatabase;

  late BuildContext _context;

  Future<void> setUp(BuildContext context) async {
    _context = context;
    if (shouldSetUpRouting) {
      setUpRouting();
    }
    if (shouldSetUpUserData) {
      await setUpUserData();
    }
    if (shouldLoadDatabase) {
      await loadDatabase();
    }
  }

  void setUpRouting() {
    if (!routerIsInitialized) {
      configureRoutes(router);
      routerIsInitialized = true;
    }
  }

  Future<void> setUpUserData() async {
    final countriesFile =
        databaseFile(_context.read(), _context.read<DbFileSystemEntityNames>().countries);
    if (!await countriesFile.exists()) {
      await countriesFile.create(recursive: true);
      countriesFile
          .writeAsString(await rootBundle.loadString('assets/defaults/countries.json'));
    }
    if (!_context.mounted) return;

    final flagsDir = databaseDirectory(
        _context.read(), _context.read<DbFileSystemEntityNames>().countryFlags);
    if (!await flagsDir.exists()) {
      await copyAssetsDir('defaults/country_flags', flagsDir);
    }
  }

  Future<void> loadDatabase() async {
    if (!_context.mounted) return;
    final countriesFile =
        databaseFile(_context.read(), _context.read<DbFileSystemEntityNames>().countries);
    try {
      await _loadCountries();
    } catch (e) {
      if (!_context.mounted) return;
      await showDialog(
        context: _context,
        builder: (context) => LoadingItemsFailedDialog(
          titleText: 'Błąd wczytywania krajów',
          filePath: countriesFile.path,
          error: e,
        ),
      );
    }

    await _tryLoadItems<MaleJumper>(dialogTitleText: 'Błąd wczytywania skoczków');
    await _tryLoadItems<FemaleJumper>(dialogTitleText: 'Błąd wczytywania skoczkiń');
    await _tryLoadItems<Hill>(dialogTitleText: 'Błąd wczytywania skoczni');
    await _tryLoadItems<MaleCountryFacts>(
        dialogTitleText: 'Błąd wczytywania faktów męskich drużyn');
    await _tryLoadItems<FemaleCountryFacts>(
        dialogTitleText: 'Błąd wczytywania faktów żeńskich drużyn');
  }

  Future<void> _tryLoadItems<T>({required String dialogTitleText}) async {
    if (!_context.mounted) return;
    final file = databaseFile(
        _context.read(), _context.read<DbFileSystemEntityNames>().byGenericType<T>());
    try {
      await _loadItems<T>();
    } on PathNotFoundException {
      file.createSync();
      file.writeAsStringSync('[]');
    } catch (e) {
      if (!_context.mounted) return;
      await showDialog(
        barrierDismissible: false,
        context: _context,
        builder: (context) => LoadingItemsFailedDialog(
          titleText: dialogTitleText,
          filePath: file.path,
          error: e,
        ),
      );
    }
  }

  Future<void> _loadCountries() async {
    final parameters = _context.read<DbItemsJsonConfiguration<Country>>();
    final countries = await loadItemsListFromJsonFile<Country>(
      file: databaseFile(
          _context.read(), _context.read<DbFileSystemEntityNames>().countries),
      fromJson: parameters.fromJson,
    );
    if (!_context.mounted) return;
    _context.read<LocalDbRepo>().countries.setCountries(
        countries.map((c) => c.copyWith(code: c.code.toLowerCase())).toList());
  }

  Future<void> _loadItems<T>() async {
    final parameters = _context.read<DbItemsJsonConfiguration<T>>();
    final loaded = await loadItemsListFromJsonFile(
      file: databaseFile(
          _context.read(), _context.read<DbFileSystemEntityNames>().byGenericType<T>()),
      fromJson: parameters.fromJson,
    );
    if (!_context.mounted) return;
    _context.read<LocalDbRepo>().byType<T>().set(loaded);
  }

  /*Future<void> _loadCountryFacts<T extends CountryFacts>() async {
    final parameters = _context.read<DbItemsJsonConfiguration<T>>();
    final loaded = await loadItemsListFromJsonFile(
      file: databaseFile(
          _context.read(), _context.read<DbFileSystemEntityNames>().byGenericType<T>()),
      fromJson: parameters.fromJson,
    );
    if (!_context.mounted) return;
    _context.read<LocalDbRepo>().byType<T>().set(loaded);
  }*/
}
