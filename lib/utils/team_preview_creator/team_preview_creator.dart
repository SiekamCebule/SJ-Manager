import 'package:sj_manager/models/database/hill/hill.dart';
import 'package:sj_manager/models/database/jumper/jumper_db_record.dart';
import 'package:sj_manager/models/database/jumps/simple_jump.dart';
import 'package:sj_manager/models/database/team/team.dart';

abstract class TeamPreviewCreator<T extends Team> {
  const TeamPreviewCreator();

  Hill? largestHill(T team);
  int? stars(T team);
  SimpleJump? record(T team);
  JumperDbRecord? bestJumper(T team);
  JumperDbRecord? risingStar(T team);
}
