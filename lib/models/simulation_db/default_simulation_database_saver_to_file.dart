import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/json/db_items_json.dart';
import 'package:sj_manager/models/simulation_db/simulation_database.dart';
import 'package:sj_manager/models/user_db/db_items_file_system_paths.dart';
import 'package:sj_manager/repositories/generic/db_items_json_configuration.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';
import 'package:path/path.dart' as path;
import 'package:sj_manager/utils/file_system.dart';

class DefaultSimulationDatabaseSaverToFile {
  DefaultSimulationDatabaseSaverToFile();

  late BuildContext _context;
  late SimulationDatabase _database;
  late String _simulationId;
  ItemsIdsRepo get _idsRepo => _database.idsRepo;

  Future<void> serialize({
    required SimulationDatabase database,
    required String simulationId,
    required BuildContext context,
  }) async {
    _database = database;
    _context = context;
    _simulationId = simulationId;
    print('ids repo: ${_idsRepo.items}');
    await _serializeItems(items: database.maleJumpers.toList());
    await _serializeItems(items: database.femaleJumpers.toList());
    await _serializeItems(items: database.hills.last.toList());
    await _serializeItems(items: database.countries.last.toList());
    await _serializeItems(items: database.teams.last.toList());
    await _serializeItems(items: database.seasons.last.toList());
  }

  Future<void> _serializeItems<T>({
    required List<T> items,
  }) async {
    final fileName = _context.read<DbItemsFilePathsRegistry>().get<T>();
    final toJson = _context.read<DbItemsJsonConfiguration<T>>().toJson;
    final file = simulationFile(
      context: _context,
      simulationId: _simulationId,
      fileName: fileName,
    );
    print('file: $file');
    await saveItemsMapToJsonFile(
      file: file,
      items: items,
      toJson: toJson,
      idsRepo: _idsRepo,
    );
  }
}

Directory simulationDirectory({
  required BuildContext context,
  required String simulationId,
}) {
  return userDataDirectory(context.read(), path.join('simulations', simulationId));
}

File simulationFile({
  required BuildContext context,
  required String simulationId,
  required String fileName,
}) {
  return fileInDirectory(
    simulationDirectory(
      context: context,
      simulationId: simulationId,
    ),
    fileName,
  );
}
