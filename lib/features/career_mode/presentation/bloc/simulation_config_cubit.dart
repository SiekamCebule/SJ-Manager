import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/features/career_mode/subfeatures/config/domain/usecases/get_trainees_limit_for_personal_coach_use_case.dart';

class SimulationConfigCubit extends Cubit<SimulationConfigState> {
  SimulationConfigCubit({
    required this.getTraineesLimitForPersonalCoachUseCase,
  }) : super(const SimulationConfigInitial());

  final GetTraineesLimitForPersonalCoachUseCase getTraineesLimitForPersonalCoachUseCase;

  Future<void> initialize() async {
    emit(
      SimulationConfigDefault(
        traineesLimitForPersonalCoach: await getTraineesLimitForPersonalCoachUseCase(),
      ),
    );
  }
}

abstract class SimulationConfigState extends Equatable {
  const SimulationConfigState();

  @override
  List<Object?> get props => [];
}

class SimulationConfigInitial extends SimulationConfigState {
  const SimulationConfigInitial();
}

class SimulationConfigDefault extends SimulationConfigState {
  const SimulationConfigDefault({
    required this.traineesLimitForPersonalCoach,
  });

  final int traineesLimitForPersonalCoach;

  @override
  List<Object?> get props => [
        traineesLimitForPersonalCoach,
      ];
}
