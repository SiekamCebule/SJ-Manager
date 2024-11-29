import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/reports/team_reports.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/team.dart';

abstract interface class TeamReportsRepository {
  Future<TeamReports?> get(Team team);
  Future<void> set({
    required Team team,
    required TeamReports? reports,
  });
}
