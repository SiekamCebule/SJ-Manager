import 'package:sj_manager/algorithms/subteam_appointments/overall/overall_appointments_algorithm.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/country_team/country_team.dart';
import 'package:sj_manager/models/user_db/team/subteam.dart';

class DefaultOverallAppointmentsAlgorithm implements OverallAppointmentsAlgorithm {
  @override
  Map<Subteam, List<Jumper>> createAppointments({required CountryTeam countryTeam}) {
    throw UnimplementedError();
  }
}
