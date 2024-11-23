import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/core/general_utils/iterable.dart';
import 'package:sj_manager/features/simulations/data/data_sources/local/local_simulation_data_source.dart';
import 'package:sj_manager/features/simulations/data/mappers/sjm_simulation_mappers.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/sjm_simulation.dart';
import 'package:sj_manager/features/simulations/domain/repository/simulations_repository.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_mode.dart';

class LocalSimulationsRepository implements SimulationsRepository {
  LocalSimulationsRepository({
    required this.simulationsDataSource,
  });

  final LocalSimulationDataSource simulationsDataSource;

  final _streamController = PublishSubject<List<SjmSimulation>>();
  late List<SjmSimulation> _simulations;

  @override
  Future<SjmSimulation> get(String id) async {
    return _simulations.singleWhere((simulation) => simulation.id == id);
  }

  @override
  Future<List<SjmSimulation>> getAll() async {
    if (_simulations.isEmpty) {
      loadAll();
    }
    return _simulations;
  }

  @override
  Future<void> loadAll() async {
    final ids = await simulationsDataSource.getAvailableSimulations();
    final models = await ids.asyncMap((id) async => await simulationsDataSource.get(id));
    final simulations = await models.asyncMap(
      (model) async {
        return sjmSimulationFromModel(model);
      },
    );
    _simulations = simulations.toList();
  }

  @override
  Future<void> add(
    SjmSimulation simulation, {
    required DateTime saveTime,
    required SimulationMode mode,
  }) async {
    _simulations.add(simulation);
    await simulationsDataSource.add(
      simulation.toModel(
        saveTime: saveTime,
        mode: mode,
      ),
    );
    _notify();
  }

  @override
  Future<void> remove(String simulationId) async {
    _simulations.removeWhere((simulation) => simulation.id == simulationId);
    await simulationsDataSource.delete(simulationId);
    _notify();
  }

  void _notify() {
    _streamController.add(_simulations);
  }

  @override
  Future<void> preserve(
    SjmSimulation simulation, {
    required DateTime saveTime,
    required SimulationMode mode,
  }) async {
    throw UnimplementedError();
    // await simulationsDataSource
    //     .preserve(simulation.toModel(saveTime: saveTime, mode: mode));
  }

  @override
  Future<Stream<List<SjmSimulation>>> get stream async => _streamController.stream;
}
