import 'package:path/path.dart' as path;
import 'package:quiver/iterables.dart';

import 'package:sj_manager/data/models/game_variant/game_variants_io_utils.dart';
import 'package:sj_manager/domain/entities/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/domain/entities/simulation/database/simulation_wizard_options_repo.dart';
import 'package:sj_manager/domain/entities/simulation/database/utils/default_simulation_database_creator.dart';
import 'package:sj_manager/domain/use_cases/ui/simulation/continue_simulation_use_case.dart';
import 'package:sj_manager/domain/use_cases/ui/simulation/jumper_reports/set_up_jumper_level_reports_use_case.dart';
import 'package:sj_manager/features/career_mode/domain/entities/simulation.dart';
import 'package:sj_manager/features/career_mode/domain/repository/simulation_databases_repository.dart';
import 'package:sj_manager/features/career_mode/domain/repository/simulations_repository.dart';
import 'package:sj_manager/utilities/utils/file_system.dart';
import 'package:sj_manager/utilities/utils/id_generator.dart';

class CreateNewSimulationUseCase {
  CreateNewSimulationUseCase({
    required this.idGenerator,
    required this.pathsCache,
    required this.simulationsRepository,
    required this.databasesRepository,
  });

  final IdGenerator idGenerator;
  final PlarformSpecificPathsCache pathsCache;
  final SimulationsRepository simulationsRepository;
  final SimulationDatabasesRepository databasesRepository;

  late SimulationDatabase _database;
  late SimulationWizardOptionsRepo _options;

  Future<void> call(SimulationWizardOptionsRepo options) async {
    _options = options;
    _database =
        DefaultSimulationDatabaseCreator(idGenerator: idGenerator).create(options);
    final simulation = Simulation(
      id: options.simulationId.last!,
      name: options.simulationName.last!,
      database: _database,
    );
    await _copyImagesFromVariant(
      gameVariantId: options.gameVariant.last!.id,
      simulationId: options.simulationId.last!,
    );
    _setUpJumperLevelReports();
    _maybeSimulateTime();
    await simulationsRepository.add(simulation);
    await databasesRepository.saveDatabase(_database);
  }

  Future<void> _copyImagesFromVariant({
    required String gameVariantId,
    required String simulationId,
  }) async {
    await copyDirectory(
      gameVariantDirectory(
        pathsCache: pathsCache,
        gameVariantId: gameVariantId,
        directoryName: path.join('countries', 'country_flags'),
      ),
      simulationDirectory(
        pathsCache: pathsCache,
        simulationId: simulationId,
        directoryName: path.join('countries', 'country_flags'),
      ),
    );
    await copyDirectory(
      gameVariantDirectory(
        pathsCache: pathsCache,
        gameVariantId: gameVariantId,
        directoryName: path.join('jumper_images'),
      ),
      simulationDirectory(
        pathsCache: pathsCache,
        simulationId: simulationId,
        directoryName: path.join('jumper_images'),
      ),
    );
  }

  void _setUpJumperLevelReports() {
    SetUpJumperLevelReportsUseCase(
      database: _database,
      levelRequirements: _options.gameVariant.last!.jumperLevelRequirements,
    ).execute();
  }

  void _maybeSimulateTime() {
    final earliestDate = _options.gameVariant.last!.startDates.first;
    final startDate = _options.startDate.last!;
    if (startDate.date.isAfter(earliestDate.date)) {
      final difference = startDate.date.difference(earliestDate.date);
      final daysToSimulate = difference.inDays;
      for (var day in range(0, daysToSimulate - 1, 1)) {
        ContinueSimulationUseCase(
          database: _database,
          chooseSubteamId: (_) => idGenerator.generate(),
          afterSettingUpSubteams: null,
          afterSettingUpTrainings: null,
        ).execute();
        print('day: ${day + 1} (${_database.currentDate})');
      }
    }
  }
}
