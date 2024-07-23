import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/bloc/simulation_wizard/simulation_wizard_screen.dart';
import 'package:sj_manager/bloc/simulation_wizard/simulation_wizard_navigation_cubit.dart';
import 'package:sj_manager/bloc/simulation_wizard/simulation_wizard_navigation_state.dart';
import 'package:sj_manager/models/db/local_db_repo.dart';
import 'package:sj_manager/models/simulations/enums.dart';
import 'package:sj_manager/models/simulations/simulation_setup_config.dart';
import 'package:sj_manager/ui/screens/main_screen/large/widgets/generic/main_menu_card.dart';
import 'package:sj_manager/ui/screens/main_screen/large/widgets/generic/main_menu_text_content_button.dart';

part 'screens/__mode_screen.dart';
part 'screens/__country_screen.dart';
part 'widgets/__dynamic_content.dart';
part 'widgets/__header.dart';
part 'widgets/__footer.dart';

class SimulationWizardDialog extends StatefulWidget {
  const SimulationWizardDialog({super.key});

  @override
  State<SimulationWizardDialog> createState() => _SimulationWizardDialogState();
}

class _SimulationWizardDialogState extends State<SimulationWizardDialog>
    with SingleTickerProviderStateMixin {
  late final SimulationWizardNavigationCubit _currentScreenCubit;

  @override
  void initState() {
    _currentScreenCubit = SimulationWizardNavigationCubit();
    scheduleMicrotask(() {
      _currentScreenCubit.setUp(screens: [
        SimulationWizardScreen.mode,
        SimulationWizardScreen.country,
      ]);
    });

    super.initState();
  }

  @override
  void dispose() {
    _currentScreenCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: _currentScreenCubit.stream,
        builder: (context, snapshot) {
          final state = _currentScreenCubit.state;
          if (state is InitializedSimulationWizardNavigationState) {
            return Provider(
              create: (context) => SimulationSetupConfig(),
              child: BlocProvider.value(
                value: _currentScreenCubit,
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
