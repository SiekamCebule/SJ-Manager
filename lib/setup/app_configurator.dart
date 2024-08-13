import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/db_items_file_system_paths.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/setup/db_items_list_loader.dart';
import 'package:sj_manager/ui/navigation/routes.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/country_flag.dart';
import 'package:sj_manager/utils/file_system.dart';

class AppConfigurator {
  AppConfigurator({
    required this.shouldSetUpRouting,
    required this.shouldSetUpUserData,
    required this.shouldLoadDatabase,
    required this.loaders,
  });

  final bool shouldSetUpRouting;
  final bool shouldSetUpUserData;
  final bool shouldLoadDatabase;
  final List<DbItemsListLoader> loaders;

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
    final countriesFile = databaseFile(
        _context.read(), _context.read<DbItemsFilePathsRegistry>().get<Country>());
    if (!await countriesFile.exists()) {
      await countriesFile.create(recursive: true);
      countriesFile
          .writeAsString(await rootBundle.loadString('assets/defaults/countries.json'));
    }
    if (!_context.mounted) return;

    final flagsDir = databaseDirectory(_context.read(),
        _context.read<DbItemsDirectoryPathsRegistry>().get<CountryFlag>());
    if (!await flagsDir.exists()) {
      await copyAssetsDir('defaults/country_flags', flagsDir);
    }

    final forMaleJumpers = await _createFileIfNotExists<MaleJumper>();
    if (forMaleJumpers.$2 == false) await forMaleJumpers.$1.writeAsString('[]');

    final forFemaleJumpers = await _createFileIfNotExists<FemaleJumper>();
    if (forFemaleJumpers.$2 == false) await forFemaleJumpers.$1.writeAsString('[]');

    final forHills = await _createFileIfNotExists<Hill>();
    if (forHills.$2 == false) await forHills.$1.writeAsString('[]');

    final forTeams = await _createFileIfNotExists<Team>();
    if (forTeams.$2 == false) await forTeams.$1.writeAsString('[]');
  }

  Future<(File, bool)> _createFileIfNotExists<T>() async {
    final file =
        databaseFile(_context.read(), _context.read<DbItemsFilePathsRegistry>().get<T>());
    if (!await file.exists()) {
      return (await file.create(recursive: true), false);
    }
    return (file, true);
  }

  Future<void> loadDatabase() async {
    for (final loader in loaders) {
      await loader.load();
    }
  }
}
