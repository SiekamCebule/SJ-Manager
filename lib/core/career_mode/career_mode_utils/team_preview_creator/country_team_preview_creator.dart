import 'package:sj_manager/core/core_classes/country_team/country_team_db_record.dart';
import 'package:sj_manager/core/core_classes/hill/hill.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/core/core_classes/jumps/simple_jump_model.dart';

abstract class CountryTeamPreviewCreator {
  const CountryTeamPreviewCreator();

  Hill? largestHill(CountryTeamDbRecord team);
  int? stars(CountryTeamDbRecord team);
  SimpleJumpModel? record(CountryTeamDbRecord team);
  JumperDbRecord? bestJumper(CountryTeamDbRecord team);
  JumperDbRecord? risingStar(CountryTeamDbRecord team);
}
