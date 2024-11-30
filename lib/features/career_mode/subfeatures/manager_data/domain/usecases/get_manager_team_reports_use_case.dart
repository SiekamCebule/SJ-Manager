import 'package:sj_manager/features/career_mode/subfeatures/manager_data/domain/repository/simulation_manager_data_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/team_reports/domain/repository/team_reports_repository.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_mode.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/team_reports.dart';

class GetManagerTeamReportsUseCase {
  const GetManagerTeamReportsUseCase({
    required this.managerDataRepository,
    required this.teamReportsRepository,
  });

  final SimulationManagerDataRepository managerDataRepository;
  final TeamReportsRepository teamReportsRepository;

  Future<TeamReports> call() async {
    final managerData = await managerDataRepository.get();
    return switch (managerData.mode) {
      SimulationMode.classicCoach =>
        (await teamReportsRepository.get(managerData.userSubteam!))!,
      SimulationMode.personalCoach =>
        (await teamReportsRepository.get(managerData.personalCoachTeam!))!,
      SimulationMode.observer =>
        throw StateError('An observer cannot have a team,so cannot have TeamReports'),
    };
  }
}
