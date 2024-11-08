import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/commands/ui/simulation/jumper_reports/set_up_jumper_level_reports_command.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/models/game_variants/game_variants_io_utils.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/database/simulation_wizard_options_repo.dart';
import 'package:sj_manager/models/simulation/database/utils/default_simulation_database_creator.dart';
import 'package:sj_manager/models/simulation/database/utils/default_simulation_database_saver_to_file.dart';
import 'package:sj_manager/models/simulation/user_simulation/user_simulation.dart';
import 'package:sj_manager/models/simulation/user_simulation/user_simulations_registry_saver_to_file.dart';
import 'package:sj_manager/repositories/generic/editable_items_repo.dart';
import 'package:sj_manager/utils/file_system.dart';
import 'package:path/path.dart' as path;

class CreateNewSimulationCommand {
  CreateNewSimulationCommand({
    required this.context,
    required this.simulationOptions,
  });

  final BuildContext context;
  final SimulationWizardOptionsRepo simulationOptions;

  late SimulationDatabase _database;
  String? _subteamCountryFlagPath;
  late UserSimulation _userSimulation;

  Future<void> execute() async {
    await _createSimulationDatabase();
    await _copyImagesFromVariant();
    await _setUpJumperLevelReports();
    await _addUserSimulationRecord();
    await _updateUserSimulationsRegistry();
    await _saveToFile();
    await _showSimulationScreen();
  }

  Future<void> _createSimulationDatabase() async {
    _database = DefaultSimulationDatabaseCreator(idGenerator: context.read())
        .create(simulationOptions);
  }

  Future<void> _addUserSimulationRecord() async {
    if (_database.managerData.userSubteam != null) {
      final countryCode = simulationOptions.team.last!.country.code;
      _subteamCountryFlagPath = fileInDirectory(
        simulationDirectory(
          pathsCache: context.read(),
          simulationId: simulationOptions.simulationId.last!,
          directoryName: 'countries/country_flags',
        ),
        '${countryCode.toLowerCase()}.png', // TODO: not only png
      ).path;
    }
    _userSimulation = UserSimulation(
      id: simulationOptions.simulationId.last!,
      name: simulationOptions.simulationName.last!,
      saveTime: DateTime.now(),
      database: _database,
      subteamCountryFlagPath: _subteamCountryFlagPath,
      mode: simulationOptions.mode.last!,
    );
    final simulationsRepo = context.read<EditableItemsRepo<UserSimulation>>();
    simulationsRepo.add(_userSimulation);
  }

  Future<void> _updateUserSimulationsRegistry() async {
    final simulationsRepo = context.read<EditableItemsRepo<UserSimulation>>();
    await UserSimulationsRegistrySaverToFile(
      userSimulations: simulationsRepo.last,
      pathsCache: context.read(),
    ).serialize();
  }

  Future<void> _saveToFile() async {
    DefaultSimulationDatabaseSaverToFile(
      simulationId: _userSimulation.id,
      pathsCache: context.read(),
      pathsRegistry: context.read(),
      idsRepo: _database.idsRepo,
    ).serialize(
      database: _database,
    );
  }

  Future<void> _copyImagesFromVariant() async {
    await copyDirectory(
      gameVariantDirectory(
        pathsCache: context.read(),
        gameVariantId: simulationOptions.gameVariant.last!.id,
        directoryName: path.join('countries', 'country_flags'),
      ),
      simulationDirectory(
        pathsCache: context.read(),
        simulationId: simulationOptions.simulationId.last!,
        directoryName: path.join('countries', 'country_flags'),
      ),
    );
    if (!context.mounted) return;
    await copyDirectory(
      gameVariantDirectory(
        pathsCache: context.read(),
        gameVariantId: simulationOptions.gameVariant.last!.id,
        directoryName: path.join('jumper_images'),
      ),
      simulationDirectory(
        pathsCache: context.read(),
        simulationId: simulationOptions.simulationId.last!,
        directoryName: path.join('jumper_images'),
      ),
    );
  }

  Future<void> _setUpJumperLevelReports() async {
    SetUpJumperLevelReportsCommand(
      context: context,
      database: _database,
      levelRequirements: simulationOptions.gameVariant.last!.jumperLevelRequirements,
      onFinish: (changedDatabase) {
        _database = changedDatabase;
      },
    ).execute();
  }

  Future<void> _showSimulationScreen() async {
    router.navigateTo(context, '/simulation/${_userSimulation.id}');
  }
}
