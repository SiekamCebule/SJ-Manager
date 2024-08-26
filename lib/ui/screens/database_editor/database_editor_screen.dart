import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/bloc/database_editing/database_items_type_cubit.dart';
import 'package:sj_manager/bloc/database_editing/copied_local_db_cubit.dart';
import 'package:sj_manager/bloc/database_editing/change_status_cubit.dart';
import 'package:sj_manager/bloc/database_editing/local_db_filtered_items_cubit.dart';
import 'package:sj_manager/filters/filter.dart';
import 'package:sj_manager/filters/hills/hill_matching_algorithms.dart';
import 'package:sj_manager/filters/jumpers/jumper_matching_algorithms.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_individual_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_team_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/group_rules/team_competition_group_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules_preset.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/entities_limit.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/ko/ko_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/competition_score_creator/competition_score_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/competition_score_creator/concrete/individual/default_linear.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/competition_score_creator/concrete/team/default_linear.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/judges_creator/concrete/default.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/judges_creator/judges_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/jump_score_creator/concrete/default_classic.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/concrete/default_classic.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/concrete/default_random.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/concrete/default_with_pots.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/ko_groups_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_round_advancement_determinator/concrete/n_best.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_round_advancement_determinator/ko_round_advancement_determinator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/wind_averager/concrete/default_linear.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/wind_averager/concrete/default_weighted.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/wind_averager/wind_averager.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/competition_scores.dart';
import 'package:sj_manager/models/simulation_db/standings/standings_positions_map_creator/standings_positions_creator.dart';
import 'package:sj_manager/models/simulation_db/standings/standings_positions_map_creator/standings_positions_with_ex_aequos_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/jump_score_creator/jump_score_creator.dart';
import 'package:sj_manager/models/simulation_db/standings/standings_positions_map_creator/standings_positions_with_no_ex_aequo_creator.dart';
import 'package:sj_manager/models/simulation_db/standings/standings_positions_map_creator/standings_positions_with_shuffle_on_equal_positions_creator.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/hill/hill_type_by_size.dart';
import 'package:sj_manager/filters/hills/hills_filter.dart';
import 'package:sj_manager/l10n/hill_parameters_translations.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/filters/jumpers/jumpers_filter.dart';
import 'package:sj_manager/models/user_db/items_repos_registry.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/sex.dart';
import 'package:sj_manager/models/user_db/team/competition_team.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/database_editing/db_editing_avaiable_objects_repo.dart';
import 'package:sj_manager/repositories/database_editing/db_filters_repository.dart';
import 'package:sj_manager/repositories/database_editing/default_items_repository.dart';
import 'package:sj_manager/repositories/database_editing/selected_indexes_repository.dart';
import 'package:sj_manager/repositories/generic/value_repo.dart';
import 'package:sj_manager/ui/assets/icons.dart';
import 'package:sj_manager/ui/database_item_editors/default_competition_rules_preset_editor/default_competition_rules_preset_editor.dart';
import 'package:sj_manager/ui/database_item_editors/event_series_calendar_preset_thumbnail.dart';
import 'package:sj_manager/ui/database_item_editors/event_series_setup_editor.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_dropdown_field.dart';
import 'package:sj_manager/ui/database_item_editors/hill_editor.dart';
import 'package:sj_manager/ui/database_item_editors/jumper_editor.dart';
import 'package:sj_manager/ui/responsiveness/responsive_builder.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/reusable_widgets/animations/animated_visibility.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/countries_dropdown.dart';
import 'package:sj_manager/ui/reusable_widgets/filtering/search_text_field.dart';
import 'package:sj_manager/ui/reusable_widgets/menu_entries/predefined_reusable_entries.dart';
import 'package:sj_manager/ui/screens/database_editor/large/dialogs/database_editor_unsaved_changes_dialog.dart';
import 'package:sj_manager/ui/screens/database_editor/large/dialogs/database_successfully_saved_dialog.dart';
import 'package:sj_manager/ui/screens/database_editor/large/dialogs/selected_db_is_not_valid_dialog.dart';
import 'package:sj_manager/ui/screens/database_editor/large/widgets/appropriate_db_item_list_tile.dart';
import 'package:sj_manager/ui/screens/database_editor/large/widgets/database_items_list.dart';
import 'package:sj_manager/utils/colors.dart';
import 'package:sj_manager/utils/file_system.dart';
import 'package:sj_manager/utils/filtering_countries.dart';
import 'package:sj_manager/utils/single_where_type.dart';

part 'large/__large.dart';
part 'large/widgets/__body.dart';
part 'large/widgets/__appropriate_item_editor.dart';
part 'large/widgets/__app_bar.dart';
part 'large/widgets/__bottom_app_bar.dart';
part 'large/widgets/filters/__for_jumpers.dart';
part 'large/widgets/filters/__for_hills.dart';
part 'large/widgets/__add_fab.dart';
part 'large/widgets/__remove_fab.dart';
part 'large/widgets/__items_list.dart';
part 'large/widgets/__animated_editor.dart';
part 'large/widgets/__save_as_button.dart';
part 'large/widgets/__load_button.dart';

class DatabaseEditorScreen extends StatelessWidget {
  const DatabaseEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translator = translate(context);
    return MultiRepositoryProvider(
      providers: [
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
            DbEditingAvaiableObjectConfig<
                CompetitionScoreCreator<CompetitionJumperScore>>(
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
        RepositoryProvider(create: (context) {
          final noneCountry =
              (context.read<ItemsReposRegistry>().get<Country>() as CountriesRepo).none;
          final koRoundRules = KoRoundRules(
            advancementDeterminator: context
                .read<DbEditingAvailableObjectsRepo<KoRoundAdvancementDeterminator>>()
                .getObject('n_best'),
            advancementCount: 1,
            koGroupsCreator: context
                .read<DbEditingAvailableObjectsRepo<KoGroupsCreator>>()
                .getObject('classic'),
            groupSize: 2,
          );
          final defaultIndividualRoundRules = DefaultIndividualCompetitionRoundRules(
            limit: const EntitiesLimit.soft(50),
            bibsAreReassigned: false,
            startlistIsSorted: false,
            gateCanChange: true,
            gateCompensationsEnabled: true,
            windCompensationsEnabled: true,
            windAverager: context
                .read<DbEditingAvailableObjectsRepo<WindAverager>>()
                .getObject('weighted_classic'),
            inrunLightsEnabled: true,
            dsqEnabled: true,
            positionsCreator: context
                .read<DbEditingAvailableObjectsRepo<StandingsPositionsCreator>>()
                .getObject('with_ex_aequos'),
            ruleOf95HsFallEnabled: true,
            judgesCount: 5,
            judgesCreator: context
                .read<DbEditingAvailableObjectsRepo<JudgesCreator>>()
                .getObject('default'),
            significantJudgesCount: 3,
            competitionScoreCreator: context
                    .read<DbEditingAvailableObjectsRepo<CompetitionScoreCreator>>()
                    .getObject('classic_individual')
                as CompetitionScoreCreator<CompetitionJumperScore>,
            jumpScoreCreator: context
                .read<DbEditingAvailableObjectsRepo<JumpScoreCreator>>()
                .getObject('classic'),
            koRules: null,
          );
          const defaultGroupRules = TeamCompetitionGroupRules(sortStartList: false);
          final defaultTeamRoundRules = DefaultTeamCompetitionRoundRules(
            limit: const EntitiesLimit.soft(50),
            bibsAreReassigned: true,
            startlistIsSorted: false,
            gateCanChange: true,
            gateCompensationsEnabled: true,
            windCompensationsEnabled: true,
            windAverager: context
                .read<DbEditingAvailableObjectsRepo<WindAverager>>()
                .getObject('weighted_classic'),
            inrunLightsEnabled: true,
            dsqEnabled: true,
            positionsCreator: context
                .read<DbEditingAvailableObjectsRepo<StandingsPositionsCreator>>()
                .getObject('with_ex_aequos'),
            ruleOf95HsFallEnabled: true,
            judgesCount: 5,
            judgesCreator: context
                .read<DbEditingAvailableObjectsRepo<JudgesCreator>>()
                .getObject('default'),
            significantJudgesCount: 3,
            competitionScoreCreator: context
                    .read<DbEditingAvailableObjectsRepo<CompetitionScoreCreator>>()
                    .getObject('classic_team')
                as CompetitionScoreCreator<CompetitionTeamScore<CompetitionTeam>>,
            jumpScoreCreator: context
                .read<DbEditingAvailableObjectsRepo<JumpScoreCreator>>()
                .getObject('classic'),
            koRules: null,
            groups: const [
              TeamCompetitionGroupRules(sortStartList: false),
              TeamCompetitionGroupRules(sortStartList: false),
              TeamCompetitionGroupRules(sortStartList: false),
              TeamCompetitionGroupRules(sortStartList: false),
            ],
          );

          final defaultCompetitionRules =
              DefaultCompetitionRules(rounds: [defaultIndividualRoundRules]);
          return DefaultItemsRepo(
            initial: {
              FemaleJumper.empty(country: noneCountry),
              MaleJumper.empty(country: noneCountry),
              Hill.empty(country: noneCountry),
              const EventSeriesSetup.empty(),
              const EventSeriesCalendarPreset.empty().copyWith(name: translator.unnamed),
              DefaultCompetitionRulesPreset<dynamic>(
                name: translator.unnamed,
                rules: defaultCompetitionRules,
              ),
              defaultIndividualRoundRules,
              defaultGroupRules,
              defaultTeamRoundRules,
              koRoundRules
            },
          );
        }),
      ],
      child: const ResponsiveBuilder(
        phone: _Large(),
        tablet: _Large(),
        desktop: _Large(),
        largeDesktop: _Large(),
      ),
    );
  }
}
