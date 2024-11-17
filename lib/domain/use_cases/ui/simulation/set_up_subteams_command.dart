import 'package:sj_manager/utilities/algorithms/subteam_appointments/partial/default_partial_appointments_algorithm.dart';
import 'package:sj_manager/domain/use_cases/simulation_database_use_cases.dart';
import 'package:sj_manager/domain/entities/simulation/database/actions/simulation_action_type.dart';
import 'package:sj_manager/domain/entities/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/domain/entities/simulation/flow/simulation_mode.dart';
import 'package:sj_manager/core/team/country_team/country_team.dart';
import 'package:sj_manager/domain/entities/simulation/team/subteam_type.dart';
import 'package:sj_manager/domain/entities/simulation/team/subteam.dart';
import 'package:sj_manager/domain/entities/simulation/jumper/simulation_jumper.dart';

class SetUpSubteamsCommand {
  SetUpSubteamsCommand({
    required this.database,
    required this.chooseSubteamId,
    required this.onFinish,
  });

  final SimulationDatabase database;
  final String Function(Subteam subteam) chooseSubteamId;
  final Function()? onFinish;

  Future<void> execute() async {
    var database = this.database;
    if (database.managerData.mode == SimulationMode.classicCoach) {
    } else {
      for (final countryTeam in database.countryTeams) {
        final subteams = _chooseSubteams(countryTeam);
        subteams.forEach((subteamType, jumpers) {
          final subteam = Subteam(parentTeam: countryTeam, type: subteamType);
          SimulationDatabaseUseCases(database: database).setSubteam(
            subteam: subteam,
            jumpers: jumpers,
            subteamNewId: chooseSubteamId(subteam),
          );
        });
      }
    }
    database.actionsRepo.complete(SimulationActionType.settingUpSubteams);
    onFinish?.call();
    database.notify();
  }

  Map<SubteamType, Iterable<SimulationJumper>> _chooseSubteams(CountryTeam countryTeam) {
    var availableJumpers = database.jumpers.where(
      (jumper) => jumper.country == countryTeam.country,
    );
    final subteamJumpers = <SubteamType, Iterable<SimulationJumper>>{};

    for (final subteamType in SubteamType.values) {
      if (countryTeam.facts.subteams.contains(subteamType)) {
        if (availableJumpers.isEmpty) {
          return subteamJumpers;
        }
        final limit = countryTeam.facts.limitInSubteam[subteamType]!;
        const algorithm = DefaultPartialAppointmentsAlgorithm();
        final chosenJumpers = algorithm.chooseBestJumpers(
          source: availableJumpers,
          limit: limit,
        );
        subteamJumpers[subteamType] = chosenJumpers;
        availableJumpers = availableJumpers.toSet().difference(chosenJumpers.toSet());
      }
    }

    return subteamJumpers;
  }
}
