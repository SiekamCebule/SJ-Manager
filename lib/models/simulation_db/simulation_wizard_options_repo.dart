import 'package:async/async.dart';
import 'package:sj_manager/models/game_variants/game_variant.dart';
import 'package:sj_manager/models/game_variants/game_variant_start_date.dart';
import 'package:sj_manager/models/user_db/team/country_team/subteam_type.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/models/simulation_db/enums.dart';
import 'package:sj_manager/repositories/generic/value_repo.dart';

class SimulationWizardOptionsRepo {
  SimulationWizardOptionsRepo() {
    _changes = StreamGroup.merge(_repos.map(
      (repo) => repo.items,
    ));
  }

  void dispose() {
    for (final repo in _repos) {
      repo.dispose();
    }
  }

  final mode = NullableValueRepo<SimulationMode?>(initial: null, init: true);
  final startDate = NullableValueRepo<GameVariantStartDate?>(initial: null, init: true);
  final gameVariant = NullableValueRepo<GameVariant?>(initial: null, init: true);
  final team = NullableValueRepo<Team?>(initial: null, init: true);
  final subteamType = NullableValueRepo<SubteamType?>(initial: null, init: true);
  final archiveEndedSeasonResults = NullableValueRepo<bool?>(initial: null, init: true);
  final showJumperSkills = NullableValueRepo<bool?>(initial: null, init: true);
  final showJumperDynamicParameters = NullableValueRepo<bool?>(initial: null, init: true);

  List<NullableValueRepo> get _repos => [
        mode,
        startDate,
        gameVariant,
        team,
        subteamType,
        archiveEndedSeasonResults,
        showJumperSkills,
        showJumperDynamicParameters,
      ];

  late final Stream<void> _changes;
  Stream<void> get changes => _changes;
}
