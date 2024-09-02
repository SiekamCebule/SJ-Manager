import 'package:equatable/equatable.dart';
import 'package:sj_manager/bloc/simulation_wizard/simulation_wizard_screen.dart';

class SimulationWizardNavigationState with EquatableMixin {
  const SimulationWizardNavigationState({
    required this.currentScreenIndex,
    required this.screen,
    required this.canGoBack,
    required this.canGoForward,
  });

  final int currentScreenIndex;
  final SimulationWizardScreen screen;
  final bool canGoBack;
  final bool canGoForward;

  @override
  List<Object?> get props => [
        currentScreenIndex,
        screen,
        canGoBack,
        canGoForward,
      ];

  SimulationWizardNavigationState copyWith({
    int? currentScreenIndex,
    SimulationWizardScreen? screen,
    bool? canGoBack,
    bool? canGoForward,
  }) {
    return SimulationWizardNavigationState(
      currentScreenIndex: currentScreenIndex ?? this.currentScreenIndex,
      screen: screen ?? this.screen,
      canGoBack: canGoBack ?? this.canGoBack,
      canGoForward: canGoForward ?? this.canGoForward,
    );
  }
}
