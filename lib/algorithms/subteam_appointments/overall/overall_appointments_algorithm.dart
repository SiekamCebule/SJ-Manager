import 'package:sj_manager/models/database/jumper/jumper_db_record.dart';
import 'package:sj_manager/models/database/team/country_team/country_team.dart';
import 'package:sj_manager/models/database/team/subteam.dart';

abstract interface class OverallAppointmentsAlgorithm {
  const OverallAppointmentsAlgorithm();

  Map<Subteam, List<JumperDbRecord>> createAppointments(
      {required CountryTeam countryTeam});
}
