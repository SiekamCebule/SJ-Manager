import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/features/career_mode/subfeatures/current_date/domain/usecases/get_simulation_current_date_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/current_date/domain/usecases/set_simulation_current_date_use_case.dart';

class SimulationCurrentDateCubit extends Cubit<SimulationCurrentDateState> {
  SimulationCurrentDateCubit({
    required this.getDate,
    required this.setDate,
  }) : super(const SimulationCurrentDateInitial());

  final GetSimulationCurrentDateUseCase getDate;
  final SetSimulationCurrentDateUseCase setDate;

  Future<void> initialize() async {
    emit(SimulationCurrentDateDefault(currentDate: await getDate()));
  }

  Future<void> setCurrentDate(DateTime date) async {
    await setDate(date);
    emit(SimulationCurrentDateDefault(currentDate: await getDate()));
  }
}

abstract class SimulationCurrentDateState extends Equatable {
  const SimulationCurrentDateState();

  @override
  List<Object?> get props => [];
}

class SimulationCurrentDateInitial extends SimulationCurrentDateState {
  const SimulationCurrentDateInitial();
}

class SimulationCurrentDateDefault extends SimulationCurrentDateState {
  const SimulationCurrentDateDefault({
    required this.currentDate,
  });

  final DateTime currentDate;

  @override
  List<Object?> get props => [currentDate];
}
