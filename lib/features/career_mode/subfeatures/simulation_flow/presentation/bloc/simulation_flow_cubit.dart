import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/features/career_mode/subfeatures/simulation_flow/domain/usecases/continue_simulation_use_case.dart';

class SimulationFlowCubit extends Cubit<SimulationFlowState> {
  SimulationFlowCubit({
    required this.continueSimulationUseCase,
  }) : super(SimulationFlowNotRunned());

  final ContinueSimulationUseCase continueSimulationUseCase;

  Future<void> simulateTime(Duration duration) async {
    emit(SimulationFlowInProgress());
    await continueSimulationUseCase();
    emit(SimulationFlowNotRunned());
  }
}

abstract class SimulationFlowState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SimulationFlowNotRunned extends SimulationFlowState {}

class SimulationFlowInProgress extends SimulationFlowState {}
