import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/bloc/simulation_wizard/linear_navigation_permissions_repo.dart';
import 'package:sj_manager/bloc/simulation_wizard/simulation_wizard_screen.dart';
import 'package:sj_manager/bloc/simulation_wizard/simulation_wizard_navigation_state.dart';

class SimulationWizardNavigationCubit
    extends Cubit<SimulationWizardNavigationState> {
  SimulationWizardNavigationCubit({required this.navPermissions})
      : super(const UninitializedSimulationWizardNavigationState());

  final LinearNavigationPermissionsRepo navPermissions;

  void setUp({
    required List<SimulationWizardScreen> screens,
  }) {
    emit(InitializedSimulationWizardNavigationState(
      screens: screens,
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
    if (navPermissions.canGoForward) {
      final int currentIndex = prevState.currentScreenIndex + 1;
      emit(InitializedSimulationWizardNavigationState(
        screens: prevState.screens,
        currentScreenIndex: currentIndex,
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
    if (navPermissions.canGoBack) {
      final currentIndex = prevState.currentScreenIndex - 1;
      emit(InitializedSimulationWizardNavigationState(
        screens: prevState.screens,
        currentScreenIndex: currentIndex,
      ));
    } else {
      _throwCannotGoBackError();
    }
  }

  void _throwCannotGoForwardError() {
    throw StateError(
        'SimulationWizardCubit cannot go forward in the actual state ($state)');
  }

  void _throwCannotGoBackError() {
    throw StateError(
        'SimulationWizardCubit cannot go back in the actual state ($state)');
  }

  void _throwUninitializedWhenNavigatingError() {
    throw StateError(
        'SimulationWizardCubit must be initialized before navigating');
  }
}
