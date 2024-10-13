import 'package:flutter_bloc/flutter_bloc.dart';

class SimulationScreenNavigationCubit extends Cubit<SimulationScreenNavigationState> {
  SimulationScreenNavigationCubit()
      : super(const SimulationScreenNavigationState(screenIndex: 0));

  void change({required int index}) {
    emit(state.copyWith(screenIndex: index));
  }
}

class SimulationScreenNavigationState {
  const SimulationScreenNavigationState({
    required this.screenIndex,
  });

  final int screenIndex;

  SimulationScreenNavigationState copyWith({
    int? screenIndex,
  }) {
    return SimulationScreenNavigationState(
      screenIndex: screenIndex ?? this.screenIndex,
    );
  }
}
