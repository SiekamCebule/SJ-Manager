import 'package:sj_manager/models/simulation_db/simulation_database.dart';
import 'package:sj_manager/models/simulation_db/simulation_season.dart';
import 'package:sj_manager/models/simulation_db/simulation_wizard_options_repo.dart';
import 'package:sj_manager/models/simulation_db/standings/score/details/classification_score_details.dart';
import 'package:sj_manager/models/simulation_db/standings/score/details/competition_score_details.dart';
import 'package:sj_manager/models/simulation_db/standings/score/details/jump_score_details.dart';
import 'package:sj_manager/models/simulation_db/standings/score/score.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/countries/country_facts/teams_repo.dart';
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
  late TeamsRepo<Team> _teams;
  late CountriesRepo _countries;
  late ItemsRepo<SimulationSeason> _seasons;

  SimulationDatabase create(SimulationWizardOptionsRepo options) {
    _idsRepo = ItemsIdsRepo();
    _jumpers = ItemsRepo(initial: options.gameVariant.last!.jumpers);
    _hills = ItemsRepo(initial: options.gameVariant.last!.hills);
    _teams = TeamsRepo(initial: options.gameVariant.last!.teams);
    _countries = CountriesRepo(initial: options.gameVariant.last!.countries);
    _seasons = ItemsRepo(initial: [options.gameVariant.last!.season]);
    _setUpIdsRepo();
    return SimulationDatabase(
      mode: options.mode.last!,
      jumpers: _jumpers,
      hills: _hills,
      teams: _teams,
      countries: _countries,
      seasons: _seasons,
      idsRepo: _idsRepo,
    );
  }

  void _setUpIdsRepo() {
    void register(dynamic item) {
      _idsRepo.register(item, id: idGenerator.generate());
    }

    final items = [
      ..._jumpers.last,
      ..._hills.last,
      ..._teams.last,
      ..._countries.last,
      ..._seasons.last,
      for (var season in _seasons.last)
        for (var eventSeries in season.eventSeries) ...[
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
    ];
    items.forEach(register);
  }
}
