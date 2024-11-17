import 'package:sj_manager/data/models/game_variant/game_variant_start_date.dart';
import 'package:sj_manager/domain/entities/game_variant/hill/hill.dart';
import 'package:sj_manager/domain/entities/game_variant/hill/hill_profile_type.dart';
import 'package:sj_manager/domain/entities/game_variant/hill/jumps_variability.dart';
import 'package:sj_manager/domain/entities/game_variant/hill/landing_ease.dart';
import 'package:sj_manager/domain/entities/simulation/database/actions/simulation_action_type.dart';
import 'package:sj_manager/domain/entities/simulation/database/simulation_database_and_models/simulation_season.dart';
import 'package:sj_manager/domain/entities/simulation/event_series/event_series.dart';
import 'package:sj_manager/domain/entities/simulation/event_series/event_series_calendar.dart';
import 'package:sj_manager/domain/entities/simulation/jumper/reports/jumper_level_description.dart';
import 'package:sj_manager/domain/repository_interfaces/countries/countries_repo.dart';
import 'package:sj_manager/features/game_variants/data/convert/jumpers_converting.dart';
import 'package:sj_manager/features/game_variants/data/data_sources/hardcoded_game_variant_data_source.dart';
import 'package:sj_manager/features/game_variants/data/models/game_variant_model.dart';
import 'package:sj_manager/features/game_variants/domain/entities/game_variant.dart';
import 'package:sj_manager/utilities/utils/multilingual_string.dart';
import 'package:sj_manager/features/game_variants/data/data_sources/specific_variants/test/test_variant_constants.dart';
import 'package:sj_manager/domain/entities/simulation/classification/classification.dart';
import 'package:sj_manager/domain/entities/simulation/classification/default_classification_rules.dart';
import 'package:sj_manager/domain/entities/simulation/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/domain/entities/simulation/competition/calendar_records/calendar_main_competition_record_setup.dart';
import 'package:sj_manager/domain/entities/simulation/competition/calendar_records/calendar_main_competition_records_to_calendar.dart';
import 'package:sj_manager/domain/entities/simulation/competition/competition.dart';
import 'package:sj_manager/domain/entities/simulation/competition/competition_labels.dart';
import 'package:sj_manager/domain/entities/simulation/competition/high_level_calendar.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/competition_round_rules/default_individual_competition_round_rules.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/competition_round_rules/default_team_competition_round_rules.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/entities_limit.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/ko/ko_round_rules.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/classification_score_creator/concrete/individual_default.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/classification_score_creator/concrete/team_default.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/competition_score_creator/concrete/individual/default_linear.dart';
import 'package:collection/collection.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/judges_creator/concrete/default.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/jump_score_creator/concrete/default_classic.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/ko_group_creator.dart/concrete/default_classic.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/ko_round_advancement_determinator/concrete/n_best.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/wind_averager/concrete/default_weighted.dart';
import 'package:sj_manager/domain/entities/simulation/event_series/event_series_setup.dart';
import 'package:sj_manager/domain/entities/simulation/standings/standings.dart';
import 'package:sj_manager/domain/entities/simulation/standings/standings_positions_map_creator/standings_positions_with_ex_aequos_creator.dart';
import 'package:sj_manager/features/game_variants/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/domain/entities/simulation/team/team.dart';

class HardcodedTestGameVariantDataSource implements HardcodedGameVariantDataSource {
  late CountriesRepo _countriesRepo;
  late List<Hill> _hills;

  @override
  Future<GameVariant> fromModel(GameVariantModel model) async {
    _countriesRepo = CountriesRepo(countries: model.countries);
    _hills = _constructHills();
    final jumpers = model.jumpers.map(jumperDbRecordFromModel);
    return GameVariant(
      id: model.id,
      name: _name,
      shortDescription: _shortDescription,
      longDescription: _longDescription,
      jumpers: List.of(jumpers),
      hills: _hills,
      countries: List.of(model.countries),
      countryTeams: List.of(model.countryTeams),
      season: _constructSeason(),
      startDates: _startDates,
      actionDeadlines: _actionDeadlines,
      jumperLevelRequirements: _jumperLevelRequirements,
    );
  }

  static const _name = MultilingualString({
    'pl': 'Testowe 24/25',
    'en': 'Test 24/25',
  });

  static const _shortDescription = MultilingualString({
    'pl': 'Essa rigcz imo sigma',
    'en': 'Essa rigcz imo sigma',
  });
  static const _longDescription = MultilingualString({
    'pl':
        'Nadchodzi długo wyczekiwany sezon 2023/24! Kto okaże się najlepszy? Kobayashi? Kraft? Wellinger? Czy Polacy odmienią swoje skoki? Czy Tschofenig wygra po raz pierwszy? Czy Maciej Kot wejdzie do TOP10 pierwszy raz od 2018 roku? Kto okaże się objawieniem? Kto zostanie mistrzem świata juniorów? Możesz wziąć sprawy w swoje ręce lub obserwować ekscytującą batalię na skoczniach świata.\n\nWariant testowy. Bardziej dopracowany wariant dla sezonu 2023/24 ukaże się w przyszłości.',
    'en': 'Siekam cebulę',
  });

  static final _startDates = [
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
  ];

  static final _actionDeadlines = {
    SimulationActionType.settingUpTraining: DateTime(2024, 5, 15),
    SimulationActionType.settingUpSubteams: DateTime(2024, 5, 10),
  };
  static final Map<JumperLevelDescription, double> _jumperLevelRequirements = {
    JumperLevelDescription.top: 17,
    JumperLevelDescription.broadTop: 15,
    JumperLevelDescription.international: 12,
    JumperLevelDescription.regional: 9,
    JumperLevelDescription.national: 6,
    JumperLevelDescription.local: 3,
    JumperLevelDescription.amateur: 0,
  };

  List<Hill> _constructHills() {
    return [
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

  SimulationSeason _constructSeason() {
    return SimulationSeason(
      eventSeries: [
        EventSeries(
          calendar: _constructWcCalendar(),
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
                'en': 'The most important winter series and a fight for a crystal globe',
              },
            ),
            priority: 1,
            relativeMoneyPrize: EventSeriesRelativeMoneyPrize.average,
          ),
        ),
      ],
    );
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
