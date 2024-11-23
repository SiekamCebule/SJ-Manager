import 'package:sj_manager/core/core_classes/country/country.dart';
import 'package:sj_manager/features/game_variants/data/models/game_variant_database.dart/jumper/jumper_db_record_model.dart';
import 'package:sj_manager/core/core_classes/country_team/country_team.dart';

class GameVariantModel {
  const GameVariantModel({
    required this.id,
    required this.jumpers,
    required this.countries,
    required this.countryTeams,
  });

  final String id;
  final List<JumperDbRecordModel> jumpers;
  final List<Country> countries;
  final List<CountryTeam> countryTeams;

  GameVariantModel copyWith({
    String? id,
    List<JumperDbRecordModel>? jumpers,
    List<Country>? countries,
    List<CountryTeam>? countryTeams,
  }) {
    return GameVariantModel(
      id: id ?? this.id,
      jumpers: jumpers ?? List<JumperDbRecordModel>.from(this.jumpers),
      countries: countries ?? List<Country>.from(this.countries),
      countryTeams: countryTeams ?? List<CountryTeam>.from(this.countryTeams),
    );
  }
}
