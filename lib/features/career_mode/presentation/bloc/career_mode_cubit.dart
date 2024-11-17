import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/domain/entities/simulation/database/simulation_wizard_options_repo.dart';
import 'package:sj_manager/features/career_mode/domain/entities/simulation.dart';
import 'package:sj_manager/features/career_mode/domain/usecases/choosing_simulation/choose_simulation_use_case.dart';

class CarerrModeCubit extends Cubit<CareerModeState> {
  CarerrModeCubit({
    required this.chooseSimulationUseCase,
  }) : super(CareerModeInitial());

  final ChooseSimulationUseCase chooseSimulationUseCase;

  Future<void> chooseSimulation(Simulation simulation) async {
    emit(CareerModeLoading());
    final changedSimulation = await chooseSimulationUseCase(simulation);
    emit(CareerModeChosenSimulation(simulation: changedSimulation));
  }

  Future<void> createNewSimulation(SimulationWizardOptionsRepo options) async {}
}

abstract class CareerModeState extends Equatable {
  const CareerModeState();

  @override
  List<Object?> get props => [];
}

class CareerModeInitial extends CareerModeState {}

class CareerModeLoading extends CareerModeState {}

class CareerModeLoadedSimulations extends CareerModeState {
  const CareerModeLoadedSimulations({
    required this.simulations,
  });

  final List<Simulation> simulations;

  @override
  List<Object?> get props => [simulations];
}

class CareerModeChosenSimulation extends CareerModeState {
  const CareerModeChosenSimulation({
    required this.simulation,
  });

  final Simulation simulation;

  @override
  List<Object?> get props => [simulation];
}
