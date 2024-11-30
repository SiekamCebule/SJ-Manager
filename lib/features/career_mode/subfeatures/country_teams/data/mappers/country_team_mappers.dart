import 'package:sj_manager/core/core_classes/country_team/country_team_db_record.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/country_team.dart';

CountryTeam createCountryTeamEntityFromDbRecord(CountryTeamDbRecord countryTeamDbRecord) {
  final countryTeam = CountryTeam(
    sex: countryTeamDbRecord.sex,
    country: countryTeamDbRecord.country,
    subteams: [],
  );
  countryTeam.subteams = [
    for (final subteamType in countryTeamDbRecord.facts.subteams)
      Subteam(
        parentTeam: countryTeam,
        type: subteamType,
        jumpers: [],
        limit: countryTeamDbRecord.facts.limitInSubteam[subteamType] ?? 10,
      )
  ];
  return countryTeam;
}
