import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/bloc/simulation/simulation_database_cubit.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/personal_coach_team.dart';
import 'package:sj_manager/repositories/countries/country_flags/country_flags_repo.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/db_item_image_generating_setup.dart';
import 'package:sj_manager/ui/screens/simulation/large/dialogs/manage_partnerships/manage_partnerships_dialog.dart';
import 'package:sj_manager/utils/show_dialog.dart';

class ManagePartnershipsCommand {
  ManagePartnershipsCommand({
    required this.context,
    required this.database,
  });

  final BuildContext context;
  final SimulationDatabase database;

  Future<void> execute() async {
    final chargeJumpers = database.managerData.personalCoachTeam!.jumpers;

    await showSjmDialog(
      barrierDismissible: true,
      context: context,
      child: BlocProvider.value(
        value: context.read<SimulationDatabaseCubit>(),
        child: MultiProvider(
          providers: [
            Provider.value(value: context.read<CountryFlagsRepo>()),
            Provider.value(value: context.read<DbItemImageGeneratingSetup<Jumper>>()),
          ],
          child: ManagePartnershipsDialog(
            jumpers: chargeJumpers,
            onSubmit: (result) {
              final oldUserTeam = database.managerData.personalCoachTeam!;
              final changedPersonalCoachJumpers = result.newOrder;
              final newUserTeam = PersonalCoachTeam(jumpers: changedPersonalCoachJumpers);
              final id = database.idsRepo.removeByItem(item: oldUserTeam);
              database.idsRepo.register(newUserTeam, id: id);
              final changedManagerData = database.managerData.copyWith(
                personalCoachTeam: newUserTeam,
              );
              final changedTeamReports = Map.of(database.teamReports);
              changedTeamReports[newUserTeam] = changedTeamReports.remove(oldUserTeam)!;
              final changedDatabase = database.copyWith(
                managerData: changedManagerData,
                teamReports: changedTeamReports,
              );
              context.read<SimulationDatabaseCubit>().update(changedDatabase);
            },
          ),
        ),
      ),
    );
  }
}
