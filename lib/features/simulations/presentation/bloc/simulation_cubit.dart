import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/sjm_simulation.dart';
import 'package:sj_manager/features/simulations/domain/use_cases/database/get_simulation_database_use_case.dart';
import 'package:sj_manager/features/simulations/domain/use_cases/sjm_simulation/preserve_simulation_use_case.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';

class SimulationCubit extends Cubit<SimulationState> {
  SimulationCubit({
    required this.getDatabase,
    required this.preserveSimulation,
  }) : super(const SimulationNotChosen());

  final GetSimulationDatabaseUseCase getDatabase;
  final PreserveSimulationUseCase preserveSimulation;

  Future<void> choose(SjmSimulation simulation) async {
    if (state is SimulationChosen) {
      throw StateError('A simulation has been already chosen ($simulation)');
    }
    emit(
      SimulationChosen(
        simulation: simulation,
        database: await getDatabase(simulation.id),
      ),
    );
  }

  Future<void> preserve() async {
    final state = this.state;
    if (state is! SimulationChosen) {
      throw StateError('Cannot preserve a simulation when it hasn\'t been chosen');
    }
    await preserveSimulation(state.simulation);
    emit(const SimulationNotChosen());
  }
}

abstract class SimulationState extends Equatable {
  const SimulationState();
}

class SimulationNotChosen extends SimulationState {
  const SimulationNotChosen();

  @override
  List<Object?> get props => [];
}

class SimulationChosen extends SimulationState {
  const SimulationChosen({
    required this.simulation,
    required this.database,
  });

  final SjmSimulation simulation;
  final SimulationDatabase database;

  @override
  List<Object?> get props => [simulation, database];
}
