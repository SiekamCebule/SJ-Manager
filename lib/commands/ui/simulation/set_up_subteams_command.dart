import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/algorithms/subteam_appointments/partial/default_partial_appointments_algorithm.dart';
import 'package:sj_manager/commands/simulation_database/simulation_database_commander.dart';
import 'package:sj_manager/models/simulation/database/actions/simulation_action_type.dart';
import 'package:sj_manager/models/simulation/database/helper/simulation_database_helper.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/flow/simulation_mode.dart';
import 'package:sj_manager/models/database/team/country_team/country_team.dart';
import 'package:sj_manager/models/database/team/country_team/subteam_type.dart';
import 'package:sj_manager/models/database/team/subteam.dart';
import 'package:sj_manager/models/simulation/jumper/simulation_jumper.dart';
import 'package:sj_manager/repositories/countries/country_flags/country_flags_repo.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/db_item_image_generating_setup.dart';
import 'package:sj_manager/ui/screens/simulation/large/dialogs/set_up_subteams/subteams_setting_up_personal_coach_dialog.dart';
import 'package:sj_manager/utils/id_generator.dart';
import 'package:sj_manager/utils/show_dialog.dart';

class SetUpSubteamsCommand {
  SetUpSubteamsCommand({
    required this.context,
    required this.database,
  });

  final BuildContext context;
  final SimulationDatabase database;

  Future<void> execute() async {
    var database = this.database;
    if (database.managerData.mode == SimulationMode.classicCoach) {
      // TODO: Do some work in UI and change the algorithm to include user's choices
    } else {
      for (final countryTeam in database.countryTeams) {
        final subteams = _chooseSubteams(countryTeam);
        subteams.forEach((subteamType, jumpers) {
          SimulationDatabaseCommander(database: database).setSubteam(
            subteam: Subteam(parentTeam: countryTeam, type: subteamType),
            jumpers: jumpers,
            subteamNewId: context.read<IdGenerator>().generate(),
          );
        });
      }
      final dbHelper = context.read<SimulationDatabaseHelper>();

      if (database.managerData.mode == SimulationMode.personalCoach &&
          dbHelper.managerJumpers.isNotEmpty) {
        final charges = dbHelper.managerJumpers;
        await showSjmDialog(
          context: context,
          barrierDismissible: true,
          child: MultiProvider(
            providers: [
              Provider.value(
                  value: context.read<DbItemImageGeneratingSetup<SimulationJumper>>()),
              Provider.value(value: context.read<CountryFlagsRepo>()),
            ],
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: SubteamsSettingUpPersonalCoachDialog(
                jumpers: charges,
                subteamType: {
                  for (final charge in charges) charge: dbHelper.subteamOfJumper(charge)!,
                },
              ),
            ),
          ),
        );
      }
    }
    database.actionsRepo.complete(SimulationActionType.settingUpSubteams);
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
