import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompetitionGateCubit extends Cubit<CompetitionGateState> {
  CompetitionGateCubit({required int initialGate})
      : _lastGateBeforeCoach = initialGate,
        super(
          CompetitionGateState(initialGate: initialGate, gate: initialGate),
        );

  late int _lastGateBeforeCoach;

  void lowerByCoach(int howMuch) {
    emit(
      CompetitionGateLoweredByCoachState(
        gate: _lastGateBeforeCoach - howMuch,
        howMuchLowered: howMuch,
        initialGate: state.initialGate,
      ),
    );
  }

  void undoLoweringByCoach() {
    if (state is CompetitionGateLoweredByCoachState == false) {
      throw StateError('The gate is not currently lowered by coach');
    }
    emit(
      CompetitionGateState(
        gate: _lastGateBeforeCoach,
        initialGate: state.initialGate,
      ),
    );
  }

  void setUpBeforeRound(int gate) {
    _lastGateBeforeCoach = gate;
    emit(
      CompetitionGateState(gate: gate, initialGate: gate),
    );
  }

  void lowerByJury(int howMuch) {
    _lastGateBeforeCoach = state.gate - howMuch;
    emit(
      state.copyWith(
        gate: state.gate - howMuch,
      ),
    );
  }

  void raiseByJury(int howMuch) {
    _lastGateBeforeCoach = state.gate + howMuch;
    emit(
      state.copyWith(gate: state.gate + howMuch),
    );
  }
}

class CompetitionGateState with EquatableMixin {
  const CompetitionGateState({
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

  CompetitionGateState copyWith({
    int? gate,
    int? initialGate,
  }) {
    return CompetitionGateState(
      gate: gate ?? this.gate,
      initialGate: initialGate ?? this.initialGate,
    );
  }
}

class CompetitionGateLoweredByCoachState extends CompetitionGateState {
  const CompetitionGateLoweredByCoachState({
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
  CompetitionGateLoweredByCoachState copyWith({
    int? gate,
    int? initialGate,
    int? howMuchLowered,
  }) {
    return CompetitionGateLoweredByCoachState(
      howMuchLowered: howMuchLowered ?? this.howMuchLowered,
      gate: gate ?? this.gate,
      initialGate: initialGate ?? this.initialGate,
    );
  }
}
