import 'package:sj_manager/models/user_db/team/country_team/subteam_type.dart';
import 'package:sj_manager/models/user_db/team/team.dart';

class Subteam extends Team {
  const Subteam({
    required this.parentTeam,
    required this.type,
  });

  final Team parentTeam;
  final SubteamType type;

  @override
  List<Object?> get props => [
        parentTeam,
        type,
      ];
}
