import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/bloc/simulation/simulation_database_cubit.dart';
import 'package:sj_manager/bloc/simulation/simulation_screen_navigation_cubit.dart';
import 'package:sj_manager/models/game_variants/game_variant.dart';
import 'package:sj_manager/models/simulation/database/helper/jumper_level_description.dart';
import 'package:sj_manager/models/simulation/flow/simple_rating.dart';
import 'package:sj_manager/models/simulation/database/helper/simulation_database_helper.dart';
import 'package:sj_manager/models/simulation/flow/training/reports.dart';
import 'package:sj_manager/models/simulation/user_simulation/user_simulation.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/repositories/countries/country_flags/country_flags_repo.dart';
import 'package:sj_manager/repositories/countries/country_flags/local_storage_country_flags_repo.dart';
import 'package:sj_manager/repositories/generic/editable_items_repo.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/db_item_image_generating_setup.dart';
import 'package:sj_manager/ui/screens/database_editor/database_editor_screen.dart';
import 'package:sj_manager/ui/screens/simulation/simulation_route.dart';
import 'package:sj_manager/ui/screens/main_screen/main_screen.dart';
import 'package:sj_manager/ui/screens/settings/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/utils/db_item_images.dart';
import 'package:sj_manager/utils/file_system.dart';
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
    '/databaseEditor/:gameVariantId',
    (context, params) {
      final gameVariantId = params['gameVariantId']![0];
      final gameVariant = context!
          .read<ItemsRepo<GameVariant>>()
          .last
          .singleWhere((variant) => variant.id == gameVariantId);
      final imagesDir = userDataDirectory(context.read(),
          path.join('gameVariants', gameVariantId, 'countries', 'country_flags'));
      final countryFlagsRepo = LocalStorageCountryFlagsRepo(
        imagesDirectory: imagesDir,
        imagesExtension: 'png',
      );
      return MultiProvider(
        providers: [
          Provider.value(value: gameVariant),
          Provider<CountryFlagsRepo>.value(value: countryFlagsRepo),
        ],
        child: const DatabaseEditorScreen(),
      );
    },
    transitionBuilder: defaultInFromLeft,
  );
  define('/simulation/:simulationId', (context, params) {
    final simulationId = params['simulationId']![0];
    final simulation =
        context!.read<EditableItemsRepo<UserSimulation>>().last.singleWhere(
              (simulation) => simulation.id == simulationId,
            );
    final imagesDir = userDataDirectory(context.read(),
        path.join('simulations', simulationId, 'countries', 'country_flags'));

    Jumper getJumperBySurname(String surname) => simulation.database!.jumpers.last
        .singleWhere((jumper) => jumper.surname == surname);

    final simulationDatabaseHelper = SimulationDatabaseHelper(
      userSubteam: null,
      managerPoints: 40,
      jumpersSimulationRatings: {
        getJumperBySurname('Forfang'): const JumperSimulationRatings(
          trainingProgressReport: JumperTrainingProgressReport(
            generalRating: SimpleRating.good,
            ratings: {
              JumperTrainingProgressCategory.takeoff: SimpleRating.good,
              JumperTrainingProgressCategory.flight: SimpleRating.good,
              JumperTrainingProgressCategory.landing: SimpleRating.good,
              JumperTrainingProgressCategory.jumpsConsistency: SimpleRating.poor,
              JumperTrainingProgressCategory.form: SimpleRating.veryGood,
            },
          ),
          levelReport: JumperLevelReport(
            levelDescription: JumperLevelDescription.top,
            characteristics: {
              JumperLevelCharacteristicCategory.takeoff: SimpleRating.belowExpectations,
              JumperLevelCharacteristicCategory.flight: SimpleRating.veryGood,
              JumperLevelCharacteristicCategory.landing: SimpleRating.correct,
              JumperLevelCharacteristicCategory.jumpsConsistency: SimpleRating.correct,
            },
          ),
          moraleRating: SimpleRating.correct,
          resultsRating: SimpleRating.correct,
        ),
        getJumperBySurname('Żyła'): const JumperSimulationRatings(
          trainingProgressReport: JumperTrainingProgressReport(
            generalRating: SimpleRating.correct,
            ratings: {
              JumperTrainingProgressCategory.takeoff: SimpleRating.correct,
              JumperTrainingProgressCategory.flight: SimpleRating.correct,
              JumperTrainingProgressCategory.landing: SimpleRating.veryPoor,
              JumperTrainingProgressCategory.jumpsConsistency: SimpleRating.veryGood,
              JumperTrainingProgressCategory.form: SimpleRating.veryGood,
            },
          ),
          levelReport: JumperLevelReport(
            levelDescription: JumperLevelDescription.broadTop,
            characteristics: {
              JumperLevelCharacteristicCategory.takeoff: SimpleRating.good,
              JumperLevelCharacteristicCategory.flight: SimpleRating.good,
              JumperLevelCharacteristicCategory.landing: SimpleRating.belowExpectations,
              JumperLevelCharacteristicCategory.jumpsConsistency: SimpleRating.correct,
            },
          ),
          moraleRating: SimpleRating.good,
          resultsRating: SimpleRating.belowExpectations,
        ),
        getJumperBySurname('Wolny'): const JumperSimulationRatings(
          trainingProgressReport: JumperTrainingProgressReport(
            generalRating: SimpleRating.poor,
            ratings: {
              JumperTrainingProgressCategory.takeoff: SimpleRating.good,
              JumperTrainingProgressCategory.flight: SimpleRating.veryGood,
              JumperTrainingProgressCategory.landing: SimpleRating.belowExpectations,
              JumperTrainingProgressCategory.jumpsConsistency: SimpleRating.veryPoor,
              JumperTrainingProgressCategory.form: SimpleRating.poor,
            },
          ),
          levelReport: JumperLevelReport(
            levelDescription: JumperLevelDescription.international,
            characteristics: {
              JumperLevelCharacteristicCategory.takeoff: SimpleRating.poor,
              JumperLevelCharacteristicCategory.flight: SimpleRating.veryGood,
              JumperLevelCharacteristicCategory.landing: SimpleRating.veryPoor,
              JumperLevelCharacteristicCategory.jumpsConsistency: SimpleRating.correct,
            },
          ),
          moraleRating: SimpleRating.veryGood,
          resultsRating: SimpleRating.good,
        ),
      },
    );
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
          create: (context) => DbItemImageGeneratingSetup<Jumper>(
            imagesDirectory: simulationDirectory(
              pathsCache: context.read(),
              simulationId: simulationId,
              directoryName: path.join('jumper_images'),
            ),
            toFileName: jumperImageName,
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
        Provider.value(value: simulationDatabaseHelper),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SimulationScreenNavigationCubit(),
          ),
          BlocProvider(
            create: (context) => SimulationDatabaseCubit(initial: simulation.database!),
          ),
        ],
        child: const SimulationRoute(),
      ),
    );
  });
}
