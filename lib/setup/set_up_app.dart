import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/json/db_items_json.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/models/country.dart';
import 'package:sj_manager/models/hill/hill.dart';
import 'package:sj_manager/models/jumper/jumper.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/database_editing/db_io_parameters_repo.dart';
import 'package:sj_manager/repositories/database_editing/db_items_repository.dart';
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
    final countriesFile = userDataFile(_context.read(), 'countries/countries.json');
    if (!await countriesFile.exists()) {
      await countriesFile.create(recursive: true);
      countriesFile
          .writeAsString(await rootBundle.loadString('assets/defaults/countries.json'));
    }
    if (!_context.mounted) return;

    final flagsDir = userDataDirectory(_context.read(), 'countries/country_flags');
    if (!await flagsDir.exists()) {
      await copyAssetsDir('defaults/country_flags', flagsDir);
    }
  }

  Future<void> loadDatabase() async {
    await _loadCountries();
    await _loadItems<MaleJumper>();
    await _loadItems<FemaleJumper>();
    await _loadItems<Hill>();
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
