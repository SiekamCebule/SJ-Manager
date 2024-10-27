import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/commands/simulation/common/simulation_database_cubit.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/models/simulation/database/helper/simulation_database_helper.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/database/utils/default_simulation_database_saver_to_file.dart';
import 'package:sj_manager/models/simulation/user_simulation/user_simulation.dart';
import 'package:sj_manager/models/simulation/user_simulation/user_simulations_registry_saver_to_file.dart';
import 'package:sj_manager/models/user_db/db_items_file_system_paths.dart';
import 'package:sj_manager/repositories/generic/editable_items_repo.dart';
import 'package:sj_manager/ui/screens/simulation/large/dialogs/simulation_exit_are_you_sure_dialog.dart';
import 'package:sj_manager/utils/file_system.dart';
import 'package:sj_manager/utils/show_dialog.dart';

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
    final simulations = context.read<EditableItemsRepo<UserSimulation>>();
    final simulation = context.read<UserSimulation>();

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
    context.read<SimulationDatabaseCubit>().state.dispose();
    context.read<SimulationDatabaseHelper>().dispose();
    router.pop(context);
  }
}
