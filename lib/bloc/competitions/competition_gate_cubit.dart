import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompetitionGateCubit extends Cubit<CompetitionRoundGateState> {
  CompetitionGateCubit({required int initialGate})
      : super(
          CompetitionRoundGateState(initialGate: initialGate, gate: initialGate),
        );

  void lowerByCoach(int howMuch) {
    final currentState = state as CompetitionRoundGateLoweredByCoachState;
    emit(
      currentState.copyWith(
        gate: state.gate - howMuch,
        howMuchLowered: howMuch,
      ),
    );
  }

  void undoLoweringByCoach() {
    if (state is CompetitionRoundGateLoweredByCoachState == false) {
      throw StateError('The gate is not currently lowered by coach');
    }
    final howMuchRaise =
        (state as CompetitionRoundGateLoweredByCoachState).howMuchLowered;
    emit(state.copyWith(gate: state.gate + howMuchRaise));
  }

  void setInitialGate(int gate) {
    emit(state.copyWith(initialGate: gate));
  }

  void reset() {
    emit(state.copyWith(gate: state.initialGate));
  }

  void lowerByJury(int howMuch) {
    final currentState = state as CompetitionRoundGateLoweredByCoachState;
    emit(
      currentState.copyWith(
        gate: state.gate - howMuch,
        howMuchLowered: howMuch,
      ),
    );
  }

  void raiseByJury(int howMuch) {
    emit(
      state.copyWith(gate: state.gate + howMuch),
    );
  }
}

class CompetitionRoundGateState with EquatableMixin {
  const CompetitionRoundGateState({
    required this.gate,
    required this.initialGate,
  });

  final int gate;
  final int initialGate;

  int get balance => initialGate - gate;

  @override
  List<Object?> get props => [
        gate,
        initialGate,
      ];

  CompetitionRoundGateState copyWith({
    int? gate,
    int? initialGate,
  }) {
    return CompetitionRoundGateState(
      gate: gate ?? this.gate,
      initialGate: initialGate ?? this.initialGate,
    );
  }
}

class CompetitionRoundGateLoweredByCoachState extends CompetitionRoundGateState {
  const CompetitionRoundGateLoweredByCoachState({
    required super.gate,
    required super.initialGate,
    required this.howMuchLowered,
  });

  final int howMuchLowered;

  @override
  List<Object?> get props => [
        super.props,
        howMuchLowered,
      ];

  @override
  CompetitionRoundGateLoweredByCoachState copyWith({
    int? gate,
    int? initialGate,
    int? howMuchLowered,
  }) {
    return CompetitionRoundGateLoweredByCoachState(
      howMuchLowered: howMuchLowered ?? this.howMuchLowered,
      gate: gate ?? this.gate,
      initialGate: initialGate ?? this.initialGate,
    );
  }
}
