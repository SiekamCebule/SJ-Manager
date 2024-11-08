import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/country_team/country_team.dart';
import 'package:sj_manager/models/user_db/team/subteam.dart';

abstract interface class OverallAppointmentsAlgorithm {
  const OverallAppointmentsAlgorithm();

  Map<Subteam, List<Jumper>> createAppointments({required CountryTeam countryTeam});
}
