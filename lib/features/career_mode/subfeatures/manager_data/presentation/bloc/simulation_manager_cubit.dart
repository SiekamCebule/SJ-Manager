import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/features/career_mode/subfeatures/manager_data/domain/usecases/add_manager_charge_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/manager_data/domain/usecases/get_manager_charges_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/manager_data/domain/usecases/get_manager_team_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/manager_data/domain/usecases/get_simulation_mode_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/manager_data/domain/usecases/set_manager_charges_use_case.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_mode.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/team.dart';

class SimulationManagerCubit extends Cubit<SimulationManagerState> {
  SimulationManagerCubit({
    required this.getMode,
    required this.getTeam,
    required this.getCharges,
    required this.setCharges,
    required this.addCharge,
  }) : super(const SimulationManagerInitial());

  final GetSimulationModeUseCase getMode;
  final GetManagerTeamUseCase getTeam;
  final GetManagerChargesUseCase getCharges;
  final SetManagerChargesUseCase setCharges;
  final AddManagerChargeUseCase addCharge;

  Future<void> initialize() async {
    emit(SimulationManagerDefault(
      mode: await getMode(),
      team: await getTeam(),
      charges: await getCharges(),
    ));
  }

  Future<void> setManagerCharges(Iterable<SimulationJumper> charges) async {
    await setCharges(charges);
    emit(SimulationManagerDefault(
      mode: await getMode(),
      team: await getTeam(),
      charges: await getCharges(),
    ));
  }

  Future<void> addManagerCharge(SimulationJumper charge) async {
    await addCharge(charge);
    emit(SimulationManagerDefault(
      mode: await getMode(),
      team: await getTeam(),
      charges: await getCharges(),
    ));
  }
}

abstract class SimulationManagerState extends Equatable {
  const SimulationManagerState();

  @override
  List<Object?> get props => [];
}

class SimulationManagerInitial extends SimulationManagerState {
  const SimulationManagerInitial();
}

class SimulationManagerDefault extends SimulationManagerState {
  const SimulationManagerDefault({
    required this.mode,
    required this.team,
    required this.charges,
  });

  final SimulationMode mode;
  final Team? team;
  final Iterable<SimulationJumper> charges;
}
