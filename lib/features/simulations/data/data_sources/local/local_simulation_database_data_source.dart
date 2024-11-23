import 'dart:io';

import 'package:sj_manager/core/general_utils/db_items_file_system_paths.dart';
import 'package:sj_manager/core/general_utils/file_system.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';
import 'package:sj_manager/features/simulations/data/models/simulation_database_model.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/utils/default_simulation_database_saver_to_file.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/utils/default_simulation_db_loader_from_file.dart';

abstract interface class LocalSimulationDatabaseDataSource {
  Future<SimulationDatabaseModel> get(String simulationId);
  Future<void> preserve(
    SimulationDatabaseModel model, {
    required IdsRepository idsRepository,
    required String simulationId,
  });
}

class LocalSimulationDatabaseDataSourceImpl implements LocalSimulationDatabaseDataSource {
  LocalSimulationDatabaseDataSourceImpl({
    required this.simulationsDirectory,
    required this.pathsRegistry,
    required this.pathsCache,
  });

  final Directory simulationsDirectory;
  final DbItemsFilePathsRegistry pathsRegistry;
  final PlarformSpecificPathsCache pathsCache;

  final _cache = <String, SimulationDatabaseModel>{};

  @override
  Future<SimulationDatabaseModel> get(String simulationId) async {
    if (!_cache.containsKey(simulationId)) {
      _cache[simulationId] = await _load(simulationId);
    }
    return _cache[simulationId]!;
  }

  Future<SimulationDatabaseModel> _load(String simulationId) async {
    final loader = DefaultSimulationDbLoaderFromFile(
      simulationId: simulationId,
      idsRepository: IdsRepository(),
      pathsRegistry: pathsRegistry,
      pathsCache: pathsCache,
    );
    return await loader.load(simulationId: simulationId);
  }

  @override
  Future<void> preserve(
    SimulationDatabaseModel model, {
    required IdsRepository idsRepository,
    required String simulationId,
  }) async {
    final saver = DefaultSimulationDatabaseSaverToFile(
      pathsRegistry: pathsRegistry,
      pathsCache: pathsCache,
      idsRepository: idsRepository,
      simulationId: simulationId,
    );
    await saver.serialize(database: model);
  }
}
