import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/data/models/exceptions/loading_database_failed_exception.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/setup/db_items_list_loader.dart';
import 'package:sj_manager/presentation/ui/navigation/routes.dart';
import 'package:sj_manager/utilities/utils/file_system.dart';
import 'package:path/path.dart' as path;

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
    final userDataDir = userDataDirectory(_context.read(), '');
    await userDataDir.create(recursive: true);

    if (!_context.mounted) return;
    final simulationsFile =
        userDataFile(_context.read(), path.join('simulations', 'simulations.json'));
    if (!await simulationsFile.exists()) {
      await simulationsFile.create(recursive: true);
      simulationsFile.writeAsString('[]');
    }
  }

  Future<void> loadDatabase() async {
    for (final loader in loaders) {
      try {
        await loader.load();
      } on LoadingDatabaseFailedException {
        break;
      }
    }
  }
}
