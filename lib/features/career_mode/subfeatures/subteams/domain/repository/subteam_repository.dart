import 'package:sj_manager/core/core_classes/country_team/country_team.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam.dart';

abstract interface class SubteamRepository {
  Future<Iterable<Subteam>> getAll(CountryTeam countryTeam);
  Future<void> setCountrySubteams(
      {required CountryTeam countryTeam, required Iterable<Subteam> subteams});
  Future<void> setSubteam({required Subteam subteam});
}
