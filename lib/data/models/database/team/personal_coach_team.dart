import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/data/models/database/team/team.dart';
import 'package:sj_manager/data/models/simulation/jumper/simulation_jumper.dart';

class PersonalCoachTeam extends Team {
  PersonalCoachTeam({
    required this.jumpers,
  });

  List<SimulationJumper> jumpers;

  static PersonalCoachTeam fromJson(
    Json json, {
    required SimulationJumper Function(dynamic data) parseJumper,
  }) {
    final jumpersList = json['jumpers'] as List;
    final jumpers = jumpersList.map(parseJumper).toList();
    return PersonalCoachTeam(jumpers: jumpers);
  }

  Json toJson({
    required dynamic Function(SimulationJumper jumper) serializeJumper,
  }) {
    return {
      'jumpers': jumpers.map(serializeJumper).toList(),
    };
  }

  @override
  List<Object?> get props => [
        ...super.props,
        jumpers,
      ];
}
