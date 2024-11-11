import 'package:sj_manager/models/simulation/database/actions/simulation_actions_repo.dart';
import 'package:sj_manager/models/simulation/flow/jumper_dynamic_params.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_manager_data.dart';
import 'package:sj_manager/models/simulation/flow/jumper_stats/jumper_attribute_history.dart';
import 'package:sj_manager/models/simulation/flow/jumper_stats/jumper_stats.dart';
import 'package:sj_manager/models/simulation/flow/reports/team_reports.dart';
import 'package:sj_manager/models/simulation/flow/simulation_mode.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_season.dart';
import 'package:sj_manager/models/simulation/database/simulation_wizard_options_repo.dart';
import 'package:sj_manager/models/simulation/flow/reports/jumper_reports.dart';
import 'package:sj_manager/models/simulation/standings/score/details/classification_score_details.dart';
import 'package:sj_manager/models/simulation/standings/score/details/competition_score_details.dart';
import 'package:sj_manager/models/simulation/standings/score/details/jump_score_details.dart';
import 'package:sj_manager/models/simulation/standings/score/score.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/psyche/psyche_utils.dart';
import 'package:sj_manager/models/user_db/team/country_team/country_team.dart';
import 'package:sj_manager/models/user_db/team/personal_coach_team.dart';
import 'package:sj_manager/models/user_db/team/subteam.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';
import 'package:sj_manager/utils/id_generator.dart';

class DefaultSimulationDatabaseCreator {
  DefaultSimulationDatabaseCreator({
    required this.idGenerator,
  });

  final IdGenerator idGenerator;

  late ItemsIdsRepo _idsRepo;
  late ItemsRepo<Jumper> _jumpers;
  late ItemsRepo<Hill> _hills;
  late ItemsRepo<CountryTeam> _countryTeams;
  late CountriesRepo _countries;
  late ItemsRepo<SimulationSeason> _seasons;

  SimulationDatabase create(SimulationWizardOptionsRepo options) {
    _idsRepo = ItemsIdsRepo();
    _jumpers = ItemsRepo(initial: options.gameVariant.last!.jumpers);
    _hills = ItemsRepo(initial: options.gameVariant.last!.hills);
    _countryTeams = ItemsRepo(initial: options.gameVariant.last!.countryTeams);
    _countries = CountriesRepo(initial: options.gameVariant.last!.countries);
    _seasons = ItemsRepo(initial: [options.gameVariant.last!.season]);
    final mode = options.mode.last!;
    _setUpIdsRepo();
    final jumpersDynamicParameters = {
      for (var jumper in _jumpers.last)
        jumper: JumperDynamicParams(
          trainingConfig: null,
          morale: 0,
          fatigue: 0,
          form: 10,
          jumpsConsistency: 5,
          levelOfConsciousness: locByPersonality(jumper.personality),
        ),
    };
    final jumperReports = {
      for (var jumper in _jumpers.last)
        jumper: const JumperReports(
          levelReport: null,
          weeklyTrainingReport: null,
          monthlyTrainingReport: null,
          moraleRating: null,
          jumpsRating: null,
        ),
    };
    final jumperStats = {
      for (var jumper in _jumpers.last)
        jumper: JumperStats(
          progressableAttributeHistory: {
            TrainingProgressCategory.takeoff: JumperAttributeHistory.empty(),
            TrainingProgressCategory.flight: JumperAttributeHistory.empty(),
            TrainingProgressCategory.landing: JumperAttributeHistory.empty(),
            TrainingProgressCategory.consistency: JumperAttributeHistory.empty(),
            TrainingProgressCategory.form: JumperAttributeHistory.empty(),
          },
        ),
    };
    final personalCoachTeam = options.mode.last! == SimulationMode.personalCoach
        ? const PersonalCoachTeam(jumperIds: [])
        : null;
    _idsRepo.register(personalCoachTeam, id: idGenerator.generate());
    const defaultTeamReports = TeamReports(
      generalMoraleRating: null,
      generalJumpsRating: null,
      generalTrainingRating: null,
    );
    final teamReports = {
      if (personalCoachTeam != null) personalCoachTeam: defaultTeamReports,
    };
    final userSubteam = mode == SimulationMode.classicCoach
        ? Subteam(
            parentTeam: options.team.last!,
            type: options.subteamType.last!,
          )
        : null;
    return SimulationDatabase(
      managerData: SimulationManagerData(
        mode: mode,
        userSubteam: userSubteam,
        personalCoachTeam: personalCoachTeam,
      ),
      startDate: options.startDate.last!.date,
      currentDate: options.startDate.last!.date,
      jumpers: _jumpers,
      hills: _hills,
      countryTeams: _countryTeams,
      subteamJumpers: const {},
      countries: _countries,
      seasons: _seasons,
      idsRepo: _idsRepo,
      actionDeadlines: options.gameVariant.last!.actionDeadlines,
      actionsRepo: SimulationActionsRepo(initial: {}),
      jumperDynamicParams: jumpersDynamicParameters,
      jumperReports: jumperReports,
      jumperStats: jumperStats,
      teamReports: teamReports,
      isDisposed: false,
    );
  }

  void _setUpIdsRepo() {
    void register(dynamic item) {
      _idsRepo.register(item, id: idGenerator.generate());
    }

    final items = [
      ..._jumpers.last,
      ..._hills.last,
      ..._countryTeams.last,
      ..._countries.last,
      ..._seasons.last,
      for (var season in _seasons.last) ...[
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
