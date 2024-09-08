import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';

class TeamsRepo<T extends Team> extends ItemsRepo<T> {
  TeamsRepo({super.initial});
}
