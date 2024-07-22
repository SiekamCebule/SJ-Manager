import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/json/db_items_json.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/models/country.dart';
import 'package:sj_manager/models/db_items_file_system_entity.dart';
import 'package:sj_manager/models/hill/hill.dart';
import 'package:sj_manager/models/jumper/jumper.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/database_editing/db_items_json_configuration.dart';
import 'package:sj_manager/repositories/database_editing/db_items_repository.dart';
import 'package:sj_manager/ui/dialogs/loading_items_failed_dialog.dart';
import 'package:sj_manager/ui/navigation/routes.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/country_flag.dart';
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
        _context.read<DbItemsFileSystemEntity<Country>>().entity as File;
    if (!await countriesFile.exists()) {
      await countriesFile.create(recursive: true);
      countriesFile
          .writeAsString(await rootBundle.loadString('assets/defaults/countries.json'));
    }
    if (!_context.mounted) return;

    final flagsDir =
        _context.read<DbItemsFileSystemEntity<CountryFlag>>().entity as Directory;
    if (!await flagsDir.exists()) {
      await copyAssetsDir('defaults/country_flags', flagsDir);
    }
  }

  Future<void> loadDatabase() async {
    if (!_context.mounted) return;
    final file = _context.read<DbItemsFileSystemEntity<Country>>().entity as File;
    try {
      await _loadCountries();
    } catch (e) {
      if (!_context.mounted) return;
      await showDialog(
        context: _context,
        builder: (context) => LoadingItemsFailedDialog(
          titleText: 'Błąd wczytywania krajów',
          filePath: file.path,
          error: e,
        ),
      );
    }

    await _tryLoadItems<MaleJumper>(dialogTitleText: 'Błąd wczytywania skoczków');
    await _tryLoadItems<FemaleJumper>(dialogTitleText: 'Błąd wczytywania skoczkiń');
    await _tryLoadItems<Hill>(dialogTitleText: 'Błąd wczytywania skoczni');
  }

  Future<void> _tryLoadItems<T>({required String dialogTitleText}) async {
    if (!_context.mounted) return;
    final file = _context.read<DbItemsFileSystemEntity<T>>().entity as File;
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
      file: _context.read<DbItemsFileSystemEntity<Country>>().entity as File,
      fromJson: parameters.fromJson,
    );
    if (!_context.mounted) return;
    _context.read<CountriesRepo>().setCountries(
        countries.map((c) => c.copyWith(code: c.code.toLowerCase())).toList());
  }

  Future<void> _loadItems<T>() async {
    if (!_context.mounted) return;
    final parameters = _context.read<DbItemsJsonConfiguration<T>>();
    final loadedMales = await loadItemsListFromJsonFile(
      file: _context.read<DbItemsFileSystemEntity<T>>().entity as File,
      fromJson: parameters.fromJson,
    );
    if (!_context.mounted) return;
    _context.read<DbItemsRepo<T>>().setItems(loadedMales);
  }
}
