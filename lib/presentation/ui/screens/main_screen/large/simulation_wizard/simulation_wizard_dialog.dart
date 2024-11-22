import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/presentation/bloc/simulation_wizard/simulation_wizard_screen_type.dart';
import 'package:sj_manager/presentation/bloc/simulation_wizard/simulation_wizard_navigation_cubit.dart';
import 'package:sj_manager/presentation/bloc/simulation_wizard/state/simulation_wizard_navigation_state.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/data/models/game_variant/game_variant.dart';
import 'package:sj_manager/data/models/game_variant/game_variant_start_date.dart';
import 'package:sj_manager/data/models/game_variant/game_variants_io_utils.dart';
import 'package:sj_manager/core/classes/country/country.dart';
import 'package:sj_manager/features/game_variants/data/models/game_variant_database.dart/sex.dart';
import 'package:sj_manager/core/classes/country_team/country_team.dart';
import 'package:sj_manager/domain/entities/simulation/flow/simulation_mode.dart';
import 'package:sj_manager/domain/entities/simulation/database/simulation_wizard_options_repo.dart';
import 'package:sj_manager/domain/entities/simulation/team/subteam_type.dart';
import 'package:sj_manager/domain/entities/simulation/team/team.dart';
import 'package:sj_manager/domain/repository_interfaces/countries/country_flags/country_flags_repo.dart';
import 'package:sj_manager/domain/repository_interfaces/countries/country_flags/local_storage_country_flags_repo.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_repo.dart';
import 'package:sj_manager/presentation/ui/database_item_editors/fields/my_checkbox_list_tile_field.dart';
import 'package:sj_manager/presentation/ui/dialogs/simple_help_dialog.dart';
import 'package:sj_manager/presentation/ui/dialogs/simulation_wizard/simulation_name_dialog.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/countries/country_flag.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/help_icon_button.dart';
import 'package:sj_manager/presentation/ui/screens/main_screen/large/simulation_wizard/widgets/country_screen/country_title.dart';
import 'package:sj_manager/presentation/ui/screens/main_screen/large/simulation_wizard/widgets/country_screen/preview_stat_texts.dart';
import 'package:sj_manager/presentation/ui/screens/main_screen/large/simulation_wizard/widgets/country_screen/stars.dart';
import 'package:sj_manager/presentation/ui/screens/main_screen/large/simulation_wizard/widgets/simulation_wizard_mode_option_button.dart';
import 'package:sj_manager/presentation/ui/screens/main_screen/large/widgets/generic/main_menu_card.dart';
import 'package:sj_manager/presentation/ui/screens/main_screen/large/simulation_wizard/widgets/simulation_wizard_option_button.dart';
import 'package:sj_manager/utilities/utils/id_generator.dart';
import 'package:sj_manager/utilities/utils/show_dialog.dart';
import 'package:sj_manager/utilities/utils/team_preview_creator/default_team_preview_creator.dart';
import 'package:sj_manager/utilities/utils/team_preview_creator/team_preview_creator.dart';
import 'package:path/path.dart' as path;

part 'screens/__mode_screen.dart';
part 'screens/__team_screen.dart';
part 'screens/__game_variant_screen.dart';
part 'screens/__start_date_screen.dart';
part 'screens/__subteam_screen.dart';
part 'screens/__other_options.dart';
part 'widgets/__dynamic_content.dart';
part 'widgets/__header.dart';
part 'widgets/__footer.dart';
part 'widgets/country_screen/__country_tile.dart';
part 'widgets/country_screen/__team_preview.dart';
part 'widgets/country_screen/__country_teams_grid.dart';

class SimulationWizardDialog extends StatefulWidget {
  const SimulationWizardDialog({super.key});

  @override
  State<SimulationWizardDialog> createState() => _SimulationWizardDialogState();
}

class _SimulationWizardDialogState extends State<SimulationWizardDialog>
    with SingleTickerProviderStateMixin {
  late final SimulationWizardNavigationCubit _navCubit;
  late final SimulationWizardOptionsRepo _optionsRepo;

  @override
  void initState() {
    _navCubit = SimulationWizardNavigationCubit(
      onFinish: () async {
        final simulationId = context.read<IdGenerator>().generate();
        if (simulationId == false) {
          throw StateError('ID generator should generate strings');
        }
        final simulationName = await showSjmDialog(
          context: context,
          barrierDismissible: false,
          child: const SimulationNameDialog(),
        ) as String;

        _optionsRepo.simulationId.set(simulationId);
        _optionsRepo.simulationName.set(simulationName);

        if (!mounted) return;
        router.pop(context, _optionsRepo);
      },
    );
    _optionsRepo = SimulationWizardOptionsRepo();

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
