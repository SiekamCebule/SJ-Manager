import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/core/general_utils/filtering/matching_algorithms/jumper_matching_algorithms.dart';
import 'package:sj_manager/features/app_settings/data/repository/local_app_settings_repository.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_skills.dart';
import 'package:sj_manager/features/database_editor/presentation/pages/database_editor_page.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series_setup.dart';
import 'package:sj_manager/core/core_classes/country/country.dart';
import 'package:sj_manager/core/core_classes/hill/hill.dart';
import 'package:sj_manager/core/core_classes/hill/hill_profile_type.dart';
import 'package:sj_manager/core/core_classes/hill/jumps_variability.dart';
import 'package:sj_manager/core/core_classes/hill/landing_ease.dart';
import 'package:sj_manager/core/core_classes/hill/typical_wind_direction.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/core/psyche/personalities.dart';
import 'package:sj_manager/core/core_classes/sex.dart';
import 'package:sj_manager/core/core_classes/country_team/country_team_db_record.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/simulation_team.dart';
import 'package:sj_manager/to_embrace/ui/app.dart';
import 'package:sj_manager/to_embrace/ui/database_item_editors/fields/my_text_field.dart';
import 'package:sj_manager/to_embrace/ui/database_item_editors/hill_editor.dart';
import 'package:sj_manager/general_ui/reusable_widgets/animations/animated_visibility.dart';
import 'package:sj_manager/general_ui/reusable_widgets/countries/countries_dropdown.dart';
import 'package:sj_manager/general_ui/reusable_widgets/database_item_tiles/jumper_info_list_tile.dart';
import 'package:sj_manager/general_ui/reusable_widgets/filtering/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:sj_manager/features/database_editor/presentation/pages/large/widgets/appropriate_db_item_list_tile.dart';
import 'package:sj_manager/features/database_editor/presentation/pages/large/widgets/database_items_list.dart';
import 'package:sj_manager/to_embrace/ui/theme/app_schemes.dart';
import 'package:sj_manager/core/general_utils/id_generator.dart';

import 'database_editor_test.mocks.dart';

@GenerateMocks([LocalAppSettingsRepository])
void main() {
  const MethodChannel flutterWindowCloseChannel = MethodChannel('flutter_window_close');

  final slovenia = Country.monolingual(code: 'si', language: 'en', name: 'Slovenia');
  final switzerland =
      Country.monolingual(code: 'ch', language: 'en', name: 'Switzerland');
  final germany = Country.monolingual(code: 'de', language: 'en', name: 'Germany');
  final noneCountry = Country.monolingual(code: 'none', language: 'en', name: 'None');
  final countries = [noneCountry, slovenia, switzerland, germany];

  final maleJumpers = [
    MaleJumperDbRecord(
      name: 'Adrian',
      surname: 'Nowak',
      country: slovenia,
      dateOfBirth: DateTime.now(),
      personality: Personalities.balanced,
      skills: JumperSkills.empty.copyWith(
        takeoffQuality: 14,
        flightQuality: 14,
      ),
    ),
    MaleJumperDbRecord(
      name: 'Maciej',
      surname: 'Bąk',
      country: switzerland,
      dateOfBirth: DateTime.now(),
      personality: Personalities.balanced,
      skills: JumperSkills.empty,
    ),
    MaleJumperDbRecord(
      name: 'Caroll',
      surname: 'King',
      country: switzerland,
      dateOfBirth: DateTime.now(),
      personality: Personalities.balanced,
      skills: JumperSkills.empty,
    ),
  ];
  final femaleJumpers = [
    FemaleJumperDbRecord.empty(country: germany).copyWith(name: 'Angelica'),
    FemaleJumperDbRecord.empty(country: germany).copyWith(name: 'Jasmina'),
    FemaleJumperDbRecord.empty(country: switzerland).copyWith(name: 'Lisa'),
    FemaleJumperDbRecord.empty(country: slovenia).copyWith(name: 'Nika'),
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

  group(DatabaseEditorPage, () {
    late Widget appWidget;

    setUpAll(() {
      final teamsRepo = MockItemsRepo<SimulationTeam>();
      when(teamsRepo.itemsType).thenReturn(SimulationTeam);
      when(teamsRepo.last).thenReturn([
        CountryTeamDbRecord(
          facts: const CountryTeamFactsDbRecord(
              stars: 5, record: null, subteams: {}, limitInSubteam: {}),
          sex: Sex.male,
          country: germany,
        ),
        CountryTeamDbRecord(
          facts: const CountryTeamFactsDbRecord(
              stars: 3, record: null, subteams: {}, limitInSubteam: {}),
          sex: Sex.female,
          country: switzerland,
        ),
        CountryTeamDbRecord(
          facts: const CountryTeamFactsDbRecord(
              stars: 4, record: null, subteams: {}, limitInSubteam: {}),
          sex: Sex.male,
          country: switzerland,
        ),
        CountryTeamDbRecord(
          facts: const CountryTeamFactsDbRecord(
              stars: 5, record: null, subteams: {}, limitInSubteam: {}),
          sex: Sex.female,
          country: slovenia,
        ),
        CountryTeamDbRecord(
          facts: const CountryTeamFactsDbRecord(
              stars: 5, record: null, subteams: {}, limitInSubteam: {}),
          sex: Sex.male,
          country: slovenia,
        ),
      ]);
      appWidget = MultiProvider(
        providers: [
          MultiProvider(
            providers: [
              Provider<UserSettingsRepository>(
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
                      EditableItemsRepo<MaleJumperDbRecord>(initial: maleJumpers),
                      EditableItemsRepo<FemaleJumperDbRecord>(initial: femaleJumpers),
                      //CountriesRepository(countries: countries), // TODO
                      teamsRepo,
                    },
                  ),
                ),
                RepositoryProvider(create: (context) {
                  return DbEditingDefaultsRepository.appDefault();
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
        expect(itemsCubit.state.itemsType, MaleJumperDbRecord);
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
        expect(itemsCubit.state.itemsType, FemaleJumperDbRecord);
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

        expect(itemsCubit.state.itemsType, MaleJumperDbRecord);
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
      itemsCubit.itemsRepos.get<FemaleJumperDbRecord>().set([
        ...femaleJumpers,
        FemaleJumperDbRecord.empty(country: switzerland)
            .copyWith(name: 'Daniela', surname: 'Iraschko-Stolz'),
        FemaleJumperDbRecord.empty(country: slovenia)
            .copyWith(name: 'Kamila', surname: 'Karpiel'),
      ]);

      await tester.pumpAndSettle();
      expect(tester.widget<DatabaseItemsList>(find.byType(DatabaseItemsList)).length, 6);
      expect(itemsCubit.state.itemsType, FemaleJumperDbRecord);
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
      itemsCubit.filtersRepo.femaleJumpersSearchFilter = Filter(shouldPass: (jumper) {
        return DefaultJumperMatchingByTextAlgorithm(
                fullName: jumper.nameAndSurname(), text: '')
            .matches();
      });
      itemsCubit.filtersRepo.femaleJumpersCountryFilter = Filter(shouldPass: (jumper) {
        return jumper.country == switzerland;
      });
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
