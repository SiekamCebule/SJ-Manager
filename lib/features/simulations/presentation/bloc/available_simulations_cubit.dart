import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/sjm_simulation.dart';
import 'package:sj_manager/features/simulations/domain/use_cases/create_simulation_use_case.dart';
import 'package:sj_manager/features/simulations/domain/use_cases/database/get_all_simulation_databases_use_case.dart';
import 'package:sj_manager/features/simulations/domain/use_cases/delete_simulation_use_case.dart';
import 'package:sj_manager/features/simulations/domain/use_cases/sjm_simulation/get_all_simulations_use_case.dart';
import 'package:sj_manager/features/simulations/domain/use_cases/sjm_simulation/get_simulations_stream_use_case.dart';
import 'package:sj_manager/features/simulations/presentation/simulation_wizard/simulation_wizard_options_repo.dart';

class AvailableSimulationsCubit extends Cubit<AvailableSimulationsState> {
  AvailableSimulationsCubit({
    required this.getSimulationsStream,
    required this.getAllSimulations,
    required this.getAllSimulationDatabases,
    required this.createSimulation,
    required this.deleteSimulation,
  }) : super(const AvailableSimulationsInitial());

  late StreamSubscription _simulationsSubscriptions;

  final GetSimulationsStreamUseCase getSimulationsStream;
  final GetAllSimulationsUseCase getAllSimulations;
  final GetAllSimulationDatabasesUseCase getAllSimulationDatabases;
  final CreateSimulationUseCase createSimulation;
  final DeleteSimulationUseCase deleteSimulation;

  Future<void> initialize() async {
    final stream = await getSimulationsStream();
    _simulationsSubscriptions = stream.listen((simulations) {
      emit(AvailableSimulationsInitialized(simulations: simulations));
    });
  }

  Future<void> add(SimulationWizardOptions options) async {
    await createSimulation(options);
  }

  Future<void> delete(SjmSimulation simulation) async {
    await deleteSimulation(simulation);
  }

  @override
  Future<void> close() {
    _simulationsSubscriptions.cancel();
    return super.close();
  }
}

abstract class AvailableSimulationsState extends Equatable {
  const AvailableSimulationsState();

  @override
  List<Object?> get props => [];
}

class AvailableSimulationsInitial extends AvailableSimulationsState {
  const AvailableSimulationsInitial();
}

class AvailableSimulationsInitialized extends AvailableSimulationsState {
  const AvailableSimulationsInitialized({
    required this.simulations,
  });

  final List<SjmSimulation> simulations;

  @override
  List<Object?> get props => [
        simulations,
      ];
}
