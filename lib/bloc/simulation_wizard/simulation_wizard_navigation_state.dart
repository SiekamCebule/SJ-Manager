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
    required this.canGoForward,
    required this.canGoBack,
  });

  final List<SimulationWizardScreen> screens;
  final int currentScreenIndex;
  final bool canGoForward;
  final bool canGoBack;
  SimulationWizardScreen get currentScreen => screens[currentScreenIndex];

  @override
  List<Object?> get props => [screens, currentScreenIndex];
}
