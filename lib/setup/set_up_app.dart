import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/json/db_items_json.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/models/country.dart';
import 'package:sj_manager/models/hill/hill.dart';
import 'package:sj_manager/models/jumper/jumper.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/country_flags.dart/local_storage_country_flags_repo.dart';
import 'package:sj_manager/repositories/database_editing/db_io_parameters_repo.dart';
import 'package:sj_manager/repositories/database_editing/db_items_repository.dart';
import 'package:sj_manager/ui/dialogs/loading_items_failed_dialog.dart';
import 'package:sj_manager/ui/navigation/routes.dart';
import 'package:sj_manager/utils/context_maybe_read.dart';
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
    final countriesFile = userDataFile(_context.read(), 'countries/countries.json');
    if (!await countriesFile.exists()) {
      await countriesFile.create(recursive: true);
      countriesFile
          .writeAsString(await rootBundle.loadString('assets/defaults/countries.json'));
    }
    if (!_context.mounted) return;

    final flagsDir = _context.maybeRead<LocalStorageCountryFlagsRepo>()?.imagesDirectory;
    if (flagsDir != null) {
      if (!await flagsDir.exists()) {
        await copyAssetsDir('defaults/country_flags', flagsDir);
      }
    }
  }

  Future<void> loadDatabase() async {
    try {
      await _loadCountries();
    } catch (e) {
      if (!_context.mounted) return;
      await showDialog(
        context: _context,
        builder: (context) => LoadingItemsFailedDialog(
          titleText: 'Błąd wczytywania krajów',
          filePath: context.read<DbIoParametersRepo<Country>>().storageFile.path,
          error: e,
        ),
      );
    }

    try {
      await _loadItems<MaleJumper>();
    } catch (e) {
      if (!_context.mounted) return;
      await showDialog(
        context: _context,
        builder: (context) => LoadingItemsFailedDialog(
          titleText: 'Błąd wczytywania skoczków',
          filePath: context.read<DbIoParametersRepo<MaleJumper>>().storageFile.path,
          error: e,
        ),
      );
    }

    try {
      await _loadItems<FemaleJumper>();
    } catch (e) {
      if (!_context.mounted) return;
      await showDialog(
        context: _context,
        builder: (context) => LoadingItemsFailedDialog(
          titleText: 'Błąd wczytywania skoczkiń',
          filePath: context.read<DbIoParametersRepo<FemaleJumper>>().storageFile.path,
          error: e,
        ),
      );
    }

    try {
      await _loadItems<Hill>();
    } catch (e) {
      if (!_context.mounted) return;
      await showDialog(
        context: _context,
        builder: (context) => LoadingItemsFailedDialog(
          titleText: 'Błąd wczytywania skoczni',
          filePath: context.read<DbIoParametersRepo<Hill>>().storageFile.path,
          error: e,
        ),
      );
    }
  }

  Future<void> _loadCountries() async {
    final parameters = _context.read<DbIoParametersRepo<Country>>();
    final countries = await loadItemsListFromJsonFile<Country>(
      file: parameters.storageFile,
      fromJson: parameters.fromJson,
    );
    if (!_context.mounted) return;
    _context.read<CountriesRepo>().setCountries(countries);
  }

  Future<void> _loadItems<T>() async {
    if (!_context.mounted) return;
    final parameters = _context.read<DbIoParametersRepo<T>>();
    final loadedMales = await loadItemsListFromJsonFile(
        file: parameters.storageFile, fromJson: parameters.fromJson);
    if (!_context.mounted) return;
    _context.read<DbItemsRepo<T>>().setItems(loadedMales);
  }
}
