import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/database/jumper/jumper_db_record.dart';
import 'package:sj_manager/models/database/team/team.dart';

class CompetitionTeam<T extends Team> extends Team with EquatableMixin {
  const CompetitionTeam({
    required this.parentTeam,
    required this.jumpers,
  });

  final T parentTeam;
  final List<JumperDbRecord> jumpers;

  CompetitionTeam<T> copyWith({T? parentTeam, List<JumperDbRecord>? jumpers}) {
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
