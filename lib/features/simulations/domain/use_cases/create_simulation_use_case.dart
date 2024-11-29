import 'package:path/path.dart' as path;
import 'package:quiver/iterables.dart';

import 'package:sj_manager/core/general_utils/game_variants_io_utils.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_mode.dart';
import 'package:sj_manager/features/simulations/presentation/simulation_wizard/simulation_wizard_options_repo.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/utils/default_simulation_database_creator.dart';
import 'package:sj_manager/features/career_mode/subfeatures/simulation_flow/domain/usecases/continue_simulation_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/jumper_reports/domain/usecases/level/set_up_jumper_level_reports_use_case.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/sjm_simulation.dart';
import 'package:sj_manager/features/simulations/domain/repository/simulation_databases_repository.dart';
import 'package:sj_manager/features/simulations/domain/repository/simulations_repository.dart';
import 'package:sj_manager/core/general_utils/file_system.dart';
import 'package:sj_manager/core/general_utils/id_generator.dart';

class CreateSimulationUseCase {
  CreateSimulationUseCase({
    required this.idGenerator,
    required this.pathsCache,
    required this.simulationsRepository,
    required this.databasesRepository,
    required this.continueSimulation,
  });

  final IdGenerator idGenerator;
  final PlarformSpecificPathsCache pathsCache;
  final SimulationsRepository simulationsRepository;
  final SimulationDatabasesRepository databasesRepository;
  final ContinueSimulationUseCase continueSimulation;

  late SimulationDatabase _database;
  late SimulationWizardOptions _options;

  Future<void> call(SimulationWizardOptions options) async {
    _options = options;
    _database =
        await DefaultSimulationDatabaseCreator(idGenerator: idGenerator).create(options);
    final simulation = SjmSimulation(
      id: options.simulationId!,
      name: options.simulationName!,
      saveTime: DateTime.now(),
      mode: options.mode!,
      currentDate: options.startDate!.date,
      chargesCount: options.mode! == SimulationMode.personalCoach ? 0 : null,
      subteamCountryName: options.team?.country.multilingualName,
      subteamType: options.subteamType,
    );
    await _copyImagesFromVariant(
      gameVariantId: options.gameVariant!.id,
      simulationId: options.simulationId!,
    );
    _setUpJumperLevelReports();
    await _maybeSimulateTime();
    await simulationsRepository.add(
      simulation,
      saveTime: DateTime.now(),
      mode: options.mode!,
    );
    await databasesRepository.preserve(_database, simulationId: options.simulationId!);
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
      levelRequirements: _options.gameVariant!.jumperLevelRequirements,
    ).execute();
  }

  Future<void> _maybeSimulateTime() async {
    final earliestDate = _options.gameVariant!.startDates.first;
    final startDate = _options.startDate!;
    if (startDate.date.isAfter(earliestDate.date)) {
      final difference = startDate.date.difference(earliestDate.date);
      final daysToSimulate = difference.inDays;
      for (var day in range(0, daysToSimulate - 1, 1)) {
        await continueSimulation();
        print('day: ${day + 1} (${_database.currentDate})');
      }
    }
  }
}
