import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/features/career_mode/presentation/bloc/to_consider/jumpers_cubit.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/core/country_flags/country_flags_repository.dart';
import 'package:sj_manager/general_ui/reusable_widgets/database_item_images/db_item_image_generating_setup.dart';
import 'package:sj_manager/features/career_mode/presentation/dialogs/manage_partnerships/manage_partnerships_dialog.dart';
import 'package:sj_manager/core/general_utils/dialogs.dart';

Future<ManagePartnershipsDialogResult> showManagePartnershipsDialog({
  required BuildContext context,
}) async {
  final jumpersState = context.read<JumpersCubit>().state as JumpersDefault;
  return await showSjmDialog(
    barrierDismissible: true,
    context: context,
    child: MultiProvider(
      providers: [
        Provider.value(value: context.read<CountryFlagsRepository>()),
        Provider.value(
            value: context.read<DbItemImageGeneratingSetup<SimulationJumper>>()),
        ChangeNotifierProvider.value(
          value: context.read<SimulationDatabase>(),
        ),
      ],
      child: ManagePartnershipsDialog(jumpers: jumpersState.jumpers),
    ),
  );
}
