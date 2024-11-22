import 'package:async/async.dart';
import 'package:sj_manager/data/models/game_variant/game_variant_start_date.dart';
import 'package:sj_manager/core/classes/country_team/country_team.dart';
import 'package:sj_manager/domain/entities/simulation/team/subteam_type.dart';
import 'package:sj_manager/domain/entities/simulation/flow/simulation_mode.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/value_repo.dart';
import 'package:sj_manager/features/game_variants/domain/entities/game_variant.dart';

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
  final team = NullableValueRepo<CountryTeam?>(initial: null, init: true);
  final subteamType = NullableValueRepo<SubteamType?>(initial: null, init: true);
  final archiveEndedSeasonResults = NullableValueRepo<bool?>(initial: null, init: true);
  final showJumperSkills = NullableValueRepo<bool?>(initial: null, init: true);
  final showJumperDynamicParameters = NullableValueRepo<bool?>(initial: null, init: true);
  final simulationId = NullableValueRepo<String?>(initial: null, init: true);
  final simulationName = NullableValueRepo<String?>(initial: null, init: true);

  List<NullableValueRepo> get _repos => [
        mode,
        startDate,
        gameVariant,
        team,
        subteamType,
        archiveEndedSeasonResults,
        showJumperSkills,
        showJumperDynamicParameters,
        simulationId,
        simulationName,
      ];

  late final Stream<void> _changes;
  Stream<void> get changes => _changes;
}
