import 'dart:io';

import 'package:sj_manager/core/general_utils/json/db_items_json.dart';
import 'package:sj_manager/features/simulations/data/models/sjm_simulation_model.dart';

abstract interface class LocalSimulationDataSource {
  Future<SjmSimulationModel> get(String simulationId);
  Future<Iterable<String>> getAvailableSimulations();

  /// If index is not specified, model will be added at the end.
  Future<void> add(SjmSimulationModel model, [int? index]);
  Future<void> delete(String simulationId);
}

class LocalSimulationDataSourceImpl implements LocalSimulationDataSource {
  LocalSimulationDataSourceImpl({
    required this.simulationsRegistryFile,
  });

  final File simulationsRegistryFile;

  @override
  Future<Iterable<String>> getAvailableSimulations() async {
    final simulations = await _loadAll();
    return simulations.map((simulation) => simulation.id);
  }

  @override
  Future<SjmSimulationModel> get(String simulationId) async {
    final simulations = await _loadAll();
    return simulations.firstWhere((simulation) => simulation.id == simulationId);
  }

  Future<List<SjmSimulationModel>> _loadAll() async {
    final simulations = await loadItemsListFromJsonFile(
      file: simulationsRegistryFile,
      fromJson: SjmSimulationModel.fromJson,
    );
    return simulations;
  }

  @override
  Future<void> add(SjmSimulationModel model, [int? index]) async {
    final updatedSimulations = List.of(await _loadAll());
    updatedSimulations.insert(index ?? updatedSimulations.length, model);
    await _preserve(updatedSimulations.toList());
  }

  @override
  Future<void> delete(String simulationId) async {
    final simulations = await _loadAll();
    final updatesSimulations =
        simulations.where((simulation) => simulation.id != simulationId);
    await _preserve(updatesSimulations.toList());
  }

  Future<void> _preserve(List<SjmSimulationModel> simulations) async {
    await saveItemsListToJsonFile(
      file: simulationsRegistryFile,
      items: simulations,
      toJson: (simulation) => simulation.toJson(),
    );
  }
}
