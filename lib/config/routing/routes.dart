import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/features/database_editor/presentation/pages/database_editor_page.dart';
import 'package:sj_manager/features/game_variants/presentation/bloc/game_variant_cubit.dart';
import 'package:sj_manager/features/simulations/presentation/bloc/simulation_cubit.dart';
import 'package:sj_manager/features/career_mode/simulation_screen_navigation_cubit.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/core/general_utils/game_variants_io_utils.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/core/core_classes/hill/hill.dart';
import 'package:sj_manager/core/country_flags/country_flags_repository.dart';
import 'package:sj_manager/core/country_flags/local_storage_country_flags_repo.dart';
import 'package:sj_manager/general_ui/reusable_widgets/database_item_images/db_item_image_generating_setup.dart';
import 'package:sj_manager/features/career_mode/ui/pages/main_page/simulation_route.dart';
import 'package:sj_manager/main_menu/ui/main_screen.dart';
import 'package:sj_manager/features/app_settings/presentation/pages/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/features/training_analyzer/ui/training_analyzer_screen.dart';
import 'package:sj_manager/core/general_utils/db_item_images.dart';
import 'package:sj_manager/core/general_utils/file_system.dart';
import 'package:path/path.dart' as path;

void configureRoutes(FluroRouter router) {
  void define(
    String routePath,
    Widget? Function(BuildContext?, Map<String, List<String>>) handlerFunc, {
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transitionBuilder,
    TransitionType? transitionType,
    Curve? inCurve,
    Curve? outCurve,
  }) {
    router.define(
      routePath,
      handler: Handler(handlerFunc: handlerFunc),
      transitionDuration: Durations.long3,
      transitionType: transitionBuilder != null ? TransitionType.custom : transitionType,
      transitionBuilder: transitionBuilder ??
          (context, animation, secondaryAnimation, child) {
            final slideIn =
                CurvedAnimation(parent: animation, curve: inCurve ?? Curves.easeInOutSine)
                    .drive(
              Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ),
            );
            final slideOut = CurvedAnimation(
                    parent: secondaryAnimation, curve: outCurve ?? Curves.easeOutBack)
                .drive(
              Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(0, 1),
              ),
            );
            return SlideTransition(
              position: slideOut,
              child: SlideTransition(
                position: slideIn,
                child: child,
              ),
            );
          },
    );
  }

  Widget defaultInFromLeft(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final slideIn = CurvedAnimation(parent: animation, curve: Curves.easeInOutSine).drive(
      Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero),
    );
    final slideOut =
        CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeOutBack).drive(
      Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1)),
    );
    return SlideTransition(
      position: slideOut,
      child: SlideTransition(position: slideIn, child: child),
    );
  }

  define(
    '/',
    (context, params) => const MainScreen(),
  );
  define(
    '/settings',
    (context, params) => const SettingsScreen(),
    transitionBuilder: defaultInFromLeft,
  );
  define(
    '/settings/trainingAnalyzer',
    (context, params) {
      return const TrainingAnalyzerScreen();
    },
    //transitionBuilder: defaultInFromLeft,
    transitionType: TransitionType.material,
  );
  define(
    '/databaseEditor/:gameVariantId',
    (context, params) {
      final gameVariantId = params['gameVariantId']![0];
      final gameVariantState =
          context!.read<GameVariantCubit>().state as GameVariantChosen;

      final imagesDir = userDataDirectory(context.read(),
          path.join('game_variants', gameVariantId, 'countries', 'country_flags'));
      final countryFlagsRepo = LocalStorageCountryFlagsRepo(
        imagesDirectory: imagesDir,
        imagesExtension: 'png',
      );
      return MultiProvider(
        providers: [
          Provider.value(value: gameVariantState.variant),
          Provider<CountryFlagsRepository>.value(value: countryFlagsRepo),
          Provider(
            create: (context) => DbItemImageGeneratingSetup<JumperDbRecord>(
              imagesDirectory: gameVariantDirectory(
                pathsCache: context.read(),
                gameVariantId: gameVariantId,
                directoryName: path.join('jumper_images'),
              ),
              toFileName: jumperDbRecordImageName,
            ),
          ),
        ],
        child: const DatabaseEditorPage(),
      );
    },
    transitionBuilder: defaultInFromLeft,
  );
  define('/simulation', (context, params) {
    final simulationState = context!.read<SimulationCubit>().state as SimulationChosen;
    final imagesDir = userDataDirectory(
        context.read(),
        path.join(
            'simulations', simulationState.simulation.id, 'countries', 'country_flags'));

    print('routes, initial jumpers: ${simulationState.database.jumpers}');

    return MultiProvider(
      providers: [
        Provider.value(value: simulationState.simulation),
        Provider(create: (context) => simulationState.database.countries),
        Provider<CountryFlagsRepository>(
          create: (context) => LocalStorageCountryFlagsRepo(
            imagesDirectory: imagesDir,
            imagesExtension: 'png',
          ),
        ),
        Provider(
          create: (context) => DbItemImageGeneratingSetup<SimulationJumper>(
            imagesDirectory: simulationDirectory(
              pathsCache: context.read(),
              simulationId: simulationState.simulation.id,
              directoryName: path.join('jumper_images'),
            ),
            toFileName: simulationJumperImageName,
          ),
        ),
        Provider(
          create: (context) => DbItemImageGeneratingSetup<Hill>(
            imagesDirectory: simulationDirectory(
              pathsCache: context.read(),
              simulationId: simulationState.simulation.id,
              directoryName: path.join('hill_images'),
            ),
            toFileName: hillImageName,
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SimulationScreenNavigationCubit(),
          ),
        ],
        child: Builder(
          builder: (context) {
            return PopScope(
              onPopInvokedWithResult: (didPop, result) async {
                await context.read<SimulationCubit>().preserve();
              },
              child: const SimulationRoute(),
            );
          },
        ),
      ),
    );
  });
}
