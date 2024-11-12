import 'dart:async';
import 'dart:math';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/bloc/database_editing/database_editor_countries_cubit.dart';
import 'package:sj_manager/bloc/database_editing/state/database_editor_countries_state.dart';
import 'package:sj_manager/bloc/database_editing/state/database_items_state.dart';
import 'package:sj_manager/bloc/database_editing/local_database_cubit.dart';
import 'package:sj_manager/bloc/database_editing/change_status_cubit.dart';
import 'package:sj_manager/bloc/database_editing/database_items_cubit.dart';
import 'package:sj_manager/filters/filter.dart';
import 'package:sj_manager/filters/jumpers/jumper_matching_algorithms.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/models/database/items_repos_registry.dart';
import 'package:sj_manager/models/game_variants/game_variant.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/competition_score_creator/competition_score_creator.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/competition_score_creator/concrete/individual/default_linear.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/competition_score_creator/concrete/team/default_linear.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/judges_creator/concrete/default.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/judges_creator/judges_creator.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/jump_score_creator/concrete/default_classic.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/ko_group_creator.dart/concrete/default_classic.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/ko_group_creator.dart/concrete/default_random.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/ko_group_creator.dart/concrete/default_with_pots.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/ko_group_creator.dart/ko_groups_creator.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/ko_round_advancement_determinator/concrete/n_best.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/ko_round_advancement_determinator/ko_round_advancement_determinator.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/wind_averager/concrete/default_linear.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/wind_averager/concrete/default_weighted.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/wind_averager/wind_averager.dart';
import 'package:sj_manager/models/simulation/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/models/simulation/standings/score/typedefs.dart';
import 'package:sj_manager/models/simulation/standings/standings_positions_map_creator/standings_positions_creator.dart';
import 'package:sj_manager/models/simulation/standings/standings_positions_map_creator/standings_positions_with_ex_aequos_creator.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/jump_score_creator/jump_score_creator.dart';
import 'package:sj_manager/models/simulation/standings/standings_positions_map_creator/standings_positions_with_no_ex_aequo_creator.dart';
import 'package:sj_manager/models/simulation/standings/standings_positions_map_creator/standings_positions_with_shuffle_on_equal_positions_creator.dart';
import 'package:sj_manager/models/database/hill/hill.dart';
import 'package:sj_manager/models/database/country/country.dart';
import 'package:sj_manager/models/database/jumper/jumper_db_record.dart';
import 'package:sj_manager/models/database/team/country_team/country_team.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/database_editing/db_editing_avaiable_objects_repo.dart';
import 'package:sj_manager/repositories/database_editing/db_filters_repo.dart';
import 'package:sj_manager/repositories/database_editing/default_items_repository.dart';
import 'package:sj_manager/repositories/database_editing/event_series_setup_ids_repo.dart';
import 'package:sj_manager/repositories/database_editing/selected_indexes_repository.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';
import 'package:sj_manager/repositories/generic/value_repo.dart';
import 'package:sj_manager/ui/database_item_editors/jumper_editor.dart';
import 'package:sj_manager/ui/responsiveness/responsive_builder.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/reusable_widgets/animations/animated_visibility.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/countries_dropdown.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/db_item_image_generating_setup.dart';
import 'package:sj_manager/ui/reusable_widgets/filtering/search_text_field.dart';
import 'package:sj_manager/ui/screens/database_editor/large/dialogs/database_editor_unsaved_changes_dialog.dart';
import 'package:sj_manager/ui/screens/database_editor/large/widgets/appropriate_db_item_list_tile.dart';
import 'package:sj_manager/ui/screens/database_editor/large/widgets/database_items_list.dart';
import 'package:sj_manager/utils/colors.dart';
import 'package:sj_manager/utils/db_item_images.dart';
import 'package:sj_manager/utils/file_system.dart';
import 'package:sj_manager/utils/show_dialog.dart';

part 'large/__large.dart';
part 'large/widgets/__items_and_editor_row.dart';
part 'large/widgets/appropriate_item_editor.dart';
part 'large/widgets/__app_bar.dart';
part 'large/widgets/__bottom_app_bar.dart';
part 'large/widgets/filters/__for_jumpers.dart';
part 'large/widgets/__add_fab.dart';
part 'large/widgets/__remove_fab.dart';
part 'large/widgets/__items_list.dart';
part 'large/widgets/db_editor_animated_editor.dart';
part 'large/widgets/db_editor_items_list_empty_state_body.dart';
part 'large/widgets/__items_list_non_empty_state_body.dart';
part 'large/widgets/item_editor_empty_state_body.dart';
part 'large/widgets/item_editor_non_empty_state_body.dart';
part 'large/widgets/__main_body.dart';

List<Provider> defaultDbEditorProviders(BuildContext context) {
  final gameVariant = context.read<GameVariant>();
  return [
    Provider(create: (context) {
      return DbItemImageGeneratingSetup<JumperDbRecord>(
        imagesDirectory: simulationDirectory(
          pathsCache: context.read(),
          simulationId: gameVariant.id,
          directoryName: 'jumper_images',
        ),
        toFileName: jumperImageName,
      );
    }),
    Provider(create: (context) {
      return DbItemImageGeneratingSetup<Hill>(
        imagesDirectory: simulationDirectory(
          pathsCache: context.read(),
          simulationId: gameVariant.id,
          directoryName: 'hill_images',
        ),
        toFileName: hillImageName,
      );
    }),
    RepositoryProvider<DbEditingAvailableObjectsRepo<StandingsPositionsCreator>>(
      create: (context) => DbEditingAvailableObjectsRepo(initial: [
        DbEditingAvaiableObjectConfig(
          key: 'with_ex_aequos',
          displayName: 'Z Miejscami Ex Aequo',
          object: StandingsPositionsWithExAequosCreator(),
        ),
        DbEditingAvaiableObjectConfig(
          key: 'without_ex_aequos',
          displayName: 'Bez Miejsc Ex Aequo',
          object: StandingsPositionsWithNoExAequoCreator(),
        ),
        DbEditingAvaiableObjectConfig(
          key: 'with_shuffle_on_equal_positions',
          displayName: 'Losowa Kolejność Przy Ex Aequo',
          object: StandingsPositionsWithShuffleOnEqualPositionsCreator(),
        ),
      ]),
    ),
    RepositoryProvider<DbEditingAvailableObjectsRepo<JumpScoreCreator>>(
      create: (context) => DbEditingAvailableObjectsRepo(initial: [
        DbEditingAvaiableObjectConfig(
          key: 'classic',
          displayName: 'Klasycznie',
          object: DefaultClassicJumpScoreCreator(),
        ),
      ]),
    ),
    RepositoryProvider<DbEditingAvailableObjectsRepo<WindAverager>>(
      create: (context) => DbEditingAvailableObjectsRepo(initial: [
        DbEditingAvaiableObjectConfig(
          key: 'linear_classic',
          displayName: 'Liniowo (Klasyczne)',
          object: DefaultLinearWindAverager(
            skipNonAchievedSensors: true,
            computePreciselyPartialMeasurement: false,
          ),
        ),
        DbEditingAvaiableObjectConfig(
          key: 'linear_advanced',
          displayName: 'Liniowo (Zaawansowane)',
          object: DefaultLinearWindAverager(
            skipNonAchievedSensors: true,
            computePreciselyPartialMeasurement: true,
          ),
        ),
        DbEditingAvaiableObjectConfig(
          key: 'linear_simple',
          displayName: 'Liniowo (Proste)',
          object: DefaultLinearWindAverager(
            skipNonAchievedSensors: false,
            computePreciselyPartialMeasurement: false,
          ),
        ),
        DbEditingAvaiableObjectConfig(
          key: 'weighted_classic',
          displayName: 'Wagowo (Klasyczne)',
          object: DefaultWeightedWindAverager(
            skipNonAchievedSensors: true,
            computePreciselyPartialMeasurement: false,
          ),
        ),
        DbEditingAvaiableObjectConfig(
          key: 'weighted_advanced',
          displayName: 'Wagowo (Zaawansowane)',
          object: DefaultWeightedWindAverager(
            skipNonAchievedSensors: true,
            computePreciselyPartialMeasurement: true,
          ),
        ),
        DbEditingAvaiableObjectConfig(
          key: 'weighted_simple',
          displayName: 'Wagowo (Proste)',
          object: DefaultWeightedWindAverager(
            skipNonAchievedSensors: false,
            computePreciselyPartialMeasurement: false,
          ),
        ),
      ]),
    ),
    RepositoryProvider<DbEditingAvailableObjectsRepo<CompetitionScoreCreator>>(
      create: (context) => DbEditingAvailableObjectsRepo(initial: [
        DbEditingAvaiableObjectConfig<CompetitionScoreCreator<CompetitionJumperScore>>(
          key: 'classic_individual',
          displayName: 'Indywidualnie (Klasycznie)',
          object: DefaultLinearIndividualCompetitionScoreCreator(),
        ),
        DbEditingAvaiableObjectConfig<CompetitionScoreCreator<CompetitionTeamScore>>(
          key: 'classic_team',
          displayName: 'Drużynowo (Klasycznie)',
          object: DefaultLinearTeamCompetitionScoreCreator(),
        ),
      ]),
    ),
    RepositoryProvider<DbEditingAvailableObjectsRepo<KoRoundAdvancementDeterminator>>(
      create: (context) => const DbEditingAvailableObjectsRepo(initial: [
        DbEditingAvaiableObjectConfig(
          key: 'n_best',
          displayName: 'Awansuje N najlepszych',
          object: NBestKoRoundAdvancementDeterminator(),
        ),
      ]),
    ),
    RepositoryProvider<DbEditingAvailableObjectsRepo<KoGroupsCreator>>(
      create: (context) => DbEditingAvailableObjectsRepo(initial: [
        DbEditingAvaiableObjectConfig(
          key: 'classic',
          displayName: 'Klasyczne pary',
          object: DefaultClassicKoGroupsCreator(),
        ),
        DbEditingAvaiableObjectConfig(
          key: 'random',
          displayName: 'Losowe grupy',
          object: DefaultRandomKoGroupsCreator(),
        ),
        DbEditingAvaiableObjectConfig(
          key: 'pots',
          displayName: 'Losowanie z koszyków',
          object: DefaultPotsKoGroupsCreator(),
        ),
      ]),
    ),
    RepositoryProvider<DbEditingAvailableObjectsRepo<JudgesCreator>>(
      create: (context) => DbEditingAvailableObjectsRepo(initial: [
        DbEditingAvaiableObjectConfig(
          key: 'default',
          displayName: 'Domyślnie',
          object: DefaultJudgesCreator(),
        ),
      ]),
    ),
    RepositoryProvider<DefaultItemsRepo>(create: (context) {
      final tempCountriesRepo =
          CountriesRepo(countries: context.read<GameVariant>().countries);
      final noneCountry = tempCountriesRepo.none;
      return DefaultItemsRepo(
        initial: {
          FemaleJumperDbRecord.empty(country: noneCountry),
          MaleJumperDbRecord.empty(country: noneCountry),
        },
      );
    }),
  ];
}

class DatabaseEditorScreen extends StatelessWidget {
  const DatabaseEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: defaultDbEditorProviders(context),
      child: const ResponsiveBuilder(
        phone: _Large(),
        tablet: _Large(),
        desktop: _Large(),
        largeDesktop: _Large(),
      ),
    );
  }
}
