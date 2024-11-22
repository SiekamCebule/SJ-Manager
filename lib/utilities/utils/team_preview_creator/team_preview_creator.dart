import 'package:sj_manager/domain/entities/game_variant/hill/hill.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/core/classes/jumps/simple_jump_model.dart';
import 'package:sj_manager/domain/entities/simulation/team/team.dart';

abstract class TeamPreviewCreator<T extends Team> {
  const TeamPreviewCreator();

  Hill? largestHill(T team);
  int? stars(T team);
  SimpleJumpModel? record(T team);
  JumperDbRecord? bestJumper(T team);
  JumperDbRecord? risingStar(T team);
}
