import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';

class PersonalCoachTeam extends Team {
  const PersonalCoachTeam({
    required this.jumpers,
  });

  final List<Jumper> jumpers;

  static PersonalCoachTeam fromJson(
    Json json, {
    required Jumper Function(dynamic data) parseJumper,
  }) {
    final jumpersJson = json['jumpers'] as List;
    final jumpers = jumpersJson.map(parseJumper).toList();
    return PersonalCoachTeam(jumpers: jumpers);
  }

  Json toJson({
    required dynamic Function(Jumper jumper) serializeJumper,
  }) {
    final jumpersJson = jumpers.map(serializeJumper).toList();
    return {
      'jumpers': jumpersJson,
    };
  }

  @override
  List<Object?> get props => [super.props, jumpers];
}
