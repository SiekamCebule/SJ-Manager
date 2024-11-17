import 'package:sj_manager/features/game_variants/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/core/team/country_team/country_team.dart';
import 'package:sj_manager/domain/entities/simulation/team/subteam.dart';

abstract interface class OverallAppointmentsAlgorithm {
  const OverallAppointmentsAlgorithm();

  Map<Subteam, List<JumperDbRecord>> createAppointments(
      {required CountryTeam countryTeam});
}
