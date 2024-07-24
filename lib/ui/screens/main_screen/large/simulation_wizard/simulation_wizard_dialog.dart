import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/bloc/simulation_wizard/linear_navigation_permissions_repo.dart';
import 'package:sj_manager/bloc/simulation_wizard/simulation_wizard_screen.dart';
import 'package:sj_manager/bloc/simulation_wizard/simulation_wizard_navigation_cubit.dart';
import 'package:sj_manager/bloc/simulation_wizard/simulation_wizard_navigation_state.dart';
import 'package:sj_manager/models/db/country/country.dart';
import 'package:sj_manager/models/db/local_db_repo.dart';
import 'package:sj_manager/models/db/sex.dart';
import 'package:sj_manager/models/simulations/enums.dart';
import 'package:sj_manager/models/simulations/simulation_wizard_options_repo.dart';
import 'package:sj_manager/models/simulations/team.dart';
import 'package:sj_manager/repositories/generic/db_items_repo.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/country_flag.dart';
import 'package:sj_manager/ui/screens/main_screen/large/simulation_wizard/widgets/country_screen/country_title.dart';
import 'package:sj_manager/ui/screens/main_screen/large/simulation_wizard/widgets/country_screen/stars.dart';
import 'package:sj_manager/ui/screens/main_screen/large/simulation_wizard/widgets/country_screen/preview_stat_texts.dart';
import 'package:sj_manager/ui/screens/main_screen/large/widgets/generic/main_menu_card.dart';
import 'package:sj_manager/ui/screens/main_screen/large/simulation_wizard/widgets/simulation_wizard_option_button.dart';
import 'package:sj_manager/ui/screens/main_screen/large/widgets/generic/main_menu_text_content_button_body.dart';
import 'package:sj_manager/utils/country_preview_creator.dart';
import 'package:sj_manager/utils/db_items.dart';

part 'screens/__mode_screen.dart';
part 'screens/__team_screen.dart';
part 'widgets/__dynamic_content.dart';
part 'widgets/__header.dart';
part 'widgets/__footer.dart';
part 'widgets/country_screen/__country_tile.dart';

class SimulationWizardDialog extends StatefulWidget {
  const SimulationWizardDialog({super.key});

  @override
  State<SimulationWizardDialog> createState() => _SimulationWizardDialogState();
}

class _SimulationWizardDialogState extends State<SimulationWizardDialog>
    with SingleTickerProviderStateMixin {
  late final SimulationWizardNavigationCubit _navCubit;
  late final StreamSubscription _navStateSubscription;
  late final LinearNavigationPermissionsRepo _navPermissions;

  @override
  void initState() {
    _navPermissions = LinearNavigationPermissionsRepo();
    _navCubit = SimulationWizardNavigationCubit(navPermissions: _navPermissions);
    _navStateSubscription = _navCubit.stream.listen((state) {
      if (state is InitializedSimulationWizardNavigationState) {
        _navPermissions.canGoForward = state.indexAllowsGoingForward;
        _navPermissions.canGoBack = state.indexAllowsGoingBack;
      } else {
        _navPermissions.entirelyBlock();
      }
    });
    scheduleMicrotask(() {
      _navCubit.setUp(screens: [
        SimulationWizardScreen.mode,
        SimulationWizardScreen.country,
        SimulationWizardScreen.mode
      ]);
    });

    super.initState();
  }

  @override
  void dispose() {
    _navCubit.close();
    _navStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: _navCubit.stream,
        builder: (context, snapshot) {
          final state = _navCubit.state;
          if (state is InitializedSimulationWizardNavigationState) {
            return MultiProvider(
              providers: [
                Provider(create: (context) => SimulationWizardOptionsRepo()),
                Provider.value(value: _navPermissions),
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
          } else if (state is UninitializedSimulationWizardNavigationState) {
            return const Center(
              child: SizedBox.square(
                dimension: 100,
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            throw StateError('Invalid simulation wizard screen state');
          }
        });
  }
}
