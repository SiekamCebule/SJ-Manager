import 'package:sj_manager/features/career_mode/subfeatures/team_reports/domain/repository/team_reports_repository.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/team_reports.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/simulation_team.dart';

class GetTeamReportsUseCase {
  GetTeamReportsUseCase({
    required this.teamReportsRepository,
  });

  final TeamReportsRepository teamReportsRepository;

  Future<TeamReports> call({required SimulationTeam team}) async {
    final nullableReports = await teamReportsRepository.get(team);
    return nullableReports!;
  }
}
