import 'package:collection/collection.dart';
import 'package:sj_manager/domain/entities/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/domain/entities/simulation/flow/reports/team_reports.dart';
import 'package:sj_manager/domain/entities/simulation/flow/simulation_mode.dart';
import 'package:sj_manager/domain/entities/simulation/team/subteam_type.dart';
import 'package:sj_manager/domain/entities/simulation/team/team.dart';
import 'package:sj_manager/domain/entities/simulation/jumper/reports/jumper_reports.dart';
import 'package:sj_manager/domain/entities/simulation/jumper/simulation_jumper.dart';
import 'package:sj_manager/domain/entities/simulation/jumper/stats/jumper_stats.dart';

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

  Map<SimulationJumper, JumperReports> get jumperReportsMap {
    return Map.fromIterable(
        database.jumpers.map((jumper) => MapEntry(jumper, jumper.reports)));
  }

  TeamReports? teamReports(Team team) {
    final id = database.idsRepo.id(team);
    return database.teamReports[id];
  }
}
