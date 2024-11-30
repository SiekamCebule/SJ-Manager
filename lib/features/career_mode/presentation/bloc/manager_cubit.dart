import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/features/career_mode/subfeatures/manager_data/domain/usecases/get_manager_team_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/manager_data/domain/usecases/get_simulation_mode_use_case.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_mode.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/simulation_team.dart';

class ManagerCubit extends Cubit<ManagerState> {
  ManagerCubit({
    required this.getMode,
    required this.getTeam,
  }) : super(const ManagerInitial());

  final GetSimulationModeUseCase getMode;
  final GetManagerTeamUseCase getTeam;

  Future<void> initialize() async {
    emit(ManagerDefault(
      mode: await getMode(),
      team: await getTeam(),
    ));
  }

  // Future<void> changeTeam(Team team) async {}
  // Future<void> rejectTeam() async {}
  // Future<void> changeMode(SimulationMode mode) async {}
}

abstract class ManagerState extends Equatable {
  const ManagerState();

  @override
  List<Object?> get props => [];
}

class ManagerInitial extends ManagerState {
  const ManagerInitial();
}

class ManagerDefault extends ManagerState {
  const ManagerDefault({
    required this.mode,
    required this.team,
  });

  final SimulationMode mode;
  final SimulationTeam? team;
}
