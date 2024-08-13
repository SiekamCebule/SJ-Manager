import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/bloc/database_editing/database_items_type_cubit.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules_preset.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/hill/hill_profile_type.dart';
import 'package:sj_manager/models/user_db/hill/jumps_variability.dart';
import 'package:sj_manager/models/user_db/hill/landing_ease.dart';
import 'package:sj_manager/models/user_db/hill/typical_wind_direction.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/jumper/jumper_skills.dart';
import 'package:sj_manager/models/user_db/items_repos_registry.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/countries/country_facts/teams_repo.dart';
import 'package:sj_manager/repositories/database_editing/db_editing_defaults_repo.dart';
import 'package:sj_manager/repositories/database_editing/default_items_repository.dart';
import 'package:sj_manager/repositories/generic/editable_items_repo.dart';
import 'package:sj_manager/repositories/database_editing/selected_indexes_repository.dart';
import 'package:sj_manager/setup/app_configurator.dart';
import 'package:sj_manager/ui/app.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_text_field.dart';
import 'package:sj_manager/ui/database_item_editors/hill_editor.dart';
import 'package:sj_manager/ui/providers/locale_notifier.dart';
import 'package:sj_manager/ui/reusable_widgets/animations/animated_visibility.dart';
import 'package:sj_manager/ui/screens/database_editor/database_editor_screen.dart';
import 'package:flutter/material.dart';
import 'package:sj_manager/ui/screens/database_editor/large/widgets/appropriate_db_item_list_tile.dart';
import 'package:sj_manager/ui/screens/database_editor/large/widgets/database_items_list.dart';
import 'package:sj_manager/ui/theme/app_color_scheme_repo.dart';
import 'package:sj_manager/ui/theme/app_theme_brightness_repo.dart';
import 'package:sj_manager/ui/theme/theme_cubit.dart';

import '../../local_database/bloc/database_editing_logic_test.mocks.dart';

@GenerateMocks([TeamsRepo])
void main() {
  const MethodChannel flutterWindowCloseChannel = MethodChannel('flutter_window_close');

  const slovenia = Country(code: 'si', name: 'Slovenia');
  const switzerland = Country(code: 'ch', name: 'Switzerland');
  const germany = Country(code: 'de', name: 'Germany');
  const noneCountry = Country(code: 'none', name: 'None');
  const countries = [noneCountry, slovenia, switzerland, germany];

  final maleJumpers = [
    MaleJumper(
      name: 'Adrian',
      surname: 'Nowak',
      country: slovenia,
      age: 24,
      skills: JumperSkills.empty
          .copyWith(qualityOnLargerHills: 67, qualityOnSmallerHills: 44),
    ),
    const MaleJumper(
      name: 'Maciej',
      surname: 'Bąk',
      country: switzerland,
      age: 34,
      skills: JumperSkills.empty,
    ),
    const MaleJumper(
      name: 'Caroll',
      surname: 'King',
      country: switzerland,
      age: 14,
      skills: JumperSkills.empty,
    ),
  ];
  final femaleJumpers = [
    FemaleJumper.empty(country: germany).copyWith(name: 'Angelica'),
    FemaleJumper.empty(country: germany).copyWith(name: 'Jasmina'),
    FemaleJumper.empty(country: switzerland).copyWith(name: 'Lisa'),
    FemaleJumper.empty(country: slovenia).copyWith(name: 'Nika'),
  ];
  const hills = [
    Hill(
      name: 'Letalnica',
      locality: 'Planica',
      country: slovenia,
      k: 200,
      hs: 240,
      landingEase: LandingEase.fairlyLow,
      profileType: HillProfileType.highlyFavorsInTakeoff,
      jumpsVariability: JumpsVariability.stable,
      pointsForGate: 8.64,
      pointsForHeadwind: 14.40,
      pointsForTailwind: 21.6,
      typicalWindDirection: TypicalWindDirection.leftHeadwind,
      typicalWindStrength: 2.80,
    ),
    Hill(
      name: 'Schattenbergschanze',
      locality: 'Oberstdorf',
      country: germany,
      k: 120,
      hs: 137,
      landingEase: LandingEase.average,
      profileType: HillProfileType.balanced,
      jumpsVariability: JumpsVariability.stable,
      pointsForGate: 7.56,
      pointsForHeadwind: 10.8,
      pointsForTailwind: 16.2,
    ),
    Hill(
      name: 'Kanzlersgrund',
      locality: 'Oberhof',
      country: germany,
      k: 120,
      hs: 140,
      landingEase: LandingEase.low,
      profileType: HillProfileType.favorsInFlight,
      jumpsVariability: JumpsVariability.variable,
      pointsForGate: 8.10,
      pointsForHeadwind: 10.8,
      pointsForTailwind: 16.2,
    ),
  ];

  group(DatabaseEditorScreen, () {
    late Widget appWidget;

    setUpAll(() {
      appWidget = BlocProvider(
        create: (context) => LocaleCubit(
          initial: const Locale('en'),
        ),
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider(
              create: (context) => ItemsReposRegistry(
                initial: {
                  EditableItemsRepo<MaleJumper>(initial: maleJumpers),
                  EditableItemsRepo<MaleJumper>(initial: maleJumpers),
                  EditableItemsRepo<FemaleJumper>(initial: femaleJumpers),
                  EditableItemsRepo<Hill>(initial: hills),
                  EditableItemsRepo<EventSeriesSetup>(initial: []),
                  EditableItemsRepo<EventSeriesCalendarPreset>(initial: []),
                  EditableItemsRepo<CompetitionRulesPreset>(initial: []),
                  CountriesRepo(initial: countries),
                  MockTeamsRepo(),
                },
              ),
            ),
            RepositoryProvider(create: (context) {
              final noneCountry =
                  (context.read<ItemsReposRegistry>().get<Country>() as CountriesRepo)
                      .none;
              return DefaultItemsRepo(
                initial: {
                  FemaleJumper.empty(country: noneCountry),
                  MaleJumper.empty(country: noneCountry),
                  Hill.empty(country: noneCountry),
                  const EventSeriesSetup.empty(),
                  const EventSeriesCalendarPreset.empty(),
                  const CompetitionRules.empty()
                },
              );
            }),
            RepositoryProvider(create: (context) {
              return DbEditingDefaultsRepo.appDefault();
            }),
            RepositoryProvider(
              create: (context) => AppThemeBrightnessRepo(),
            ),
            RepositoryProvider(
              create: (context) => AppColorSchemeRepo(),
            ),
          ],
          child: MultiProvider(
            providers: [
              Provider(
                create: (context) => AppConfigurator(
                  shouldSetUpRouting: true,
                  shouldSetUpUserData: false,
                  shouldLoadDatabase: false,
                  loaders: [],
                ),
              ),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) {
                  return ThemeCubit(
                    colorSchemeRepo: context.read(),
                    brightnessRepo: context.read(),
                  );
                }),
              ],
              child: const App(home: DatabaseEditorScreen()),
            ),
          ),
        ),
      );
    });

    testWidgets('Appropriate displaying', (tester) async {
      await tester.pumpWidget(appWidget);
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(DatabaseItemsList)) as BuildContext;

      final itemsTypeCubit = context.read<DatabaseItemsTypeCubit>();
      final itemsList = find.byType(DatabaseItemsList);
      expect(itemsTypeCubit.state, MaleJumper);
      expect(tester.widget<DatabaseItemsList>(itemsList).length, maleJumpers.length);

      expect(find.byType(FloatingActionButton), findsNWidgets(2));
      final addFabVisibility = find
          .ancestor(
              of: find.byKey(const Key('addFab')),
              matching: find.byType(AnimatedVisibility))
          .first;
      expect(tester.widget<AnimatedVisibility>(addFabVisibility).visible, true);
      final removeFabVisibility = find
          .ancestor(
              of: find.byKey(const Key('removeFab')),
              matching: find.byType(AnimatedVisibility))
          .first;
      expect(tester.widget<AnimatedVisibility>(removeFabVisibility).visible, false);

      final tabBar = find.byType(TabBar);
      final femaleJumpersTab = tester.widget<TabBar>(tabBar).tabs[1];
      await tester.tap(find.byWidget(femaleJumpersTab));
      await tester.pumpAndSettle();
      expect(itemsTypeCubit.state, FemaleJumper);
      expect(tester.widget<DatabaseItemsList>(itemsList).length, femaleJumpers.length);

      final secondTile = find.descendant(
          of: find.byType(DatabaseItemsList), matching: find.byKey(const ValueKey(1)));
      expect(tester.widget<AppropriateDbItemListTile>(secondTile).selected, false);
      await tester.tap(secondTile);
      await tester.pumpAndSettle();
      expect(tester.widget<AppropriateDbItemListTile>(secondTile).selected, true);
    });

    testWidgets('Editing hills and changing between them', (tester) async {
      tester.binding.defaultBinaryMessenger
          .setMockMethodCallHandler(flutterWindowCloseChannel, (call) async {
        if (call.method == 'init') {
          return 'mocked response';
        }
        throw MissingPluginException();
      });
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(1200, 1000);
      WidgetsFlutterBinding.ensureInitialized();
      await tester.pumpWidget(appWidget);
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(DatabaseItemsList)) as BuildContext;
      final itemsTypeCubit = context.read<DatabaseItemsTypeCubit>();
      final itemsList = find.byType(DatabaseItemsList);
      final tabBar = find.byType(TabBar);
      final addFab = find.byKey(const Key('addFab'));
      final removeFab = find.byKey(const Key('removeFab'));

      Future<void> selectTab(int index) async {
        final tab = tester.widget<TabBar>(tabBar).tabs[index];
        await tester.tap(find.byWidget(tab));
        await tester.pumpAndSettle();
      }

      Future<void> tapItem(int index) async {
        final itemTile = find.descendant(
            of: find.byType(DatabaseItemsList), matching: find.byKey(ValueKey(index)));
        await tester.tap(itemTile);
        await tester.pumpAndSettle();
      }

      Future<void> tap(Finder finder) async {
        await tester.tap(finder);
        await tester.pumpAndSettle();
      }

      expect(itemsTypeCubit.state, MaleJumper);
      await selectTab(2);
      expect(itemsTypeCubit.state, Hill);
      expect(tester.widget<DatabaseItemsList>(itemsList).length, hills.length);
      await tapItem(1);
      await tap(addFab); // index: 2
      await tap(addFab); // index: 3
      expect(tester.widget<DatabaseItemsList>(itemsList).length, hills.length + 2);
      await tester.enterText(
          find.byKey(const Key('locality')), 'Zakopane'); // We're editing index 3
      await tester.enterText(find.byKey(const Key('name')), 'Wielka Krokiew');
      await tester.enterText(find.byKey(const Key('hs')), '140');
      await tester.pumpAndSettle();
      await tapItem(2);
      await tester.enterText(
          find.byKey(const Key('locality')), 'Sapporo'); // We're editing index 2
      await tester.enterText(find.byKey(const Key('name')), 'Ōkurayama');
      await tester.enterText(find.byKey(const Key('k')), '123');
      await tester.enterText(find.byKey(const Key('hs')), '137');
      await tester.pumpAndSettle();
      await tapItem(2); // Hide HillEditor
      await tester.pumpAndSettle();

      await tapItem(2);
      await tap(removeFab); //
      await tapItem(3); // 4, if 2 hadn't been removed
      await tap(removeFab);
      await tapItem(1); // Schattenbergschanze
      expect(find.byType(HillEditor), findsOneWidget);
      expect(tester.widget<MyTextField>(find.byKey(const Key('name'))).controller.text,
          'Schattenbergschanze');
      final selectedIndexesRepo = context.read<SelectedIndexesRepo>();
      expect(selectedIndexesRepo.state.single, 1);
      await tapItem(2);
      expect(
          tester.widget<MyTextField>(find.byKey(const Key('locality'))).controller.text,
          'Zakopane');
    });
  });
}
