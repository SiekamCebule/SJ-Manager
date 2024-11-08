import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/bloc/simulation/simulation_database_cubit.dart';
import 'package:sj_manager/commands/simulation_database/simulation_database_commander.dart';
import 'package:sj_manager/models/simulation/database/helper/simulation_database_helper.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
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

  Future<SimulationDatabase> execute() async {
    final dbHelper = context.read<SimulationDatabaseHelper>();
    var database = this.database;

    await showSjmDialog(
      barrierDismissible: false,
      context: context,
      child: BlocProvider.value(
        value: context.read<SimulationDatabaseCubit>(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: MultiProvider(
            providers: [
              Provider.value(value: context.read<CountryFlagsRepo>()),
              Provider.value(value: context.read<DbItemImageGeneratingSetup<Jumper>>()),
            ],
            child: SetUpTrainingsDialog(
              simulationMode: database.managerData.mode,
              jumpers: dbHelper.managerJumpers,
              jumpersSimulationRatings: database.jumperReports,
              onSubmit: (result) {
                onFinish(result);
                database =
                    SimulationDatabaseCommander(database: database).setUpTrainings();
              },
            ),
          ),
        ),
      ),
    );

    return database;
  }
}
