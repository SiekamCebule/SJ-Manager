import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/user_db/country/team_facts.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';

class CompetitionTeam<T extends Team> with EquatableMixin implements Team {
  const CompetitionTeam({
    required this.parentTeam,
    required this.jumpers,
  });

  final T parentTeam;
  final List<Jumper> jumpers;

  CompetitionTeam<T> copyWith({T? parentTeam, List<Jumper>? jumpers}) {
    return CompetitionTeam(
      parentTeam: parentTeam ?? this.parentTeam,
      jumpers: jumpers ?? this.jumpers,
    );
  }

  @override
  List<Object?> get props => [
        parentTeam,
        jumpers,
      ];

  @override
  TeamFacts get facts =>
      throw UnsupportedError('CompetitionTeam cannot have facts at the moment');
}
