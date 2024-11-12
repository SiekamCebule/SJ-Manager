import 'package:collection/collection.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/flow/simulation_mode.dart';
import 'package:sj_manager/models/database/team/country_team/subteam_type.dart';
import 'package:sj_manager/models/database/team/team.dart';
import 'package:sj_manager/models/simulation/jumper/simulation_jumper.dart';

class SimulationDatabaseHelper {
  SimulationDatabaseHelper({
    required this.database,
  });

  final SimulationDatabase database;

  List<SimulationJumper> get managerJumpers {
    final personalCoachTeamJumpers = database.managerData.personalCoachTeam!.jumpers
        .map((id) => database.idsRepo.get(id) as SimulationJumper)
        .toList();
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

  SubteamType? subteamOfJumper(SimulationJumper jumper) {
    final jumperIds = database.subteamJumpers.keys;
    final toReturn = jumperIds
        .singleWhereOrNull(
            (subteam) => database.subteamJumpers[subteam]!.contains(jumper))
        ?.type;
    return toReturn;
  }
}
