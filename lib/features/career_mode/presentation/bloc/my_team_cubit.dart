import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/features/career_mode/subfeatures/manager_data/domain/usecases/add_charge_use_case.dart';

import 'package:sj_manager/features/career_mode/subfeatures/manager_data/domain/usecases/get_charges_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/manager_data/domain/usecases/get_manager_team_reports_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/manager_data/domain/usecases/reorder_charges_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/usecases/training_config/set_jumper_training_balance_use_case.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/team_reports.dart';

class MyTeamCubit extends Cubit<MyTeamState> {
  MyTeamCubit({
    required this.getTrainees,
    required this.getReports,
    required this.setBalanceUseCase,
    required this.reorderTraineesUseCase,
    required this.addTraineeUseCase,
  }) : super(const MyTeamInitial());

  final GetTraineesUseCase getTrainees;
  final GetManagerTeamReportsUseCase getReports;
  final SetJumperTrainingBalanceUseCase setBalanceUseCase;
  final ReorderTraineesUseCase reorderTraineesUseCase;
  final AddTraineeUseCase addTraineeUseCase;

  Future<void> initialize() async {
    emit(MyTeamDefault(
      trainees: await getTrainees(),
      teamReports: await getReports(),
    ));
  }

  Future<void> reorderTrainees(Iterable<SimulationJumper> order) async {
    final state = this.state as MyTeamDefault;
    await reorderTraineesUseCase(order);
    emit(state.copyWith(
      trainees: await getTrainees(),
    ));
  }

  Future<void> addTrainee(SimulationJumper trainee) async {
    final state = this.state as MyTeamDefault;
    await addTraineeUseCase(trainee);
    emit(state.copyWith(
      trainees: await getTrainees(),
    ));
  }
}

abstract class MyTeamState extends Equatable {
  const MyTeamState();

  @override
  List<Object?> get props => [];
}

class MyTeamInitial extends MyTeamState {
  const MyTeamInitial();
}

class MyTeamDefault extends MyTeamState {
  const MyTeamDefault({
    required this.trainees,
    required this.teamReports,
  });

  final Iterable<SimulationJumper> trainees;
  final TeamReports teamReports;

  @override
  List<Object?> get props => [
        trainees,
        teamReports,
      ];

  MyTeamDefault copyWith({
    Iterable<SimulationJumper>? trainees,
    TeamReports? teamReports,
  }) {
    return MyTeamDefault(
      trainees: trainees ?? this.trainees,
      teamReports: teamReports ?? this.teamReports,
    );
  }
}
