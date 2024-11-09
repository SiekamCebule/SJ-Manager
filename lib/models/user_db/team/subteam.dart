import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/user_db/team/country_team/subteam_type.dart';
import 'package:sj_manager/models/user_db/team/team.dart';

class Subteam extends Team {
  const Subteam({
    required this.parentTeam,
    required this.type,
  });

  final Team parentTeam;
  final SubteamType type;

  Json toJson({
    required dynamic Function(Team team) serializeParentTeam,
  }) {
    return {
      'parentTeam': serializeParentTeam(parentTeam),
      'type': type.name,
    };
  }

  static Subteam fromJson({
    required Json json,
    required Team Function(dynamic json) parseParentTeam,
  }) {
    return Subteam(
      parentTeam: parseParentTeam(json['parentTeam']),
      type: SubteamType.values.singleWhere(
        (value) => value.name == json['type'],
      ),
    );
  }

  @override
  List<Object?> get props => [
        parentTeam,
        type,
      ];
}
