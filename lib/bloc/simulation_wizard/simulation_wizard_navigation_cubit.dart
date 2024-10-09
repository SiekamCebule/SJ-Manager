import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/bloc/simulation_wizard/simulation_wizard_screen_type.dart';
import 'package:sj_manager/bloc/simulation_wizard/state/simulation_wizard_navigation_state.dart';
import 'package:sj_manager/models/simulation/enums.dart';
import 'package:sj_manager/utils/iterable.dart';

class SimulationWizardNavigationCubit extends Cubit<SimulationWizardNavigationState> {
  SimulationWizardNavigationCubit({
    required this.onFinish,
  }) : super(
          const SimulationWizardNavigationState(
            currentScreenIndex: 0,
            screen: SimulationWizardScreenType.mode,
            nextScreen: null,
            canGoBack: false,
            canGoForward: false,
          ),
        );

  final Function() onFinish;
  bool _finished = false;
  SimulationMode? _mode;
  SimulationMode? get mode => _mode;
  set mode(SimulationMode? other) {
    _mode = other;
    if (_mode == null) return;
    final screensCache = screens;
    emit(
      SimulationWizardNavigationState(
        currentScreenIndex: 0,
        screen: screensCache.first,
        nextScreen: screensCache.maybeElementAt(1),
        canGoBack: false,
        canGoForward: screensCache.length > 1,
      ),
    );
  }

  List<SimulationWizardScreenType> get screens {
    return switch (mode) {
      SimulationMode.personalCoach => forPersonalCoach,
      SimulationMode.classicCoach => forClassicCoach,
      SimulationMode.observer => forObserver,
      null => [],
    };
  }

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

  static const forPersonalCoach = [
    SimulationWizardScreenType.mode,
    SimulationWizardScreenType.gameVariant,
    SimulationWizardScreenType.startDate,
    SimulationWizardScreenType.otherOptions,
  ];

  static const forClassicCoach = [
    SimulationWizardScreenType.mode,
    SimulationWizardScreenType.gameVariant,
    SimulationWizardScreenType.startDate,
    SimulationWizardScreenType.team,
    SimulationWizardScreenType.subteam,
    SimulationWizardScreenType.otherOptions,
  ];

  static const forObserver = [
    SimulationWizardScreenType.mode,
    SimulationWizardScreenType.gameVariant,
    SimulationWizardScreenType.startDate,
    SimulationWizardScreenType.otherOptions,
  ];
}
