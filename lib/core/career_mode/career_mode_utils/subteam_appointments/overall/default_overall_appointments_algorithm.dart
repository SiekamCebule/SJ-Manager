import 'package:sj_manager/core/career_mode/career_mode_utils/subteam_appointments/overall/overall_appointments_algorithm.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/core/core_classes/country_team/country_team.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/specific_teams/subteam.dart';

class DefaultOverallAppointmentsAlgorithm implements OverallAppointmentsAlgorithm {
  @override
  Map<Subteam, List<JumperDbRecord>> createAppointments(
      {required CountryTeam countryTeam}) {
    throw UnimplementedError();
  }
}
