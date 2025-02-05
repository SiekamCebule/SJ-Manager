import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/features/career_mode/presentation/bloc/manager_cubit.dart';
import 'package:sj_manager/features/career_mode/presentation/bloc/to_consider/jumpers_cubit.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/core/country_flags/country_flags_repository.dart';
import 'package:sj_manager/general_ui/reusable_widgets/database_item_images/db_item_image_generating_setup.dart';
import 'package:sj_manager/core/general_utils/dialogs.dart';
import 'package:sj_manager/features/career_mode/presentation/dialogs/trainings/set_up_trainings/set_up_trainings_dialog.dart';

Future<SetUpTrainingsDialogResult> showSetUpTrainingsDialog({
  required BuildContext context,
}) async {
  final jumpersState = context.read<JumpersCubit>().state as JumpersDefault;
  final managerState = context.read<ManagerCubit>().state as ManagerDefault;
  return await showSjmDialog(
    barrierDismissible: false,
    context: context,
    child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: MultiProvider(
        providers: [
          Provider.value(value: context.read<CountryFlagsRepository>()),
          Provider.value(
              value: context.read<DbItemImageGeneratingSetup<SimulationJumper>>()),
        ],
        child: SetUpTrainingsDialog(
          jumpers: jumpersState.jumpers,
          simulationMode: managerState.mode,
        ),
      ),
    ),
  );
}
