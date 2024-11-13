import 'package:sj_manager/models/simulation/database/actions/simulation_actions_repo.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_manager_data.dart';
import 'package:sj_manager/models/simulation/jumper/simulation_jumper.dart';
import 'package:sj_manager/models/simulation/jumper/stats/jumper_attribute_history.dart';
import 'package:sj_manager/models/simulation/jumper/stats/jumper_stats.dart';
import 'package:sj_manager/models/simulation/flow/reports/team_reports.dart';
import 'package:sj_manager/models/simulation/flow/simulation_mode.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_season.dart';
import 'package:sj_manager/models/simulation/database/simulation_wizard_options_repo.dart';
import 'package:sj_manager/models/simulation/jumper/reports/jumper_reports.dart';
import 'package:sj_manager/models/simulation/standings/score/details/classification_score_details.dart';
import 'package:sj_manager/models/simulation/standings/score/details/competition_score_details.dart';
import 'package:sj_manager/models/simulation/standings/score/details/jump_score_details.dart';
import 'package:sj_manager/models/simulation/standings/score/score.dart';
import 'package:sj_manager/models/database/hill/hill.dart';
import 'package:sj_manager/models/database/psyche/psyche_utils.dart';
import 'package:sj_manager/models/database/team/country_team/country_team.dart';
import 'package:sj_manager/models/database/team/personal_coach_team.dart';
import 'package:sj_manager/models/database/team/subteam.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';
import 'package:sj_manager/utils/id_generator.dart';

class DefaultSimulationDatabaseCreator {
  DefaultSimulationDatabaseCreator({
    required this.idGenerator,
  });

  final IdGenerator idGenerator;

  late ItemsIdsRepo<String> _idsRepo;
  late List<SimulationJumper> _jumpers;
  late List<Hill> _hills;
  late List<CountryTeam> _countryTeams;
  late CountriesRepo _countries;
  late List<SimulationSeason> _seasons;

  SimulationDatabase create(SimulationWizardOptionsRepo options) {
    final mode = options.mode.last!;
    _idsRepo = ItemsIdsRepo();
    _hills = List.of(options.gameVariant.last!.hills);
    _countryTeams = List.of(options.gameVariant.last!.countryTeams);
    _countries = CountriesRepo(countries: options.gameVariant.last!.countries);
    _seasons = List.of([options.gameVariant.last!.season]);
    final jumperRecords = List.of(options.gameVariant.last!.jumpers);
    _jumpers = jumperRecords.map(
      (dbRecord) {
        return SimulationJumper(
          dateOfBirth: dbRecord.dateOfBirth,
          name: dbRecord.name,
          surname: dbRecord.surname,
          country: dbRecord.country,
          sex: dbRecord.sex,
          takeoffQuality: dbRecord.skills.takeoffQuality,
          flightQuality: dbRecord.skills.flightQuality,
          landingQuality: dbRecord.skills.landingQuality,
          trainingConfig: null,
          form: 10,
          jumpsConsistency: 5,
          morale: 0,
          fatigue: 0,
          levelOfConsciousness: locByPersonality(dbRecord.personality),
        );
      },
    ).toList();
    _setUpIdsRepo();
    final jumperReports = {
      for (var jumper in _jumpers)
        _idsRepo.id(jumper): JumperReports(
          levelReport: null,
          weeklyTrainingReport: null,
          monthlyTrainingReport: null,
          moraleRating: null,
          jumpsRating: null,
        ),
    };
    const attributeHistoryLimit =
        31; // Max number of days in a month. The biggest need is when we create a monthly training report.
    final jumperStats = {
      for (var jumper in _jumpers)
        _idsRepo.id(jumper): JumperStats(
          progressableAttributeHistory: {
            TrainingProgressCategory.takeoff:
                JumperAttributeHistory.empty(limit: attributeHistoryLimit),
            TrainingProgressCategory.flight:
                JumperAttributeHistory.empty(limit: attributeHistoryLimit),
            TrainingProgressCategory.landing:
                JumperAttributeHistory.empty(limit: attributeHistoryLimit),
            TrainingProgressCategory.consistency:
                JumperAttributeHistory.empty(limit: attributeHistoryLimit),
            TrainingProgressCategory.form:
                JumperAttributeHistory.empty(limit: attributeHistoryLimit),
          },
        ),
    };
    final personalCoachTeam = options.mode.last! == SimulationMode.personalCoach
        ? PersonalCoachTeam(jumpers: [])
        : null;
    _idsRepo.register(personalCoachTeam, id: idGenerator.generate());
    const defaultTeamReports = TeamReports(
      generalMoraleRating: null,
      generalJumpsRating: null,
      generalTrainingRating: null,
    );
    final teamReports = {
      if (personalCoachTeam != null) _idsRepo.id(personalCoachTeam): defaultTeamReports,
    };
    final userSubteam = mode == SimulationMode.classicCoach
        ? Subteam(
            parentTeam: options.team.last!,
            type: options.subteamType.last!,
          )
        : null;
    final earliestDate = options.gameVariant.last!.startDates.first;
    return SimulationDatabase(
      managerData: SimulationManagerData(
        mode: mode,
        userSubteam: userSubteam,
        personalCoachTeam: personalCoachTeam,
      ),
      startDate: earliestDate.date,
      currentDate: earliestDate.date,
      jumpers: _jumpers,
      hills: _hills,
      countryTeams: _countryTeams,
      subteamJumpers: {},
      countries: _countries,
      seasons: _seasons,
      idsRepo: _idsRepo,
      actionDeadlines: options.gameVariant.last!.actionDeadlines,
      actionsRepo: SimulationActionsRepo(initial: {}),
      jumperReports: jumperReports,
      jumperStats: jumperStats,
      teamReports: teamReports,
    );
  }

  void _setUpIdsRepo() {
    void register(dynamic item) {
      _idsRepo.register(item, id: idGenerator.generate());
    }

    final items = [
      ..._jumpers,
      ..._hills,
      ..._countryTeams,
      ..._countries.countries,
      ..._seasons,
      for (var season in _seasons) ...[
        for (var eventSeries in season.eventSeries) ...[
          eventSeries,
          for (var competition in eventSeries.calendar.competitions) ...[
            competition,
            competition.rules,
            for (var score in competition.standings?.scores ?? <Score>[]) ...[
              score,
              score.entity,
              score.details,
              if (score.details is CompetitionJumperScoreDetails) ...[
                ...(score.details as CompetitionJumperScoreDetails).jumpScores,
                ...(score.details as CompetitionJumperScoreDetails)
                    .jumpScores
                    .map((score) => score.details.jumpRecord),
              ],
              if (score.details is CompetitionTeamScoreDetails) ...[
                ...(score.details as CompetitionTeamScoreDetails).jumperScores,
                ...(score.details as CompetitionTeamScoreDetails).jumpScores,
                ...(score.details as CompetitionTeamScoreDetails)
                    .jumpScores
                    .map((score) => score.details.jumpRecord),
              ],
              if (score.details is JumpScoreDetails)
                ...(score.details as CompetitionJumperScoreDetails).jumpScores,
            ],
          ],
          for (var classification in eventSeries.calendar.classifications) ...[
            classification,
            classification.rules,
            for (var score in classification.standings?.scores ?? <Score>[]) ...[
              score,
              score.entity,
              score.details,
              if (score.details is ClassificationScoreDetails) ...[
                ...(score.details as ClassificationScoreDetails).competitionScores,
                ...(score.details as ClassificationScoreDetails)
                    .competitionScores
                    .map((score) => score.details.jumpScores),
              ],
            ],
          ],
        ],
      ],
    ];
    items.forEach(register);
  }
}
