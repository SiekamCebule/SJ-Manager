import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/to_embrace/domain/use_cases/simulation_database_use_cases.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database_helper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/core/country_flags/country_flags_repository.dart';
import 'package:sj_manager/general_ui/reusable_widgets/database_item_images/db_item_image_generating_setup.dart';
import 'package:sj_manager/to_embrace/ui/screens/simulation/large/dialogs/manage_partnerships/manage_partnerships_dialog.dart';
import 'package:sj_manager/core/general_utils/dialogs.dart';

class ManagePartnershipsCommand {
  ManagePartnershipsCommand({
    required this.context,
    required this.database,
  });

  final BuildContext context;
  final SimulationDatabase database;

  Future<void> execute() async {
    final helper = context.read<SimulationDatabaseHelper>();
    final chargeJumpers = helper.managerJumpers;

    await showSjmDialog(
      barrierDismissible: true,
      context: context,
      child: MultiProvider(
        providers: [
          Provider.value(value: helper),
          Provider.value(value: context.read<CountryFlagsRepository>()),
          Provider.value(
              value: context.read<DbItemImageGeneratingSetup<SimulationJumper>>()),
          ChangeNotifierProvider.value(
            value: context.read<SimulationDatabase>(),
          ),
        ],
        child: ManagePartnershipsDialog(
          jumpers: chargeJumpers,
          onSubmit: (result) {
            SimulationDatabaseUseCases(database: database)
                .setPartnerships(partnerships: result.newOrder);
            database.notify();
          },
        ),
      ),
    );
  }
}
