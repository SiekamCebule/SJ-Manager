import 'package:equatable/equatable.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/team_reports.dart';

abstract class SimulationTeam with EquatableMixin {
  SimulationTeam({
    this.reports,
  });

  TeamReports? reports;
  Iterable<SimulationJumper> get jumpers;

  @override
  List<Object?> get props => [];
}
