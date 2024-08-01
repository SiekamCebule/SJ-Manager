import 'package:async/async.dart';
import 'package:sj_manager/models/user_db/local_db_repo.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/models/simulation_db/enums.dart';
import 'package:sj_manager/repositories/generic/value_repo.dart';

class SimulationWizardOptionsRepo {
  SimulationWizardOptionsRepo() {
    _changes = StreamGroup.merge([
      mode.items,
      team.items,
      database.items,
      databaseIsExternal.items,
    ]);
  }

  final mode = NullableValueRepo<SimulationMode?>(initial: null, init: true);
  final team = NullableValueRepo<Team?>(initial: null, init: true);
  final database = ValueRepo<LocalDbRepo>();
  final databaseIsExternal = ValueRepo<bool>(initial: false);

  late final Stream<void> _changes;
  Stream<void> get changes => _changes;
}
