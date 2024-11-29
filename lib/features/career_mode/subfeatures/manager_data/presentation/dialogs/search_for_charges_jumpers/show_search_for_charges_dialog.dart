import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/features/career_mode/subfeatures/jumpers/presentation/bloc/simulation_jumpers_cubit.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/core/country_flags/country_flags_repository.dart';
import 'package:sj_manager/general_ui/reusable_widgets/database_item_images/db_item_image_generating_setup.dart';
import 'package:sj_manager/features/career_mode/subfeatures/manager_data/presentation/dialogs/search_for_charges_jumpers/search_for_charges_jumpers_dialog.dart';
import 'package:sj_manager/core/general_utils/dialogs.dart';

Future<SimulationJumper?> showSearchForChargesDialog({
  required BuildContext context,
}) async {
  final jumpersState =
      context.read<SimulationJumpersCubit>().state as SimulationJumpersDefault;
  return await showSjmDialog(
    barrierDismissible: true,
    context: context,
    child: MultiProvider(
      providers: [
        Provider.value(value: context.read<CountryFlagsRepository>()),
        Provider.value(
            value: context.read<DbItemImageGeneratingSetup<SimulationJumper>>()),
      ],
      child: SearchForChargesJumpersDialog(
        jumpers: jumpersState.jumpers,
      ),
    ),
  );
}
