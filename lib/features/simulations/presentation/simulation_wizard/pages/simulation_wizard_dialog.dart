import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/features/game_variants/domain/entities/game_variant.dart';
import 'package:sj_manager/features/game_variants/presentation/bloc/game_variant_cubit.dart';
import 'package:sj_manager/core/simulation_wizard/simulation_wizard_screen_type.dart';
import 'package:sj_manager/features/simulations/presentation/bloc/simulation_wizard/simulation_wizard_navigation_cubit.dart';
import 'package:sj_manager/features/simulations/presentation/bloc/simulation_wizard/simulation_wizard_navigation_state.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/core/core_classes/game_variant_start_date.dart';
import 'package:sj_manager/core/general_utils/game_variants_io_utils.dart';
import 'package:sj_manager/core/core_classes/country/country.dart';
import 'package:sj_manager/core/core_classes/sex.dart';
import 'package:sj_manager/core/core_classes/country_team/country_team.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_mode.dart';
import 'package:sj_manager/features/simulations/presentation/simulation_wizard/simulation_wizard_options_repo.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam_type.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/team.dart';
import 'package:sj_manager/core/country_flags/country_flags_repository.dart';
import 'package:sj_manager/core/country_flags/local_storage_country_flags_repo.dart';
import 'package:sj_manager/to_embrace/ui/database_item_editors/fields/my_checkbox_list_tile_field.dart';
import 'package:sj_manager/general_ui/dialogs/simple_help_dialog.dart';
import 'package:sj_manager/features/simulations/presentation/simulation_wizard/dialogs/simulation_name_dialog.dart';
import 'package:sj_manager/general_ui/reusable_widgets/countries/country_flag.dart';
import 'package:sj_manager/general_ui/reusable_widgets/help_icon_button.dart';
import 'package:sj_manager/features/simulations/presentation/simulation_wizard/widgets/country_screen/country_title.dart';
import 'package:sj_manager/features/simulations/presentation/simulation_wizard/widgets/country_screen/preview_stat_texts.dart';
import 'package:sj_manager/features/simulations/presentation/simulation_wizard/widgets/country_screen/stars.dart';
import 'package:sj_manager/features/simulations/presentation/simulation_wizard/widgets/simulation_wizard_mode_option_button.dart';
import 'package:sj_manager/main_menu/ui/large/widgets/generic/main_menu_card.dart';
import 'package:sj_manager/features/simulations/presentation/simulation_wizard/widgets/simulation_wizard_option_button.dart';
import 'package:sj_manager/core/general_utils/id_generator.dart';
import 'package:sj_manager/core/general_utils/dialogs.dart';
import 'package:sj_manager/core/career_mode/career_mode_utils/team_preview_creator/default_team_preview_creator.dart';
import 'package:sj_manager/core/career_mode/career_mode_utils/team_preview_creator/team_preview_creator.dart';
import 'package:path/path.dart' as path;

part '__mode_screen.dart';
part '__team_screen.dart';
part '__game_variant_screen.dart';
part '__start_date_screen.dart';
part '__subteam_screen.dart';
part '__other_options.dart';
part '../widgets/__dynamic_content.dart';
part '../widgets/__header.dart';
part '../widgets/__footer.dart';
part '../widgets/country_screen/__country_tile.dart';
part '../widgets/country_screen/__team_preview.dart';
part '../widgets/country_screen/__country_teams_grid.dart';

class SimulationWizardDialog extends StatefulWidget {
  const SimulationWizardDialog({super.key});

  @override
  State<SimulationWizardDialog> createState() => _SimulationWizardDialogState();
}

class _SimulationWizardDialogState extends State<SimulationWizardDialog>
    with SingleTickerProviderStateMixin {
  late final SimulationWizardNavigationCubit _navCubit;
  late final SimulationWizardOptions _optionsRepo;

  @override
  void initState() {
    _navCubit = SimulationWizardNavigationCubit(
      onFinish: () async {
        final simulationId = context.read<IdGenerator>().generate();
        final simulationName = await showSjmDialog(
          context: context,
          barrierDismissible: false,
          child: const SimulationNameDialog(),
        ) as String;

        _optionsRepo.simulationId = simulationId;
        _optionsRepo.simulationName = simulationName;

        if (!mounted) return;
        router.pop(context, _optionsRepo);
      },
    );
    _optionsRepo = SimulationWizardOptions();

    super.initState();
  }

  @override
  void dispose() {
    _navCubit.close();
    _optionsRepo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: _navCubit.stream,
        builder: (context, snapshot) {
          return MultiProvider(
            providers: [
              Provider.value(value: _optionsRepo),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: _navCubit),
              ],
              child: const Column(
                children: [
                  _Header(),
                  Expanded(
                    child: _DynamicContent(),
                  ),
                  _Footer(),
                ],
              ),
            ),
          );
        });
  }
}
