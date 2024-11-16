import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sj_manager/utilities/json/db_items_json.dart';
import 'package:sj_manager/data/models/simulation/database/utils/default_simulation_db_loader_from_file.dart';
import 'package:sj_manager/data/models/simulation/user_simulation/user_simulation_model.dart';
import 'package:sj_manager/data/models/database/db_items_file_system_paths.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/editable_items_repo.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';
import 'package:sj_manager/setup/db_items_list_loader.dart';
import 'package:sj_manager/presentation/ui/dialogs/loading_items/loading_items_failed_dialog.dart';
import 'package:sj_manager/utilities/utils/file_system.dart';
import 'package:sj_manager/utilities/utils/id_generator.dart';
import 'package:sj_manager/utilities/utils/show_dialog.dart';
import 'package:path/path.dart' as path;

class SimulationsLoader implements DbItemsListLoader {
  const SimulationsLoader({
    required this.context,
    required this.idGenerator,
    required this.pathsRegistry,
    required this.pathsCache,
    required this.simulationsRepo,
  });

  final BuildContext context;
  final IdGenerator idGenerator;
  final DbItemsFilePathsRegistry pathsRegistry;
  final PlarformSpecificPathsCache pathsCache;
  final EditableItemsRepo<UserSimulationModel> simulationsRepo;

  @override
  Future<void> load() async {
    try {
      final loader = DefaultSimulationDbLoaderFromFile(
        idsRepo: ItemsIdsRepo(),
        idGenerator: idGenerator,
        pathsRegistry: pathsRegistry,
        pathsCache: pathsCache,
      );

      final userSimulations = await loadItemsListFromJsonFile(
        file: userDataFile(pathsCache, path.join('simulations', 'simulations.json')),
        fromJson: UserSimulationModel.fromJson,
      );

      final simulationFolders =
          userDataDirectory(pathsCache, 'simulations').listSync().whereType<Directory>();

      final simulationsToLoad =
          userSimulations.where((simulation) => !simulation.loaded).toList();

      final loadedSimulations = await Future.wait(
        simulationsToLoad.map((userSimulation) async {
          final loadedDatabase = await loader.load(
            simulationId: userSimulation.id,
          );
          return userSimulation.copyWith(database: loadedDatabase);
        }),
      );

      final updatedSimulations = [
        ...userSimulations.map((userSimulation) {
          final updated = loadedSimulations.firstWhere(
            (loadedSimulation) => loadedSimulation.id == userSimulation.id,
            orElse: () => userSimulation,
          );
          return updated;
        }),
      ];

      final loadedSimulationIds =
          loadedSimulations.map((simulation) => simulation.id).toSet();
      for (var simulationFolder in simulationFolders) {
        final folderName = path.basename(simulationFolder.path);
        if (loadedSimulationIds.contains(folderName) == false) {
          await simulationFolder.delete(recursive: true);
        }
      }

      simulationsRepo.set(updatedSimulations);
    } catch (error, stackTrace) {
      if (!context.mounted) return;
      showSjmDialog(
        barrierDismissible: false,
        context: context,
        child: LoadingItemsFailedDialog(
          titleText: 'Błąd podczas ładowania symulacji',
          filePath: null,
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
