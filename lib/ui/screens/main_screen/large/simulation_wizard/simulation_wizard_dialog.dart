import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/bloc/simulation_wizard/simulation_wizard_screen.dart';
import 'package:sj_manager/bloc/simulation_wizard/simulation_wizard_navigation_cubit.dart';
import 'package:sj_manager/bloc/simulation_wizard/state/simulation_wizard_navigation_state.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/items_repos_registry.dart';
import 'package:sj_manager/models/user_db/sex.dart';
import 'package:sj_manager/models/user_db/team/country_team.dart';
import 'package:sj_manager/models/simulation_db/enums.dart';
import 'package:sj_manager/models/simulation_db/simulation_wizard_options_repo.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/country_flag.dart';
import 'package:sj_manager/ui/screens/main_screen/large/simulation_wizard/widgets/country_screen/country_title.dart';
import 'package:sj_manager/ui/screens/main_screen/large/simulation_wizard/widgets/country_screen/preview_stat_texts.dart';
import 'package:sj_manager/ui/screens/main_screen/large/simulation_wizard/widgets/country_screen/stars.dart';
import 'package:sj_manager/ui/screens/main_screen/large/widgets/generic/main_menu_card.dart';
import 'package:sj_manager/ui/screens/main_screen/large/simulation_wizard/widgets/simulation_wizard_option_button.dart';
import 'package:sj_manager/ui/screens/main_screen/large/widgets/generic/main_menu_text_content_button_body.dart';
import 'package:sj_manager/utils/file_dialogs.dart';
import 'package:sj_manager/utils/team_preview_creator/default_team_preview_creator.dart';
import 'package:sj_manager/utils/team_preview_creator/team_preview_creator.dart';

part 'screens/__mode_screen.dart';
part 'screens/__team_screen.dart';
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

  @override
  void initState() {
    _navCubit = SimulationWizardNavigationCubit(screens: [
      SimulationWizardScreen.mode,
      SimulationWizardScreen.team,
      SimulationWizardScreen.eventsSeries
    ]);

    super.initState();
  }

  @override
  void dispose() {
    _navCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: _navCubit.stream,
        builder: (context, snapshot) {
          return MultiProvider(
            providers: [
              Provider(create: (context) => SimulationWizardOptionsRepo()),
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
