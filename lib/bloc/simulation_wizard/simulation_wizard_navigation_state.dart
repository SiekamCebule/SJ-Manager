import 'package:equatable/equatable.dart';
import 'package:sj_manager/bloc/simulation_wizard/simulation_wizard_screen.dart';

sealed class SimulationWizardNavigationState extends Equatable {
  const SimulationWizardNavigationState();
}

class UninitializedSimulationWizardNavigationState
    extends SimulationWizardNavigationState {
  const UninitializedSimulationWizardNavigationState();

  @override
  List<Object?> get props => [];
}

class InitializedSimulationWizardNavigationState extends SimulationWizardNavigationState {
  const InitializedSimulationWizardNavigationState({
    required this.screens,
    required this.currentScreenIndex,
  });

  final List<SimulationWizardScreen> screens;
  final int currentScreenIndex;

  SimulationWizardScreen get currentScreen => screens[currentScreenIndex];

  bool get indexAllowsGoingBack {
    return currentScreenIndex > 0;
  }

  bool get indexAllowsGoingForward {
    return currentScreenIndex + 1 < screens.length;
  }

  @override
  List<Object?> get props => [screens, currentScreenIndex];
}
