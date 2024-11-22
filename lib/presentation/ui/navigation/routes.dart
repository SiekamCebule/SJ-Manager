import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/domain/use_cases/ui/simulation/simulation_screen_navigation_cubit.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/data/models/game_variant/game_variant.dart';
import 'package:sj_manager/data/models/game_variant/game_variants_io_utils.dart';
import 'package:sj_manager/domain/entities/simulation/database/helper/simulation_database_helper.dart';
import 'package:sj_manager/domain/entities/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/domain/entities/simulation/jumper/simulation_jumper.dart';
import 'package:sj_manager/data/models/user_simulation/simulation_model.dart';
import 'package:sj_manager/domain/entities/game_variant/hill/hill.dart';
import 'package:sj_manager/domain/repository_interfaces/countries/country_flags/country_flags_repo.dart';
import 'package:sj_manager/domain/repository_interfaces/countries/country_flags/local_storage_country_flags_repo.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/editable_items_repo.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_repo.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/database_item_images/db_item_image_generating_setup.dart';
import 'package:sj_manager/presentation/ui/screens/database_editor/database_editor_screen.dart';
import 'package:sj_manager/presentation/ui/screens/simulation/simulation_route.dart';
import 'package:sj_manager/presentation/ui/screens/main_screen/main_screen.dart';
import 'package:sj_manager/presentation/ui/screens/settings/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/presentation/ui/screens/training_analyzer/training_analyzer_screen.dart';
import 'package:sj_manager/utilities/utils/db_item_images.dart';
import 'package:sj_manager/utilities/utils/file_system.dart';
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
      final gameVariant = context!
          .read<ItemsRepo<GameVariant>>()
          .last
          .singleWhere((variant) => variant.id == gameVariantId);
      final imagesDir = userDataDirectory(context.read(),
          path.join('game_variants', gameVariantId, 'countries', 'country_flags'));
      final countryFlagsRepo = LocalStorageCountryFlagsRepo(
        imagesDirectory: imagesDir,
        imagesExtension: 'png',
      );
      return MultiProvider(
        providers: [
          Provider.value(value: gameVariant),
          Provider<CountryFlagsRepo>.value(value: countryFlagsRepo),
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
        child: const DatabaseEditorScreen(),
      );
    },
    transitionBuilder: defaultInFromLeft,
  );
  define('/simulation/:simulationId', (context, params) {
    final simulationId = params['simulationId']![0];
    final simulationsRepo = context!.read<EditableItemsRepo<SimulationModel>>();
    final simulation = simulationsRepo.last.singleWhere(
      (simulation) => simulation.id == simulationId,
    );
    final simulationIndexInRepo = simulationsRepo.last.indexOf(simulation);
    final imagesDir = userDataDirectory(context.read(),
        path.join('simulations', simulationId, 'countries', 'country_flags'));
    final simulationDatabase = simulation.database!.copyWith();

    print('routes, initial jumpers: ${simulation.database!.jumpers}');

    return MultiProvider(
      providers: [
        Provider.value(value: simulation),
        Provider(create: (context) => simulation.database!.countries),
        Provider<CountryFlagsRepo>(
          create: (context) => LocalStorageCountryFlagsRepo(
            imagesDirectory: imagesDir,
            imagesExtension: 'png',
          ),
        ),
        Provider(
          create: (context) => DbItemImageGeneratingSetup<SimulationJumper>(
            imagesDirectory: simulationDirectory(
              pathsCache: context.read(),
              simulationId: simulationId,
              directoryName: path.join('jumper_images'),
            ),
            toFileName: simulationJumperImageName,
          ),
        ),
        Provider(
          create: (context) => DbItemImageGeneratingSetup<Hill>(
            imagesDirectory: simulationDirectory(
              pathsCache: context.read(),
              simulationId: simulationId,
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
        child: MultiProvider(
          providers: [
            Provider(
              create: (context) => SimulationDatabaseHelper(database: simulationDatabase),
            ),
            ChangeNotifierProvider(create: (context) => simulationDatabase),
          ],
          child: Builder(builder: (context) {
            return PopScope(
              onPopInvokedWithResult: (didPop, result) {
                final database = context.read<SimulationDatabase>();
                context.read<EditableItemsRepo<SimulationModel>>().replace(
                      oldIndex: simulationIndexInRepo,
                      newItem: simulation.copyWith(database: database),
                    );
              },
              child: const SimulationRoute(),
            );
          }),
        ),
      ),
    );
  });
}
