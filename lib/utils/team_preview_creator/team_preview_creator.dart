import 'package:sj_manager/models/db/hill/hill.dart';
import 'package:sj_manager/models/db/jumper/jumper.dart';
import 'package:sj_manager/models/db/jumps/simple_jump.dart';
import 'package:sj_manager/models/db/team/team.dart';

abstract class TeamPreviewCreator<T extends Team> {
  const TeamPreviewCreator();

  Hill? largestHill(T team);
  int? stars(T team);
  SimpleJump? record(T team);
  Jumper? bestJumper(T team);
  Jumper? risingStar(T team);
}
