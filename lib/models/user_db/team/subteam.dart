import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';

class Subteam extends Team {
  const Subteam({
    required this.parentTeam,
    required this.label,
    required this.jumpers,
  });

  final Team parentTeam;
  final String label; // A, B, C, JUNIOR, SUPER, BASE...
  final List<Jumper> jumpers;

  @override
  List<Object?> get props => [
        parentTeam,
        label,
        jumpers,
      ];
}
