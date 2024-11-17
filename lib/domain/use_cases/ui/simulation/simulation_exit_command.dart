import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/domain/entities/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/domain/entities/simulation/database/utils/default_simulation_database_saver_to_file.dart';
import 'package:sj_manager/data/models/user_simulation/simulation_model.dart';
import 'package:sj_manager/data/models/user_simulation/user_simulations_registry_saver_to_file.dart';
import 'package:sj_manager/data/repositories/db_items_file_system_paths.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/editable_items_repo.dart';
import 'package:sj_manager/presentation/ui/screens/simulation/large/dialogs/simulation_exit_are_you_sure_dialog.dart';
import 'package:sj_manager/utilities/utils/file_system.dart';
import 'package:sj_manager/utilities/utils/show_dialog.dart';

class SimulationExitCommand {
  SimulationExitCommand({
    required this.context,
    required this.database,
  });

  final BuildContext context;
  final SimulationDatabase database;

  Future<void> execute() async {
    final bool? saveChanges = await showSjmDialog(
      barrierDismissible: true,
      context: context,
      child: const SimulationExitAreYouSureDialog(),
    );
    if (saveChanges == false) {
      _exitWithoutSaving();
    } else if (saveChanges == true) {
      if (!context.mounted) return;
      _exitSimulationWithSaving();
    }
  }

  void _exitSimulationWithSaving() async {
    final pathsCache = context.read<PlarformSpecificPathsCache>();
    final pathsRegistry = context.read<DbItemsFilePathsRegistry>();
    final simulations = context.read<EditableItemsRepo<SimulationModel>>();
    final simulation = context.read<SimulationModel>();

    await DefaultSimulationDatabaseSaverToFile(
      pathsRegistry: pathsRegistry,
      pathsCache: pathsCache,
      idsRepo: database.idsRepo,
      simulationId: simulation.id,
    ).serialize(database: database);

    await UserSimulationsRegistrySaverToFile(
      userSimulations: simulations.last.toList(),
      pathsCache: pathsCache,
    ).serialize();

    if (!context.mounted) return;
    _cleanUpAndPop();
  }

  void _exitWithoutSaving() {
    _cleanUpAndPop();
  }

  void _cleanUpAndPop() {
    router.pop(context);
  }
}
