import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/commands/simulation_database/simulation_database_commander.dart';
import 'package:sj_manager/models/simulation/database/helper/simulation_database_helper.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/database/jumper/jumper_db_record.dart';
import 'package:sj_manager/repositories/countries/country_flags/country_flags_repo.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/db_item_image_generating_setup.dart';
import 'package:sj_manager/ui/screens/simulation/large/dialogs/set_up_trainings/set_up_trainings_dialog.dart';
import 'package:sj_manager/utils/show_dialog.dart';

class SetUpTrainingsCommand {
  SetUpTrainingsCommand({
    required this.context,
    required this.database,
    required this.onFinish,
  });

  final BuildContext context;
  final SimulationDatabase database;
  final Function(SetUpTrainingsDialogResult result) onFinish;

  Future<void> execute() async {
    final dbHelper = context.read<SimulationDatabaseHelper>();
    var database = this.database;

    await showSjmDialog(
      barrierDismissible: false,
      context: context,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: MultiProvider(
          providers: [
            Provider.value(value: context.read<CountryFlagsRepo>()),
            Provider.value(
                value: context.read<DbItemImageGeneratingSetup<JumperDbRecord>>()),
            ChangeNotifierProvider.value(value: database),
          ],
          child: SetUpTrainingsDialog(
            simulationMode: database.managerData.mode,
            jumpers: dbHelper.managerJumpers,
            jumpersSimulationRatings: database.jumperReports,
            onSubmit: (result) {
              SimulationDatabaseCommander(database: database).setUpTrainings();
              onFinish(result);
            },
          ),
        ),
      ),
    );
  }
}
