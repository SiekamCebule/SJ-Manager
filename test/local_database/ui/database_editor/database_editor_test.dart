import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/models/country.dart';
import 'package:sj_manager/models/hill/hill.dart';
import 'package:sj_manager/models/hill/hill_profile_type.dart';
import 'package:sj_manager/models/hill/jumps_variability.dart';
import 'package:sj_manager/models/hill/landing_ease.dart';
import 'package:sj_manager/models/hill/typical_wind_direction.dart';
import 'package:sj_manager/models/jumper/jumper.dart';
import 'package:sj_manager/models/jumper/jumper_skills.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/database_editing/db_editing_defaults_repo.dart';
import 'package:sj_manager/repositories/database_editing/db_items_repository.dart';
import 'package:sj_manager/repositories/database_editing/default_items_repository.dart';
import 'package:sj_manager/setup/set_up_app.dart';
import 'package:sj_manager/ui/app.dart';
import 'package:sj_manager/ui/providers/locale_provider.dart';
import 'package:sj_manager/ui/screens/database_editor/database_editor_screen.dart';
import 'package:flutter/material.dart';
import 'package:sj_manager/ui/theme/app_theme_brightness_cubit.dart';
import 'package:sj_manager/ui/theme/color_scheme_cubit.dart';
import 'package:sj_manager/ui/theme/theme_cubit.dart';

void main() {
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
      name: 'Schattenbergschanze',
      locality: 'Oberstdorf',
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
    testWidgets('test', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => LocaleProvider(
            initial: const Locale('en'),
          ),
          child: MultiRepositoryProvider(
            providers: [
              RepositoryProvider<CountriesRepo>(
                create: (context) => CountriesRepo(initial: countries),
              ),
              RepositoryProvider(
                create: (context) => DbItemsRepo<MaleJumper>(initial: maleJumpers),
              ),
              RepositoryProvider(
                create: (context) => DbItemsRepo<FemaleJumper>(initial: femaleJumpers),
              ),
              RepositoryProvider(
                create: (context) => DbItemsRepo<Hill>(initial: hills),
              ),
              RepositoryProvider(create: (context) {
                final noneCountry = context.read<CountriesRepo>().none;
                return DefaultItemsRepo(
                  defaultFemaleJumper: FemaleJumper.empty(country: noneCountry),
                  defaultMaleJumper: MaleJumper.empty(country: noneCountry),
                  defaultHill: Hill.empty(country: noneCountry),
                );
              }),
              RepositoryProvider(create: (context) {
                return DbEditingDefaultsRepo.appDefault();
              }),
            ],
            child: MultiProvider(
              providers: [
                Provider(
                  create: (context) => AppConfigurator(
                    router: router,
                    shouldSetUpRouting: true,
                    shouldLoadDatabase: false,
                  ),
                ),
              ],
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => AppThemeBrightnessCubit()),
                  BlocProvider(
                    create: (context) => AppColorSchemeCubit(),
                  ),
                  BlocProvider(create: (context) {
                    return ThemeCubit(
                      appSchemeSubscription: BlocProvider.of<AppColorSchemeCubit>(context)
                          .stream
                          .listen(null),
                      appThemeBrightnessSubscription:
                          BlocProvider.of<AppThemeBrightnessCubit>(context)
                              .stream
                              .listen(null),
                    );
                  }),
                ],
                child: const App(home: DatabaseEditorScreen()),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final fab = find.byType(FloatingActionButton);
      expect(fab, findsNWidgets(2));
    });
  });
}
