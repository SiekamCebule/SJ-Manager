import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';

class CompetitionTeam<T extends Team> extends Team with EquatableMixin {
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
}
