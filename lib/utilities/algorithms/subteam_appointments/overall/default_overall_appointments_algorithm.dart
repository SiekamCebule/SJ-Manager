import 'package:sj_manager/utilities/algorithms/subteam_appointments/overall/overall_appointments_algorithm.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/core/classes/country_team/country_team.dart';
import 'package:sj_manager/domain/entities/simulation/team/subteam.dart';

class DefaultOverallAppointmentsAlgorithm implements OverallAppointmentsAlgorithm {
  @override
  Map<Subteam, List<JumperDbRecord>> createAppointments(
      {required CountryTeam countryTeam}) {
    throw UnimplementedError();
  }
}
