import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/algorithms/subteam_appointments/partial/default_partial_appointments_algorithm.dart';
import 'package:sj_manager/models/simulation/database/actions/simulation_action_type.dart';
import 'package:sj_manager/models/simulation/database/helper/simulation_database_helper.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/flow/simulation_mode.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/country_team/country_team.dart';
import 'package:sj_manager/models/user_db/team/country_team/subteam_type.dart';
import 'package:sj_manager/models/user_db/team/subteam.dart';
import 'package:sj_manager/repositories/countries/country_flags/country_flags_repo.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/db_item_image_generating_setup.dart';
import 'package:sj_manager/ui/screens/simulation/large/dialogs/set_up_subteams/subteams_setting_up_personal_coach_dialog.dart';
import 'package:sj_manager/utils/show_dialog.dart';

class SetUpSubteamsCommand {
  SetUpSubteamsCommand({
    required this.context,
    required this.database,
  });

  final BuildContext context;
  final SimulationDatabase database;

  Future<SimulationDatabase> execute() async {
    var database = this.database;
    if (database.managerData.mode == SimulationMode.classicCoach) {
      // TODO: Do some work in UI and change the algorithm do include user's choices
    } else {
      final teams = {
        for (final countryTeam in database.countryTeams.last)
          countryTeam: _chooseSubteams(countryTeam),
      };
      final preparedSubteamJumpers = {
        for (final countryTeam in teams.keys)
          for (final subteamType in teams[countryTeam]!.keys)
            Subteam(parentTeam: countryTeam, type: subteamType):
                teams[countryTeam]![subteamType]!,
      };
      database = database.copyWith(subteamJumpers: preparedSubteamJumpers);
      if (database.managerData.mode == SimulationMode.personalCoach) {
        final dbHelper = SimulationDatabaseHelper.constant(database: database);
        final charges = dbHelper.managerJumpers;
        await showSjmDialog(
          context: context,
          barrierDismissible: true,
          child: MultiProvider(
            providers: [
              Provider.value(value: context.read<DbItemImageGeneratingSetup<Jumper>>()),
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
    return database;
  }

  Map<SubteamType, Iterable<String>> _chooseSubteams(CountryTeam countryTeam) {
    var availableJumpers = database.jumpers.last.where(
      (jumper) => jumper.country == countryTeam.country,
    );
    final form = database.jumperDynamicParams
        .map((jumper, dynamicParams) => MapEntry(jumper, dynamicParams.form));
    final subteamJumpers = <SubteamType, Iterable<String>>{};

    for (final subteamType in SubteamType.values) {
      if (countryTeam.facts.subteams.contains(subteamType)) {
        if (availableJumpers.isEmpty) {
          return subteamJumpers;
        }
        final limit = countryTeam.facts.limitInSubteam[subteamType]!;
        const algorithm = DefaultPartialAppointmentsAlgorithm();
        final chosenJumpers = algorithm.chooseBestJumpers(
          source: availableJumpers,
          form: form,
          limit: limit,
        );
        subteamJumpers[subteamType] = chosenJumpers.map(
          (jumper) => database.idsRepo.idOf(jumper) as String,
        );
        availableJumpers = availableJumpers.toSet().difference(chosenJumpers.toSet());
      }
    }

    return subteamJumpers;
  }
}
