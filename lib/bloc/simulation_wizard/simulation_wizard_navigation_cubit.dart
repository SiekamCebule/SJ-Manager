import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/bloc/simulation_wizard/simulation_wizard_screen.dart';
import 'package:sj_manager/bloc/simulation_wizard/simulation_wizard_navigation_state.dart';

// Musimy udostępnić w stanie cubita info o tym, czy można przejść do przodu/do tyłu
// Czy screens też? Kto tego potrzebuje? MOże też być potrzebne
// Tak jak current

// Jak więc usunąć opóżnienie?

class SimulationWizardNavigationCubit extends Cubit<SimulationWizardNavigationState> {
  SimulationWizardNavigationCubit()
      : super(const UninitializedSimulationWizardNavigationState());

  void setUp({
    required List<SimulationWizardScreen> screens,
  }) {
    emit(InitializedSimulationWizardNavigationState(
      screens: screens,
      canGoBack: _canGoBack(currentScreenIndex: 0),
      canGoForward: _canGoForward(screens: screens, currentScreenIndex: 0),
      currentScreenIndex: 0,
    ));
  }

  void goForward() {
    if (state is InitializedSimulationWizardNavigationState) {
      _tryGoForward();
    } else {
      _throwUninitializedWhenNavigatingError();
    }
  }

  void _tryGoForward() {
    final prevState = state as InitializedSimulationWizardNavigationState;
    if (prevState.canGoForward) {
      final int currentIndex = prevState.currentScreenIndex + 1;
      emit(InitializedSimulationWizardNavigationState(
        screens: prevState.screens,
        currentScreenIndex: currentIndex,
        canGoBack: prevState.canGoBack,
        canGoForward: _canGoForward(
          screens: prevState.screens,
          currentScreenIndex: currentIndex,
        ),
      ));
    } else {
      _throwCannotGoForwardError();
    }
  }

  void goBack() {
    if (state is InitializedSimulationWizardNavigationState) {
      _tryGoBack();
    } else {
      _throwUninitializedWhenNavigatingError();
    }
  }

  void _tryGoBack() {
    final prevState = state as InitializedSimulationWizardNavigationState;
    if (prevState.canGoBack) {
      final currentIndex = prevState.currentScreenIndex - 1;
      emit(InitializedSimulationWizardNavigationState(
        screens: prevState.screens,
        currentScreenIndex: currentIndex,
        canGoForward: prevState.canGoForward,
        canGoBack: _canGoBack(currentScreenIndex: currentIndex),
      ));
    } else {
      _throwCannotGoBackError();
    }
  }

  bool _canGoForward({
    required List<SimulationWizardScreen> screens,
    required int currentScreenIndex,
  }) {
    return currentScreenIndex + 1 < screens.length;
  }

  bool _canGoBack({
    required int currentScreenIndex,
  }) {
    return currentScreenIndex > 0;
  }

  void _throwCannotGoForwardError() {
    throw StateError(
        'SimulationWizardCubit cannot go forward in the actual state ($state)');
  }

  void _throwCannotGoBackError() {
    throw StateError('SimulationWizardCubit cannot go back in the actual state ($state)');
  }

  void _throwUninitializedWhenNavigatingError() {
    throw StateError('SimulationWizardCubit must be initialized before navigating');
  }
}
