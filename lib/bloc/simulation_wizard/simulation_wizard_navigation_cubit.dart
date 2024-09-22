import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/bloc/simulation_wizard/simulation_wizard_screen_type.dart';
import 'package:sj_manager/bloc/simulation_wizard/state/simulation_wizard_navigation_state.dart';
import 'package:sj_manager/utils/iterable.dart';

class SimulationWizardNavigationCubit extends Cubit<SimulationWizardNavigationState> {
  SimulationWizardNavigationCubit({
    required this.screens,
    required this.onFinish,
  }) : super(
          SimulationWizardNavigationState(
            currentScreenIndex: 0,
            screen: screens[0],
            nextScreen: screens.maybeElementAt(1),
            canGoBack: false,
            canGoForward: screens.length > 1,
          ),
        );

  final List<SimulationWizardScreenType> screens;
  final Function() onFinish;
  bool _finished = false;

  void goForward() {
    if (state.screen == screens.last) {
      if (!_finished) {
        onFinish();
        _finished = true;
        return;
      } else {
        throw StateError('Cannot go forward in current state');
      }
    }
    final currentIndex = state.currentScreenIndex;
    emit(
      SimulationWizardNavigationState(
        currentScreenIndex: currentIndex + 1,
        screen: screens[currentIndex + 1],
        nextScreen: screens.maybeElementAt(currentIndex + 2),
        canGoBack: true,
        canGoForward: _shouldBeAbleToGoForward(),
      ),
    );
  }

  void goBack() {
    if (!state.canGoBack) {
      throw StateError('Cannot go forward in current state');
    }
    final currentIndex = state.currentScreenIndex;
    emit(
      SimulationWizardNavigationState(
        currentScreenIndex: currentIndex - 1,
        screen: screens[currentIndex - 1],
        nextScreen: screens[currentIndex],
        canGoBack: currentIndex - 1 > 0,
        canGoForward: true,
      ),
    );
  }

  void blockGoingForward() {
    emit(state.copyWith(
      canGoForward: false,
    ));
  }

  void unblockGoingForward() {
    emit(state.copyWith(
      canGoForward: _shouldBeAbleToGoForward(),
    ));
  }

  bool _shouldBeAbleToGoForward() {
    return screens.length > state.currentScreenIndex + 1;
  }
}
