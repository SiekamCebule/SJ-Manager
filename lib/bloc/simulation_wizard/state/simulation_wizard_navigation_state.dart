import 'package:equatable/equatable.dart';
import 'package:sj_manager/bloc/simulation_wizard/simulation_wizard_screen_type.dart';

class SimulationWizardNavigationState with EquatableMixin {
  const SimulationWizardNavigationState({
    required this.currentScreenIndex,
    required this.screen,
    required this.nextScreen,
    required this.canGoBack,
    required this.canGoForward,
  });

  final int currentScreenIndex;
  final SimulationWizardScreenType screen;
  final SimulationWizardScreenType? nextScreen;
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
    SimulationWizardScreenType? screen,
    SimulationWizardScreenType? nextScreen,
    bool? canGoBack,
    bool? canGoForward,
  }) {
    return SimulationWizardNavigationState(
      currentScreenIndex: currentScreenIndex ?? this.currentScreenIndex,
      screen: screen ?? this.screen,
      nextScreen: nextScreen ?? this.nextScreen,
      canGoBack: canGoBack ?? this.canGoBack,
      canGoForward: canGoForward ?? this.canGoForward,
    );
  }
}
