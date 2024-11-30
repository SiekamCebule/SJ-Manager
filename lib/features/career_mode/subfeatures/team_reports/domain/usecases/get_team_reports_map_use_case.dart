import 'package:sj_manager/features/career_mode/subfeatures/manager_data/domain/repository/simulation_manager_data_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/repository/subteams_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/team_reports/domain/repository/team_reports_repository.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/team_reports.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/simulation_team.dart';

class GetTeamReportsMapUseCase {
  GetTeamReportsMapUseCase({
    required this.teamReportsRepository,
    required this.subteamsRepository,
    required this.managerDataRepository,
  });

  final TeamReportsRepository teamReportsRepository;
  final SubteamsRepository subteamsRepository;
  final SimulationManagerDataRepository managerDataRepository;

  Future<Map<SimulationTeam, TeamReports>> call() async {
    final subteams = await subteamsRepository.getAll();
    final managerData = await managerDataRepository.get();
    final personalCoachTeam = managerData.personalCoachTeam;
    return {
      for (final subteam in subteams)
        subteam: (await teamReportsRepository.get(subteam))!,
      if (personalCoachTeam != null)
        personalCoachTeam: (await teamReportsRepository.get(personalCoachTeam))!
    };
  }
}
