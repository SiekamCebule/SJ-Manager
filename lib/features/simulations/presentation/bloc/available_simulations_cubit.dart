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
    required this.getSimulationsStreamUseCase,
    required this.getAllSimulationsUseCase,
    required this.getAllSimulationDatabasesUseCase,
    required this.createSimulationUseCase,
    required this.deleteSimulationUseCase,
  }) : super(const AvailableSimulationsInitial());

  late StreamSubscription _simulationsSubscriptions;

  final GetSimulationsStreamUseCase getSimulationsStreamUseCase;
  final GetAllSimulationsUseCase getAllSimulationsUseCase;
  final GetAllSimulationDatabasesUseCase getAllSimulationDatabasesUseCase;
  final CreateSimulationUseCase createSimulationUseCase;
  final DeleteSimulationUseCase deleteSimulationUseCase;

  Future<void> initialize() async {
    final stream = await getSimulationsStreamUseCase();
    _simulationsSubscriptions = stream.listen((simulations) {
      emit(AvailableSimulationsInitialized(simulations: simulations));
    });
  }

  Future<void> add(SimulationWizardOptions options) async {
    await createSimulationUseCase(options);
  }

  Future<void> delete(SjmSimulation simulation) async {
    await deleteSimulationUseCase(simulation);
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
