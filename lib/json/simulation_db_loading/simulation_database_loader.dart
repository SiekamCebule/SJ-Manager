import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/countries.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/json/manual_json/json_team.dart';
import 'package:sj_manager/models/simulation_db/simulation_database.dart';
import 'package:sj_manager/models/simulation_db/simulation_season.dart';
import 'package:sj_manager/models/simulation_db/standings/score/score.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/countries/country_facts/teams_repo.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';
import 'package:sj_manager/utils/id_generator.dart';

class SimulationDatabaseParser<E, S extends Score>
    implements SimulationDbPartParser<SimulationDatabase> {
  SimulationDatabaseParser({
    required this.idsRepo,
    required this.idGenerator,
    required this.countryLoader,
    required this.seasonParser,
  });

  final ItemsIdsRepo idsRepo;
  final IdGenerator idGenerator;
  final JsonCountryLoader countryLoader;
  final SimulationDbPartParser<SimulationSeason> seasonParser;

  late Json _json;
  late ItemsRepo<Jumper> _jumpers;
  late ItemsRepo<Hill> _hills;
  late TeamsRepo _teams;
  late CountriesRepo _countries;
  late ItemsRepo<SimulationSeason> _seasons;

  @override
  SimulationDatabase parse(Json json) {
    _json = json;
    _loadCountries();
    _loadJumpers();
    _loadHill();
    _loadTeams();
    _loadSeasons();
    return SimulationDatabase(
      jumpers: _jumpers,
      hills: _hills,
      teams: _teams,
      countries: _countries,
      seasons: _seasons,
      idsRepo: idsRepo,
    );
  }

  void _loadCountries() {
    final countriesJson = _json['countries'] as List<Json>;
    final countries = countriesJson.map((json) => Country.fromJson(json));
    _countries = CountriesRepo(initial: countries.toList());
  }

  void _loadJumpers() {
    final jumpersJson = _json['jumpers'] as List<Json>;
    final jumpers = jumpersJson.map((json) {
      return Jumper.fromJson(json, countryLoader: countryLoader);
    });
    _jumpers = ItemsRepo(initial: jumpers.toList());
  }

  void _loadHill() {
    final hillsJson = _json['hills'] as List<Json>;
    final hills = hillsJson.map((json) {
      return Hill.fromJson(json,
          countryLoader: JsonCountryLoaderByCode(repo: _countries));
    });
    _hills = ItemsRepo(initial: hills.toList());
  }

  void _loadTeams() {
    final teamsJson = _json['teams'] as List<Json>;
    final teams = teamsJson.map((json) {
      return JsonTeamParser(countryLoader: countryLoader).parseTeam(json);
    });
    _teams = TeamsRepo(initial: teams.toList());
  }

  void _loadSeasons() {
    final seasonsJson = _json['seasons'] as List<Json>;
    final seasons = seasonsJson.map(
      (json) => seasonParser.parse(json),
    );
    _seasons = ItemsRepo(initial: seasons.toList());
  }
}
