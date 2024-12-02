import 'package:sj_manager/core/countries/countries_repository/countries_repository.dart';
import 'package:sj_manager/core/countries/countries_repository/in_memory_countries_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action.dart';
import 'package:sj_manager/features/career_mode/subfeatures/country_teams/data/mappers/country_team_mappers.dart';
import 'package:sj_manager/features/career_mode/subfeatures/jumper_stats/domain/entities/jumper_attribute.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/competition_scores.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/score.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/manager_data/simulation_manager_data.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/stats/jumper_attribute_history.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/stats/jumper_stats.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_mode.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/simulation_season.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/country_team.dart';
import 'package:sj_manager/features/simulations/presentation/simulation_wizard/simulation_wizard_options_repo.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/reports/jumper_reports.dart';
import 'package:sj_manager/core/core_classes/hill/hill.dart';
import 'package:sj_manager/core/psyche/psyche_utils.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/personal_coach_team.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';
import 'package:sj_manager/core/general_utils/id_generator.dart';

class DefaultSimulationDatabaseCreator {
  DefaultSimulationDatabaseCreator({
    required this.idGenerator,
  });

  final IdGenerator idGenerator;

  late IdsRepository<String> _idsRepo;
  late Iterable<SimulationJumper> _jumpers;
  late Iterable<Hill> _hills;
  late Iterable<CountryTeam> _countryTeams;
  late CountriesRepository _countries;
  late Iterable<SimulationSeason> _seasons;

  Future<SimulationDatabase> create(SimulationWizardOptions options) async {
    final mode = options.mode!;
    _idsRepo = IdsRepository();
    _hills = List.of(options.gameVariant!.hills);
    _countryTeams =
        options.gameVariant!.countryTeams.map(createCountryTeamEntityFromDbRecord);
    _countries = InMemoryCountriesRepository(countries: options.gameVariant!.countries);
    _seasons = List.of([options.gameVariant!.season]);
    const attributeHistoryLimit =
        31; // Max number of days in a month. The biggest need is when we create a monthly training report.
    final jumperRecords = List.of(options.gameVariant!.jumpers);

    _jumpers = jumperRecords.map(
      (dbRecord) {
        final jumperCountryTeam = _countryTeams
            .singleWhere((countryTeam) => countryTeam.country == dbRecord.country);
        return SimulationJumper(
          dateOfBirth: dbRecord.dateOfBirth,
          name: dbRecord.name,
          surname: dbRecord.surname,
          country: dbRecord.country,
          countryTeam: jumperCountryTeam,
          subteam: null,
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
          reports: JumperReports(
            levelReport: null,
            weeklyTrainingReport: null,
            monthlyTrainingReport: null,
            moraleRating: null,
            jumpsRating: null,
          ),
          stats: JumperStats(progressableAttributeHistory: {
            JumperAttributeType.takeoffQuality:
                JumperAttributeHistory.empty(limit: attributeHistoryLimit),
            JumperAttributeType.flightQuality:
                JumperAttributeHistory.empty(limit: attributeHistoryLimit),
            JumperAttributeType.landingQuality:
                JumperAttributeHistory.empty(limit: attributeHistoryLimit),
            JumperAttributeType.consistency:
                JumperAttributeHistory.empty(limit: attributeHistoryLimit),
            JumperAttributeType.form:
                JumperAttributeHistory.empty(limit: attributeHistoryLimit),
          }),
        );
      },
    ).toList();
    await _setUpIdsRepo();
    final personalCoachTeam = options.mode! == SimulationMode.personalCoach
        ? PersonalCoachTeam(jumpers: [], reports: null)
        : null;
    _idsRepo.register(personalCoachTeam, id: idGenerator.generate());
    final userSubteam = mode == SimulationMode.classicCoach
        ? _countryTeams
            .singleWhere((team) => team.country == options.countryTeam!.country)
            .getSubtem(options.subteamType!)
        : null;
    final earliestDate = options.gameVariant!.startDates.first;
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
      countries: _countries,
      seasons: _seasons,
      idsRepository: _idsRepo,
      actions: [
        for (var actionType in options.gameVariant!.actionDeadlines.keys)
          SimulationAction(
            type: actionType,
            deadline: options.gameVariant!.actionDeadlines[actionType],
            isCompleted: false,
          )
      ],
    );
  }

  Future<void> _setUpIdsRepo() async {
    void register(dynamic item) {
      _idsRepo.register(item, id: idGenerator.generate());
    }

    final items = [
      ..._jumpers,
      ..._hills,
      ..._countryTeams,
      ..._countries.getAll(),
      ..._seasons,
      for (var season in _seasons) ...[
        for (var eventSeries in season.eventSeries) ...[
          eventSeries,
          for (var competition in eventSeries.calendar.competitions) ...[
            competition,
            competition.rules,
            for (var score in competition.standings?.scores ?? <Score>[]) ...[
              score,
              score.subject,
              if (score is CompetitionJumperScore) ...[
                ...score.jumps,
                ...score.jumps.map((score) => score.jump),
              ],
              if (score is CompetitionTeamScore) ...[
                ...score.subscores,
                ...score.subscores
                    .whereType<CompetitionJumperScore>()
                    .map(
                      (jumperScore) => jumperScore.jumps,
                    )
                    .expand((jumps) => jumps),
              ],
              if (score is CompetitionJumpScore) score.jump,
            ],
          ],
          for (var classification in eventSeries.calendar.classifications) ...[
            classification,
            classification.rules,
            for (var score in classification.standings?.scores ?? <Score>[]) ...[
              score,
              score.subject,
            ],
          ],
        ],
      ],
    ];
    items.forEach(register);
  }
}
