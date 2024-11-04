import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';

class PersonalCoachTeam extends Team {
  const PersonalCoachTeam({
    required this.jumperIds,
  });

  final List<String> jumperIds;

  static PersonalCoachTeam fromJson(
    Json json, {
    required Jumper Function(dynamic data) parseJumper,
  }) {
    final jumperIds = json['jumperIds'] as List;
    return PersonalCoachTeam(jumperIds: jumperIds.cast());
  }

  Json toJson({
    required dynamic Function(Jumper jumper) serializeJumper,
  }) {
    return {
      'jumperIds': jumperIds,
    };
  }

  @override
  List<Object?> get props => [
        super.props,
        jumperIds,
      ];
}
