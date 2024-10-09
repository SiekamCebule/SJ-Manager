import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/bloc/database_editing/database_items_cubit.dart';
import 'package:sj_manager/bloc/database_editing/state/database_items_state.dart';
import 'package:sj_manager/filters/jumpers/jumper_matching_algorithms.dart';
import 'package:sj_manager/filters/jumpers/jumpers_filter.dart';
import 'package:sj_manager/models/simulation/competition/rules/competition_rules/default_competition_rules_preset.dart';
import 'package:sj_manager/models/simulation/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/models/simulation/event_series/event_series_setup.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/team/country_team/country_team_facts.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/hill/hill_profile_type.dart';
import 'package:sj_manager/models/user_db/hill/jumps_variability.dart';
import 'package:sj_manager/models/user_db/hill/landing_ease.dart';
import 'package:sj_manager/models/user_db/hill/typical_wind_direction.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/jumper/jumper_skills.dart';
import 'package:sj_manager/models/user_db/items_repos_registry.dart';
import 'package:sj_manager/models/user_db/psyche/personalities.dart';
import 'package:sj_manager/models/user_db/sex.dart';
import 'package:sj_manager/models/user_db/team/country_team/country_team.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/database_editing/db_editing_defaults_repo.dart';
import 'package:sj_manager/repositories/generic/editable_items_repo.dart';
import 'package:sj_manager/repositories/database_editing/selected_indexes_repository.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';
import 'package:sj_manager/repositories/settings/local_user_settings_repo.dart';
import 'package:sj_manager/repositories/settings/mocked_user_settings_repo.dart';
import 'package:sj_manager/repositories/settings/user_settings_repo.dart';
import 'package:sj_manager/setup/app_configurator.dart';
import 'package:sj_manager/ui/app.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_text_field.dart';
import 'package:sj_manager/ui/database_item_editors/hill_editor.dart';
import 'package:sj_manager/ui/providers/locale_cubit.dart';
import 'package:sj_manager/ui/reusable_widgets/animations/animated_visibility.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/countries_dropdown.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_tiles/jumper_info_list_tile.dart';
import 'package:sj_manager/ui/reusable_widgets/filtering/search_text_field.dart';
import 'package:sj_manager/ui/screens/database_editor/database_editor_screen.dart';
import 'package:flutter/material.dart';
import 'package:sj_manager/ui/screens/database_editor/large/widgets/appropriate_db_item_list_tile.dart';
import 'package:sj_manager/ui/screens/database_editor/large/widgets/database_items_list.dart';
import 'package:sj_manager/ui/theme/app_schemes.dart';
import 'package:sj_manager/ui/theme/theme_cubit.dart';
import 'package:sj_manager/utils/id_generator.dart';

import 'database_editor_test.mocks.dart';

@GenerateMocks([ItemsRepo, LocalUserSettingsRepo])
void main() {
  const MethodChannel flutterWindowCloseChannel = MethodChannel('flutter_window_close');

  final slovenia = Country.monolingual(code: 'si', language: 'en', name: 'Slovenia');
  final switzerland =
      Country.monolingual(code: 'ch', language: 'en', name: 'Switzerland');
  final germany = Country.monolingual(code: 'de', language: 'en', name: 'Germany');
  final noneCountry = Country.monolingual(code: 'none', language: 'en', name: 'None');
  final countries = [noneCountry, slovenia, switzerland, germany];

  final maleJumpers = [
    MaleJumper(
      name: 'Adrian',
      surname: 'Nowak',
      country: slovenia,
      dateOfBirth: DateTime.now(),
      personality: Personalities.balanced,
      skills: JumperSkills.empty
          .copyWith(qualityOnLargerHills: 67, qualityOnSmallerHills: 44),
    ),
    MaleJumper(
      name: 'Maciej',
      surname: 'Bąk',
      country: switzerland,
      dateOfBirth: DateTime.now(),
      personality: Personalities.balanced,
      skills: JumperSkills.empty,
    ),
    MaleJumper(
      name: 'Caroll',
      surname: 'King',
      country: switzerland,
      dateOfBirth: DateTime.now(),
      personality: Personalities.balanced,
      skills: JumperSkills.empty,
    ),
  ];
  final femaleJumpers = [
    FemaleJumper.empty(country: germany).copyWith(name: 'Angelica'),
    FemaleJumper.empty(country: germany).copyWith(name: 'Jasmina'),
    FemaleJumper.empty(country: switzerland).copyWith(name: 'Lisa'),
    FemaleJumper.empty(country: slovenia).copyWith(name: 'Nika'),
  ];
  final hills = [
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
      final teamsRepo = MockItemsRepo<Team>();
      when(teamsRepo.itemsType).thenReturn(Team);
      when(teamsRepo.last).thenReturn([
        CountryTeam(
          facts: const CountryTeamFacts(stars: 5, record: null, subteams: {}),
          sex: Sex.male,
          country: germany,
        ),
        CountryTeam(
          facts: const CountryTeamFacts(stars: 3, record: null, subteams: {}),
          sex: Sex.female,
          country: switzerland,
        ),
        CountryTeam(
          facts: const CountryTeamFacts(stars: 4, record: null, subteams: {}),
          sex: Sex.male,
          country: switzerland,
        ),
        CountryTeam(
          facts: const CountryTeamFacts(stars: 5, record: null, subteams: {}),
          sex: Sex.female,
          country: slovenia,
        ),
        CountryTeam(
          facts: const CountryTeamFacts(stars: 5, record: null, subteams: {}),
          sex: Sex.male,
          country: slovenia,
        ),
      ]);
      appWidget = MultiProvider(
        providers: [
          MultiProvider(
            providers: [
              Provider<UserSettingsRepo>(
                create: (context) => const MockedUserSettingsRepo(
                  appColorScheme: AppColorScheme.blue,
                  appThemeBrightness: Brightness.dark,
                  databaseEditorTutorialShown: true,
                  languageCode: 'en',
                ),
              ),
              Provider(
                create: (context) => AppConfigurator(
                  shouldSetUpRouting: true,
                  shouldSetUpUserData: false,
                  shouldLoadDatabase: false,
                  loaders: [],
                ),
              ),
              BlocProvider(create: (context) {
                return ThemeCubit(
                  settingsRepo: context.read(),
                );
              }),
              BlocProvider(
                create: (context) => LocaleCubit(
                  initial: const Locale('en'),
                  settingsRepo: MockLocalUserSettingsRepo(),
                ),
              ),
            ],
          ),
        ],
        child: App(
          home: Builder(builder: (context) {
            return MultiRepositoryProvider(
              providers: [
                RepositoryProvider(
                  create: (context) => ItemsReposRegistry(
                    initial: {
                      EditableItemsRepo<MaleJumper>(initial: maleJumpers),
                      EditableItemsRepo<FemaleJumper>(initial: femaleJumpers),
                      EditableItemsRepo<Hill>(initial: hills),
                      EditableItemsRepo<EventSeriesSetup>(initial: []),
                      EditableItemsRepo<EventSeriesCalendarPreset>(initial: []),
                      EditableItemsRepo<DefaultCompetitionRulesPreset>(initial: []),
                      CountriesRepo(initial: countries),
                      teamsRepo,
                    },
                  ),
                ),
                RepositoryProvider(create: (context) {
                  return DbEditingDefaultsRepo.appDefault();
                }),
                Provider<IdGenerator>(create: (context) {
                  return const NanoIdGenerator(size: 10);
                }),
              ],
              child: const DatabaseEditorScreen(),
            );
          }),
        ),
      );
    });

    testWidgets('Basic test', (tester) async {
      await tester.runAsync(() async {
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

        final itemsCubit = context.read<DatabaseItemsCubit>();
        final itemsList = find.byType(DatabaseItemsList);
        expect(itemsCubit.state.itemsType, MaleJumper);
        expect(tester.widget<DatabaseItemsList>(itemsList).length, maleJumpers.length);
        expect(find.byType(FloatingActionButton), findsNWidgets(2));
        final addFabVisibility = find
            .ancestor(
                of: find.byKey(const Key('addFab')),
                matching: find.byType(AnimatedVisibility))
            .first;
        expect(tester.widget<AnimatedVisibility>(addFabVisibility).visible, true);

        final tile = find.descendant(
            of: find.byType(DatabaseItemsList), matching: find.byKey(const ValueKey(0)));
        await tester.tap(tile);
        await tester.pumpAndSettle();
        final removeFabVisibility = find
            .ancestor(
                of: find.byKey(const Key('removeFab')),
                matching: find.byType(AnimatedVisibility))
            .first;
        expect(tester.widget<AnimatedVisibility>(removeFabVisibility).visible, true);

        final tabBar = find.byType(TabBar);
        final femaleJumpersTab = tester.widget<TabBar>(tabBar).tabs[1];
        await tester.tap(find.byWidget(femaleJumpersTab));
        await tester.pumpAndSettle();
        expect(itemsCubit.state.itemsType, FemaleJumper);
        expect(tester.widget<DatabaseItemsList>(itemsList).length, femaleJumpers.length);

        final secondTile = find.descendant(
            of: find.byType(DatabaseItemsList), matching: find.byKey(const ValueKey(1)));
        expect(tester.widget<AppropriateDbItemListTile>(secondTile).selected, false);
        await tester.tap(secondTile);
        await tester.pumpAndSettle();
        expect(tester.widget<AppropriateDbItemListTile>(secondTile).selected, true);
        await tester.pumpWidget(Container());
        await tester.pump();
      });
    });

    testWidgets('Simple adding, editing removing and changing between items',
        (tester) async {
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
      await tester.runAsync(() async {
        await tester.pumpWidget(appWidget);
        await tester.pumpAndSettle();

        var context = tester.element(find.byType(DatabaseItemsList)) as BuildContext;
        final itemsCubit = context.read<DatabaseItemsCubit>();
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
          await tester.ensureVisible(itemTile);
          await tester.tap(itemTile);
          await tester.pumpAndSettle();
        }

        Future<void> tap(Finder finder) async {
          await tester.tap(finder);
          await tester.pumpAndSettle();
        }

        expect(itemsCubit.state.itemsType, MaleJumper);
        await selectTab(2);
        expect(itemsCubit.state.itemsType, Hill);
        expect(tester.widget<DatabaseItemsList>(itemsList).length, 3);
        await tapItem(1);
        await tap(addFab); // index: 2
        await tap(addFab); // index: 3
        expect(tester.widget<DatabaseItemsList>(itemsList).length, 5);
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
        expect(tester.widget<MyTextField>(find.byKey(const Key('name'))).controller!.text,
            'Schattenbergschanze');
        final selectedIndexesRepo = context.read<SelectedIndexesRepo>();
        expect(selectedIndexesRepo.last.single, 1);
        await tapItem(2);
        expect(
            tester
                .widget<MyTextField>(find.byKey(const Key('locality')))
                .controller!
                .text,
            'Zakopane');

        await selectTab(3);
        expect(itemsCubit.state.itemsType, EventSeriesSetup);
        expect(() => tapItem(0), throwsA(isA<Error>()));
        await tap(addFab);
        await tester.enterText(
          find.byKey(const Key('name')),
          'Puchar Świata',
        );
        await tester.pumpAndSettle();
        expect((itemsCubit.state as DatabaseItemsNonEmpty).filteredItems.length, 1);
        await tester.tapAt(Offset.zero);
        await tester.pump();
        await tapItem(0);
        expect(
          tester
              .widget<AnimatedVisibility>(find.byKey(const Key('animatedEditorNonEmpty')))
              .visible,
          false,
        );
        await selectTab(2);
        await tapItem(0);
        await tap(removeFab);
        context = tester.element(find.byType(DatabaseItemsList)) as BuildContext;
        expect((itemsCubit.state as DatabaseItemsNonEmpty).filteredItems.length, 2);
        await selectTab(3);
        expect((itemsCubit.state as DatabaseItemsNonEmpty).filteredItems.length, 1);

        await tester.pumpWidget(Container());
        await tester.pump();
      });
    });

    testWidgets('Utilizing filters', (tester) async {
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

      final tabBar = find.byType(TabBar);
      Future<void> selectTab(int index) async {
        final tab = tester.widget<TabBar>(tabBar).tabs[index];
        await tester.tap(find.byWidget(tab));
        await tester.pumpAndSettle();
      }

      final context = tester.element(find.byType(DatabaseItemsList)) as BuildContext;
      final itemsCubit = context.read<DatabaseItemsCubit>();
      itemsCubit.selectTab(1);
      await tester.pumpAndSettle();
      itemsCubit.itemsRepos.get<FemaleJumper>().set([
        ...femaleJumpers,
        FemaleJumper.empty(country: switzerland)
            .copyWith(name: 'Daniela', surname: 'Iraschko-Stolz'),
        FemaleJumper.empty(country: slovenia)
            .copyWith(name: 'Kamila', surname: 'Karpiel'),
      ]);

      await tester.pumpAndSettle();
      expect(tester.widget<DatabaseItemsList>(find.byType(DatabaseItemsList)).length, 6);
      expect(itemsCubit.state.itemsType, FemaleJumper);
      final searchField = find.byType(SearchTextField);
      await tester.enterText(searchField, 'kk');
      await tester.pumpAndSettle();
      expect(tester.widget<DatabaseItemsList>(find.byType(DatabaseItemsList)).length, 1);
      final singleTile = find.descendant(
        of: find.byType(DatabaseItemsList),
        matching: find.byType(JumperInfoListTile),
      );
      expect(
        tester.widget<JumperInfoListTile>(singleTile).jumper.nameAndSurname(),
        'Kamila Karpiel',
      );
      await selectTab(0);
      await selectTab(1);
      expect(
        tester.widget<SearchTextField>(find.byType(SearchTextField)).controller.text,
        '',
      );
      final countriesDropdown = find.descendant(
        of: find.byKey(const Key('femaleJumpersFilters')),
        matching: find.byType(CountriesDropdown),
      );

      // I couldn't do a tap on countries dropdown...
      itemsCubit.filtersRepo.setByGenericAndArgumentType(type: FemaleJumper, filters: [
        const ConcreteJumpersFilterWrapper<FemaleJumper, JumpersFilterBySearch>(
          filter: JumpersFilterBySearch(
            searchAlgorithm: DefaultJumperMatchingByTextAlgorithm(text: ''),
          ),
        ),
        ConcreteJumpersFilterWrapper<FemaleJumper, JumpersFilterByCountry>(
          filter: JumpersFilterByCountry(
            countries: {switzerland},
          ),
        ),
      ]);
      await tester.pumpAndSettle();

      expect(tester.widget<DatabaseItemsList>(find.byType(DatabaseItemsList)).length, 2);
      final secondJumperTile = find.descendant(
        of: find.descendant(
            of: find.byType(DatabaseItemsList), matching: find.byKey(const ValueKey(1))),
        matching: find.byType(
          JumperInfoListTile,
        ),
      );

      expect(
        tester.widget<JumperInfoListTile>(secondJumperTile).jumper.nameAndSurname(),
        'Daniela Iraschko-Stolz',
      );
      await selectTab(0);
      await selectTab(1);
      expect(
        tester.state<CountriesDropdownState>(countriesDropdown).controller.text,
        'None',
      );
    });
  });
}
