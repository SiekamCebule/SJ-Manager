import 'package:collection/collection.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/flow/reports/team_reports.dart';
import 'package:sj_manager/models/simulation/flow/simulation_mode.dart';
import 'package:sj_manager/models/database/team/country_team/subteam_type.dart';
import 'package:sj_manager/models/database/team/team.dart';
import 'package:sj_manager/models/simulation/jumper/reports/jumper_reports.dart';
import 'package:sj_manager/models/simulation/jumper/simulation_jumper.dart';
import 'package:sj_manager/models/simulation/jumper/stats/jumper_stats.dart';

class SimulationDatabaseHelper {
  SimulationDatabaseHelper({
    required this.database,
  });

  final SimulationDatabase database;

  List<SimulationJumper> get managerJumpers {
    final personalCoachTeamJumpers = database.managerData.personalCoachTeam!.jumpers;
    return switch (database.managerData.mode) {
      SimulationMode.classicCoach => throw UnimplementedError(),
      SimulationMode.personalCoach => personalCoachTeamJumpers,
      SimulationMode.observer => throw UnsupportedError(
          'Prosimy o zgłoszenie nam tego błędu. W trybie obserwatora gracz nie ma żadnych podopiecznych.',
        ),
    };
  }

  Team get managerTeam {
    return switch (database.managerData.mode) {
      SimulationMode.classicCoach => throw UnimplementedError(),
      SimulationMode.personalCoach => database.managerData.personalCoachTeam!,
      SimulationMode.observer => throw UnsupportedError(
          'Prosimy o zgłoszenie nam tego błędu. W trybie obserwatora gracz nie ma żadnej drużyny.',
        ),
    };
  }

  String id(dynamic jumper) {
    return database.idsRepo.id(jumper);
  }

  SubteamType? subteamOfJumper(SimulationJumper jumper) {
    final id = database.idsRepo.id(jumper);
    final jumperIds = database.subteamJumpers.keys;
    final subteam = jumperIds.singleWhereOrNull(
        (subteamId) => database.subteamJumpers[subteamId]!.contains(id));
    return subteam?.type;
  }

  JumperReports? jumperReports(SimulationJumper jumper) {
    final id = database.idsRepo.id(jumper);
    return database.jumperReports[id];
  }

  Map<SimulationJumper, JumperReports> get jumperReportsMap {
    return database.jumperReports
        .map((id, reports) => MapEntry(database.idsRepo.get(id), reports));
  }

  JumperStats? jumperStats(SimulationJumper jumper) {
    final id = database.idsRepo.id(jumper);
    return database.jumperStats[id];
  }

  TeamReports? teamReports(Team team) {
    final id = database.idsRepo.id(team);
    return database.teamReports[id];
  }
}
