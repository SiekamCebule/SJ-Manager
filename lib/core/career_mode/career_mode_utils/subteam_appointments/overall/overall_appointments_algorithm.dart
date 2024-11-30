import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/core/core_classes/country_team/country_team_db_record.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/country_team.dart';

abstract interface class OverallAppointmentsAlgorithm {
  const OverallAppointmentsAlgorithm();

  Map<Subteam, List<JumperDbRecord>> createAppointments(
      {required CountryTeam countryTeam});
}
