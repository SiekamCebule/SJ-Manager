import 'package:flutter/material.dart';
import 'package:sj_manager/models/game_variants/default_game_variants/constants.dart';
import 'package:sj_manager/models/game_variants/game_variant.dart';
import 'package:sj_manager/models/simulation_db/classification/classification.dart';
import 'package:sj_manager/models/simulation_db/classification/default_classification_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/models/simulation_db/competition/calendar_records/calendar_main_competition_record_setup.dart';
import 'package:sj_manager/models/simulation_db/competition/calendar_records/calendar_main_competition_records_to_calendar.dart';
import 'package:sj_manager/models/simulation_db/competition/competition.dart';
import 'package:sj_manager/models/simulation_db/competition/competition_labels.dart';
import 'package:sj_manager/models/simulation_db/competition/high_level_calendar.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_individual_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_team_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/entities_limit.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/ko/ko_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/classification_score_creator/concrete/individual_default.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/classification_score_creator/concrete/team_default.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/competition_score_creator/concrete/individual/default_linear.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/judges_creator/concrete/default.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/jump_score_creator/concrete/default_classic.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/concrete/default_classic.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_round_advancement_determinator/concrete/n_best.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/wind_averager/concrete/default_weighted.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';
import 'package:sj_manager/models/simulation_db/simulation_season.dart';
import 'package:sj_manager/models/simulation_db/standings/standings.dart';
import 'package:sj_manager/models/simulation_db/standings/standings_positions_map_creator/standings_positions_with_ex_aequos_creator.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/hill/hill_profile_type.dart';
import 'package:sj_manager/models/user_db/hill/jumps_variability.dart';
import 'package:sj_manager/models/user_db/hill/landing_ease.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/utils/multilingual_string.dart';
import 'package:provider/provider.dart';

GameVariant constructTestGameVariant({
  required BuildContext context,
  required List<Jumper> jumpers,
}) {
  return _TestGameVariantCreator().construct(context: context, jumpers: jumpers);
}

class _TestGameVariantCreator {
  late BuildContext _context;
  late List<Hill> _hills;

  GameVariant construct({
    required BuildContext context,
    required List<Jumper> jumpers,
  }) {
    _context = context;
    setUpHills();
    final wcCalendar = _constructWcCalendar();
    return GameVariant(
      id: 'test_24_25',
      name: const MultilingualString(valuesByLanguage: {
        'pl': 'Testowe 24/25',
        'en': 'Test 24/25',
      }),
      hills: _hills,
      jumpers: jumpers,
      season: SimulationSeason(
        eventSeries: [
          EventSeries(
            calendar: wcCalendar,
            setup: const EventSeriesSetup(
              id: 'wc',
              multilingualName: MultilingualString(
                valuesByLanguage: {
                  'pl': 'Puchar Świata',
                  'en': 'World Cup',
                },
              ),
              multilingualDescription: MultilingualString(
                valuesByLanguage: {
                  'pl': 'Najważniejsze rozgrywki zimowe i walka o krzyształową kulę',
                  'en':
                      'The most important winter series and a fight for a crystal globe',
                },
              ),
              priority: 1,
              relativeMoneyPrize: EventSeriesRelativeMoneyPrize.average,
            ),
          )
        ],
      ),
    );
  }

  void setUpHills() {
    final countries = _context.read<CountriesRepo>();
    _hills = [
      Hill(
        name: 'Letalncia',
        locality: 'Planica',
        country: countries.byCode('si'),
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
        country: countries.byCode('at'),
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
        country: countries.byCode('pl'),
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
        hill: _hillByLocalityAndHs('Lillehammer', 140),
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
        hill: _hillByLocalityAndHs('Lillehammer', 140),
        setup: CalendarMainCompetitionRecordSetup(
          mainCompRules: individualCompetitionRulesSunday,
          qualificationsRules: individualQualificationsRules,
        ),
      ),
      CalendarMainCompetitionRecord(
        date: DateTime(2024, 11, 30),
        hill: _hillByLocalityAndHs('Ruka', 142),
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
        hill: _hillByLocalityAndHs('Ruka', 142),
        setup: CalendarMainCompetitionRecordSetup(
          mainCompRules: individualCompetitionRulesSunday,
          qualificationsRules: individualQualificationsRules,
        ),
      ),
      CalendarMainCompetitionRecord(
        date: DateTime(2024, 12, 07),
        hill: _hillByLocalityAndHs('Wisła', 134),
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
            competition is Competition<Jumper, Standings>);
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
        final kuusamoSevenCompetitions = competitions.where(
          (competition) =>
              (competition.labels.contains(
                    DefaultCompetitionType.competition,
                  ) ||
                  competition.labels.contains(
                    DefaultCompetitionType.qualifications,
                  )) &&
              competition.hill.locality == 'Ruka',
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
              pointsModifiers: const {},
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
            name: 'Kuusamo Six',
            standings:
                Standings(positionsCreator: StandingsPositionsWithExAequosCreator()),
            rules: DefaultIndividualClassificationRules(
              classificationScoreCreator: DefaultIndividualClassificationScoreCreator(),
              scoringType: DefaultClassificationScoringType.pointsFromCompetitions,
              pointsMap: null,
              competitions: kuusamoSevenCompetitions.toList(),
              pointsModifiers: const {},
              includeApperancesInTeamCompetitions: true,
            ),
          ),
        ];
      },
    ).convert(highLevel);
  }

  Hill _hillByLocalityAndHs(String locality, double hs) {
    return _hills.singleWhere((hill) => hill.locality == locality && hill.hs == hs);
  }
}
