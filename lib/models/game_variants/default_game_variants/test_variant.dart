import 'package:flutter/material.dart';
import 'package:sj_manager/json/countries.dart';
import 'package:sj_manager/json/simulation_db_loading/team_loader.dart';
import 'package:sj_manager/models/game_variants/default_game_variants/constants.dart';
import 'package:sj_manager/models/game_variants/game_variant.dart';
import 'package:sj_manager/models/game_variants/game_variant_start_date.dart';
import 'package:sj_manager/models/game_variants/game_variants_io_utils.dart';
import 'package:sj_manager/models/simulation/classification/classification.dart';
import 'package:sj_manager/models/simulation/classification/default_classification_rules.dart';
import 'package:sj_manager/models/simulation/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/models/simulation/competition/calendar_records/calendar_main_competition_record_setup.dart';
import 'package:sj_manager/models/simulation/competition/calendar_records/calendar_main_competition_records_to_calendar.dart';
import 'package:sj_manager/models/simulation/competition/competition.dart';
import 'package:sj_manager/models/simulation/competition/competition_labels.dart';
import 'package:sj_manager/models/simulation/competition/high_level_calendar.dart';
import 'package:sj_manager/models/simulation/competition/rules/competition_round_rules/default_individual_competition_round_rules.dart';
import 'package:sj_manager/models/simulation/competition/rules/competition_round_rules/default_team_competition_round_rules.dart';
import 'package:sj_manager/models/simulation/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/models/simulation/competition/rules/entities_limit.dart';
import 'package:sj_manager/models/simulation/competition/rules/ko/ko_round_rules.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/classification_score_creator/concrete/individual_default.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/classification_score_creator/concrete/team_default.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/competition_score_creator/concrete/individual/default_linear.dart';
import 'package:collection/collection.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/judges_creator/concrete/default.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/jump_score_creator/concrete/default_classic.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/ko_group_creator.dart/concrete/default_classic.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/ko_round_advancement_determinator/concrete/n_best.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/wind_averager/concrete/default_weighted.dart';
import 'package:sj_manager/models/simulation/database/actions/simulation_action_type.dart';
import 'package:sj_manager/models/simulation/event_series/event_series.dart';
import 'package:sj_manager/models/simulation/event_series/event_series_calendar.dart';
import 'package:sj_manager/models/simulation/event_series/event_series_setup.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_season.dart';
import 'package:sj_manager/models/simulation/jumper/reports/jumper_level_description.dart';
import 'package:sj_manager/models/simulation/standings/standings.dart';
import 'package:sj_manager/models/simulation/standings/standings_positions_map_creator/standings_positions_with_ex_aequos_creator.dart';
import 'package:sj_manager/models/database/country/country.dart';
import 'package:sj_manager/models/database/hill/hill.dart';
import 'package:sj_manager/models/database/hill/hill_profile_type.dart';
import 'package:sj_manager/models/database/hill/jumps_variability.dart';
import 'package:sj_manager/models/database/hill/landing_ease.dart';
import 'package:sj_manager/models/database/jumper/jumper_db_record.dart';
import 'package:sj_manager/models/database/team/country_team/country_team.dart';
import 'package:sj_manager/models/database/team/team.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/generic/db_items_json_configuration.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';
import 'package:sj_manager/utils/multilingual_string.dart';
import 'package:provider/provider.dart';

Future<GameVariant> constructTestGameVariant({
  required BuildContext context,
}) async {
  return await _TestGameVariantCreator().construct(
    context: context,
  );
}

class _TestGameVariantCreator {
  late List<Hill> _hills;
  late CountriesRepo _countriesRepo;

  Error get _contextIsNotMountedError => StateError('Context is not mounted, but should');

  Future<GameVariant> construct({
    required BuildContext context,
  }) async {
    final countries = await loadGameVariantItems<Country>(
      pathsCache: context.read(),
      pathsRegistry: context.read(),
      gameVariantId: 'test',
      fromJson: context.read<DbItemsJsonConfiguration<Country>>().fromJson,
    );
    _countriesRepo = CountriesRepo(countries: countries);
    if (!context.mounted) throw _contextIsNotMountedError;
    final teams = await loadGameVariantItems<CountryTeam>(
      pathsCache: context.read(),
      pathsRegistry: context.read(),
      gameVariantId: 'test',
      fromJson: (json) {
        return TeamLoader(
          idsRepo: ItemsIdsRepo(), // CountryTeam loading doesn't need ids repos
          countryLoader: JsonCountryLoaderByCode(repo: _countriesRepo),
        ).parse(json) as CountryTeam;
      },
    );
    if (!context.mounted) throw _contextIsNotMountedError;
    final males = await loadGameVariantItems<MaleJumperDbRecord>(
      pathsCache: context.read(),
      pathsRegistry: context.read(),
      gameVariantId: 'test',
      fromJson: (json) {
        return MaleJumperDbRecord.fromJson(json,
            countryLoader: JsonCountryLoaderByCode(repo: _countriesRepo));
      },
    );
    if (!context.mounted) throw _contextIsNotMountedError;
    final females = await loadGameVariantItems<FemaleJumperDbRecord>(
      pathsCache: context.read(),
      pathsRegistry: context.read(),
      gameVariantId: 'test',
      fromJson: (json) {
        return FemaleJumperDbRecord.fromJson(json,
            countryLoader: JsonCountryLoaderByCode(repo: _countriesRepo));
      },
    );
    final jumpers = [
      ...males,
      ...females,
    ];

    setUpHills();
    final wcCalendar = _constructWcCalendar();
    return GameVariant(
      id: 'test',
      name: const MultilingualString({
        'pl': 'Testowe 24/25',
        'en': 'Test 24/25',
      }),
      shortDescription: const MultilingualString({
        'pl': 'Essa rigcz imo sigma',
        'en': 'Essa rigcz imo sigma',
      }),
      longDescription: const MultilingualString({
        'pl':
            'Nadchodzi długo wyczekiwany sezon 2023/24! Kto okaże się najlepszy? Kobayashi? Kraft? Wellinger? Czy Polacy odmienią swoje skoki? Czy Tschofenig wygra po raz pierwszy? Czy Maciej Kot wejdzie do TOP10 pierwszy raz od 2018 roku? Kto okaże się objawieniem? Kto zostanie mistrzem świata juniorów? Możesz wziąć sprawy w swoje ręce lub obserwować ekscytującą batalię na skoczniach świata.\n\nWariant testowy. Bardziej dopracowany wariant dla sezonu 2023/24 ukaże się w przyszłości.',
        'en': 'Siekam cebulę',
      }),
      startDates: [
        GameVariantStartDate(
          label: const MultilingualString({
            'pl': 'Początek okresu przygotowawczego',
            'en': 'Start of the preparation period',
          }),
          date: DateTime(2024, 5, 1),
        ),
        GameVariantStartDate(
          label: const MultilingualString({
            'pl': 'Przed startem sezonu letniego',
            'en': 'Before the summer season start',
          }),
          date: DateTime(2024, 7, 10),
        ),
        GameVariantStartDate(
          label: const MultilingualString({
            'pl': 'Przed startem sezonu zimowego',
            'en': 'Before the winter season start',
          }),
          date: DateTime(2024, 11, 5),
        ),
      ],
      actionDeadlines: {
        SimulationActionType.settingUpTraining: DateTime(2024, 5, 15),
        SimulationActionType.settingUpSubteams: DateTime(2024, 5, 10),
      },
      jumperLevelRequirements: {
        JumperLevelDescription.top: 17,
        JumperLevelDescription.broadTop: 15,
        JumperLevelDescription.international: 12,
        JumperLevelDescription.regional: 9,
        JumperLevelDescription.national: 6,
        JumperLevelDescription.local: 3,
        JumperLevelDescription.amateur: 0,
      },
      hills: _hills,
      countries: countries,
      countryTeams: teams,
      jumpers: jumpers,
      season: SimulationSeason(
        eventSeries: [
          EventSeries(
            calendar: wcCalendar,
            setup: const EventSeriesSetup(
              id: 'wc',
              multilingualName: MultilingualString(
                {
                  'pl': 'Puchar Świata',
                  'en': 'World Cup',
                },
              ),
              multilingualDescription: MultilingualString(
                {
                  'pl': 'Najważniejsze rozgrywki zimowe i walka o krzyształową kulę',
                  'en':
                      'The most important winter series and a fight for a crystal globe',
                },
              ),
              priority: 1,
              relativeMoneyPrize: EventSeriesRelativeMoneyPrize.average,
            ),
          ),
        ],
      ),
    );
  }

  void setUpHills() {
    _hills = [
      Hill(
        name: 'Letalncia',
        locality: 'Planica',
        country: _countriesRepo.byCode('si'),
        k: 200,
        hs: 240,
        landingEase: LandingEase.fairlyLow,
        profileType: HillProfileType.favorsInTakeoff,
        jumpsVariability: JumpsVariability.stable,
        pointsForGate: 8.64,
        pointsForHeadwind: 14.40,
        pointsForTailwind: 21.60,
      ),
      Hill(
        name: 'Erzberg Arena',
        locality: 'Eisenerz-Ramsau',
        country: _countriesRepo.byCode('at'),
        k: 98,
        hs: 109,
        landingEase: LandingEase.average,
        profileType: HillProfileType.balanced,
        jumpsVariability: JumpsVariability.average,
        pointsForGate: 7.00,
        pointsForHeadwind: 8.40,
        pointsForTailwind: 12.60,
      ),
      Hill(
        name: 'Malinka',
        locality: 'Wisła',
        country: _countriesRepo.byCode('pl'),
        k: 120,
        hs: 134,
        landingEase: LandingEase.high,
        profileType: HillProfileType.highlyFavorsInFlight,
        jumpsVariability: JumpsVariability.variable,
        pointsForGate: 7.24,
        pointsForHeadwind: 10.80,
        pointsForTailwind: 16.20,
      ),
    ];
  }

  EventSeriesCalendar _constructWcCalendar() {
    final typicalIndividualRoundRules = DefaultIndividualCompetitionRoundRules(
      limit: null,
      bibsAreReassigned: false,
      startlistIsSorted: false,
      gateCanChange: true,
      gateCompensationsEnabled: true,
      windCompensationsEnabled: true,
      windAverager: DefaultWeightedWindAverager(
        skipNonAchievedSensors: true,
        computePreciselyPartialMeasurement: false,
      ),
      inrunLightsEnabled: true,
      dsqEnabled: true,
      positionsCreator: StandingsPositionsWithExAequosCreator(),
      ruleOf95HsFallEnabled: true,
      judgesCount: 5,
      judgesCreator: DefaultJudgesCreator(),
      significantJudgesCount: 3,
      competitionScoreCreator: DefaultLinearIndividualCompetitionScoreCreator(),
      jumpScoreCreator: DefaultClassicJumpScoreCreator(),
      koRules: null,
    );
    final individualCompetitionRulesSaturday = DefaultCompetitionRules(
      rounds: [
        typicalIndividualRoundRules.copyWith(
          limit: const EntitiesLimit.soft(50),
        ),
        typicalIndividualRoundRules.copyWith(
          limit: const EntitiesLimit.soft(30),
          startlistIsSorted: true,
        ),
      ],
    );
    final individualCompetitionRulesSunday = DefaultCompetitionRules(
      rounds: [
        typicalIndividualRoundRules.copyWith(
          limit: const EntitiesLimit.soft(50),
          bibsAreReassigned: true,
        ),
        typicalIndividualRoundRules.copyWith(
          limit: const EntitiesLimit.soft(30),
          startlistIsSorted: true,
        ),
      ],
    );
    final individualKoCompetitionRules = DefaultCompetitionRules(
      rounds: [
        typicalIndividualRoundRules.copyWith(
          limit: const EntitiesLimit.exact(50),
          koRules: KoRoundRules(
            advancementDeterminator: const NBestKoRoundAdvancementDeterminator(),
            advancementCount: 1,
            koGroupsCreator: DefaultClassicKoGroupsCreator(),
            groupSize: 2,
          ),
        ),
      ],
    );
    final individualQualificationsRules = DefaultCompetitionRules(
      rounds: [
        typicalIndividualRoundRules,
      ],
    );
    final individualTrainingRules = DefaultCompetitionRules(
      rounds: [
        typicalIndividualRoundRules.copyWith(judgesCount: 0, significantJudgesCount: 0),
      ],
    );
    final individualTrialRoundRules = individualTrainingRules;

    final competitions = [
      CalendarMainCompetitionRecord(
        date: DateTime(2024, 11, 23),
        hill: _hillByLocalityAndHs('Eisenerz-Ramsau', 109),
        setup: CalendarMainCompetitionRecordSetup(
          mainCompRules: individualCompetitionRulesSaturday,
          qualificationsRules: individualQualificationsRules,
          trialRoundRules: individualTrialRoundRules,
          trainingsRules: individualTrainingRules,
          trainingsCount: 2,
        ),
      ),
      CalendarMainCompetitionRecord(
        date: DateTime(2024, 11, 24),
        hill: _hillByLocalityAndHs('Eisenerz-Ramsau', 109),
        setup: CalendarMainCompetitionRecordSetup(
          mainCompRules: individualCompetitionRulesSunday,
          qualificationsRules: individualQualificationsRules,
        ),
      ),
      CalendarMainCompetitionRecord(
        date: DateTime(2024, 11, 30),
        hill: _hillByLocalityAndHs('Wisła', 134),
        setup: CalendarMainCompetitionRecordSetup(
          mainCompRules: individualCompetitionRulesSaturday,
          qualificationsRules: individualQualificationsRules,
          trialRoundRules: individualTrialRoundRules,
          trainingsRules: individualTrainingRules,
          trainingsCount: 2,
        ),
      ),
      CalendarMainCompetitionRecord(
        date: DateTime(2024, 12, 01),
        hill: _hillByLocalityAndHs('Wisła', 134),
        setup: CalendarMainCompetitionRecordSetup(
          mainCompRules: individualCompetitionRulesSunday,
          qualificationsRules: individualQualificationsRules,
        ),
      ),
      CalendarMainCompetitionRecord(
        date: DateTime(2024, 12, 07),
        hill: _hillByLocalityAndHs('Planica', 240),
        setup: CalendarMainCompetitionRecordSetup(
          mainCompRules: individualKoCompetitionRules,
          qualificationsRules: individualQualificationsRules,
          trainingsCount: 3,
          trainingsRules: individualTrainingRules,
        ),
      ),
    ];

    final highLevel = HighLevelCalendar(
      highLevelCompetitions: competitions,
      classifications: [],
    );
    return CalendarMainCompetitionRecordsToCalendarConverter(
      provideClassifications: (competitions, qualifications) {
        final wcCompetitions = competitions.where((competition) =>
            competition.labels.contains(
              DefaultCompetitionType.competition,
            ) &&
            competition is Competition<JumperDbRecord, Standings>);
        final ncCompetitions = competitions.where((competition) =>
            competition.labels.contains(DefaultCompetitionType.competition));
        final ncModifiers = {
          for (var ncCompetition in ncCompetitions)
            if (ncCompetition is Competition<Team, Standings> &&
                ncCompetition.rules.competitionRules.rounds
                        .cast<DefaultTeamCompetitionRoundRules>()
                        .first
                        .groupsCount ==
                    2) // duety
              ncCompetition: 0.5
        };
        final wislaSixCompetitions = competitions.where(
          (competition) =>
              (competition.labels.contains(
                    DefaultCompetitionType.competition,
                  ) ||
                  competition.labels.contains(
                    DefaultCompetitionType.qualifications,
                  )) &&
              competition.hill == _hillByLocalityAndHs('Wisła', 134),
        );
        return [
          DefaultClassification(
            name: 'World Cup',
            standings:
                Standings(positionsCreator: StandingsPositionsWithExAequosCreator()),
            rules: DefaultIndividualClassificationRules(
              classificationScoreCreator: DefaultIndividualClassificationScoreCreator(),
              scoringType: DefaultClassificationScoringType.pointsFromMap,
              pointsMap: worldCupPointsMap,
              competitions: wcCompetitions.toList(),
              pointsModifiers: {},
              includeApperancesInTeamCompetitions: false,
            ),
          ),
          DefaultClassification(
            name: 'Nations Cup',
            standings:
                Standings(positionsCreator: StandingsPositionsWithExAequosCreator()),
            rules: DefaultTeamClassificationRules(
              classificationScoreCreator: DefaultTeamClassificationScoreCreator(),
              scoringType: DefaultClassificationScoringType.pointsFromMap,
              pointsMap: nationsCupPointsMap,
              competitions: ncCompetitions.toList(),
              pointsModifiers: ncModifiers,
              includeJumperPointsFromIndividualCompetitions: true,
            ),
          ),
          DefaultClassification(
            name: 'Wisła Six',
            standings:
                Standings(positionsCreator: StandingsPositionsWithExAequosCreator()),
            rules: DefaultIndividualClassificationRules(
              classificationScoreCreator: DefaultIndividualClassificationScoreCreator(),
              scoringType: DefaultClassificationScoringType.pointsFromCompetitions,
              pointsMap: null,
              competitions: wislaSixCompetitions.toList(),
              pointsModifiers: {},
              includeApperancesInTeamCompetitions: true,
            ),
          ),
        ];
      },
    ).convert(highLevel);
  }

  Hill _hillByLocalityAndHs(String locality, double hs) {
    final hill =
        _hills.singleWhereOrNull((hill) => hill.locality == locality && hill.hs == hs);
    if (hill == null) {
      throw StateError(
          '(Test game variant): Cannot find a hill with locality $locality and hs $hs');
    }
    return hill;
  }
}
