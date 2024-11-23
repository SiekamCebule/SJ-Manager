import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/subteam_type.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/team.dart';

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
