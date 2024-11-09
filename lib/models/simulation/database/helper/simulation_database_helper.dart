import 'dart:async';

import 'package:collection/collection.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/flow/simulation_mode.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/country_team/subteam_type.dart';
import 'package:sj_manager/models/user_db/team/subteam.dart';
import 'package:sj_manager/models/user_db/team/team.dart';

class SimulationDatabaseHelper {
  SimulationDatabaseHelper({
    required this.databaseStream,
    required SimulationDatabase initial,
  }) : _database = initial {
    _subscription = databaseStream.listen((database) {
      _database = database;
    });
  }

  SimulationDatabaseHelper.constant({
    required SimulationDatabase database,
  }) : this(databaseStream: Stream.value(database), initial: database);

  void dispose() {
    _subscription.cancel();
  }

  final Stream<SimulationDatabase> databaseStream;
  late final StreamSubscription<SimulationDatabase> _subscription;

  late SimulationDatabase _database;

  List<Jumper> get managerJumpers {
    final personalCoachTeamJumpers = _database.managerData.personalCoachTeam!.jumperIds
        .map((id) => _database.idsRepo.get(id) as Jumper)
        .toList();
    return switch (_database.managerData.mode) {
      SimulationMode.classicCoach => throw UnimplementedError(),
      SimulationMode.personalCoach => personalCoachTeamJumpers,
      SimulationMode.observer => throw UnsupportedError(
          'Prosimy o zgłoszenie nam tego błędu. W trybie obserwatora gracz nie ma żadnych podopiecznych.',
        ),
    };
  }

  Team get managerTeam {
    return switch (_database.managerData.mode) {
      SimulationMode.classicCoach => throw UnimplementedError(),
      SimulationMode.personalCoach => _database.managerData.personalCoachTeam!,
      SimulationMode.observer => throw UnsupportedError(
          'Prosimy o zgłoszenie nam tego błędu. W trybie obserwatora gracz nie ma żadnej drużyny.',
        ),
    };
  }

  SubteamType? subteamOfJumper(Jumper jumper) {
    final jumperId = _database.idsRepo.idOf(jumper);
    final jumperIds = _database.subteamJumpers.keys;
    final toReturn = jumperIds
        .singleWhereOrNull(
            (subteam) => _database.subteamJumpers[subteam]!.contains(jumperId))
        ?.type;
    return toReturn;
  }

  Iterable<Jumper> jumpersInSubteam(Subteam subteam) {
    return _database.subteamJumpers[subteam]!
        .map((jumperId) => _database.idsRepo.get(jumperId) as Jumper);
  }
}
