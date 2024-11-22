import 'package:equatable/equatable.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/domain/entities/simulation/team/team.dart';

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
