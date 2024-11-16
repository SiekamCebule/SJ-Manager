import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osje_sim/osje_sim.dart';

class CompetitionSimulationCubit extends Cubit<CompetitionSimulationState> {
  CompetitionSimulationCubit({
    required this.simulator,
  }) : super(const CompetitionSimulationInitial());

  final JumpSimulator<JumpSimulationRecord> simulator;

  // TODO: add simulating context (like skills, entity, manipulation config)
  void simulateJump() {
    //simulator.context = context;
    final simulatedJump = simulator.simulate();
    // TODO: calculate the progress respectively
    emit(
      CompetitionSimulationDone(simulatedJump: simulatedJump),
    );
  }
}

abstract class CompetitionSimulationState with EquatableMixin {
  const CompetitionSimulationState();

  @override
  List<Object?> get props => [];
}

class CompetitionSimulationInitial extends CompetitionSimulationState {
  const CompetitionSimulationInitial();
}

class CompetitionSimulationInProgress extends CompetitionSimulationState {
  const CompetitionSimulationInProgress({
    required this.progress,
    required this.currentDistance,
  });

  // TODO: Invent a good way to show the jump's progress
  /// from 0.0 to 1.0
  final double progress;
  final double currentDistance;
}

class CompetitionSimulationDone extends CompetitionSimulationState {
  const CompetitionSimulationDone({
    required this.simulatedJump,
  });

  // final JumpManipulationConfig
  final JumpSimulationRecord simulatedJump;

  @override
  List<Object?> get props => [
        simulatedJump,
      ];
}
