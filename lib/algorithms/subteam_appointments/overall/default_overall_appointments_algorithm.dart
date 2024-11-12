import 'package:sj_manager/algorithms/subteam_appointments/overall/overall_appointments_algorithm.dart';
import 'package:sj_manager/models/database/jumper/jumper_db_record.dart';
import 'package:sj_manager/models/database/team/country_team/country_team.dart';
import 'package:sj_manager/models/database/team/subteam.dart';

class DefaultOverallAppointmentsAlgorithm implements OverallAppointmentsAlgorithm {
  @override
  Map<Subteam, List<JumperDbRecord>> createAppointments(
      {required CountryTeam countryTeam}) {
    throw UnimplementedError();
  }
}
