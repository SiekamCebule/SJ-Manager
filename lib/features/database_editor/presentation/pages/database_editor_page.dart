import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/core/algorithms/filter/generic_filters.dart';
import 'package:sj_manager/core/classes/country/country.dart';
import 'package:sj_manager/core/countries/countries_repository/countries_repository.dart';
import 'package:sj_manager/core/countries/countries_repository/in_memory_countries_repository.dart';
import 'package:sj_manager/core/database_editor/database_editor_filter_type.dart';
import 'package:sj_manager/core/database_editor/database_editor_items_type.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/value_repo.dart';
import 'package:sj_manager/features/database_editor/data/data_sources/items_from_game_variant/jumpers_from_game_variant/female_jumpers_from_game_variant_data_source.dart';
import 'package:sj_manager/features/database_editor/data/data_sources/items_from_game_variant/jumpers_from_game_variant/male_jumpers_from_game_variant_data_source.dart';
import 'package:sj_manager/features/database_editor/data/repository/change_status/in_memory_database_editor_change_status_repository.dart';
import 'package:sj_manager/features/database_editor/data/repository/default_items/predefined_database_editor_default_items_repository.dart';
import 'package:sj_manager/features/database_editor/data/repository/filters/in_memory_database_editor_filters_repository.dart';
import 'package:sj_manager/features/database_editor/data/repository/items/json_database_editor_items_repository.dart';
import 'package:sj_manager/features/database_editor/data/repository/items_type/in_memory_database_editor_items_type_repository.dart';
import 'package:sj_manager/features/database_editor/data/repository/selection/in_memory_database_editor_selection_repository.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_change_status_repository.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_default_items_repository.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_filters_repository.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_items_repository.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_items_type_repository.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_selection_repository.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/change_status/get_database_editor_change_status_stream_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/change_status/mark_database_editor_as_changed_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/countries/get_all_database_editor_countries_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/countries/get_filtered_database_editor_countries_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/filtering/clear_database_editor_filters_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/filtering/get_all_database_editor_filters_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/filtering/get_database_editor_filter_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/filtering/get_database_editor_filters_stream_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/filtering/get_valid_database_editor_filters_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/filtering/set_database_editor_filter_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/items/add_database_editor_item_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/items/filter_database_editor_items_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/items/move_database_editor_item_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/items/remove_database_editor_item_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/items/save_database_editor_items_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/items/update_database_editor_item_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/items_type/get_database_editor_items_type_stream_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/items_type/get_database_editor_items_type_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/items_type/set_database_editor_items_type_by_index_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/items_type/set_database_editor_items_type_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/selection/db_editor_selection_clear_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/selection/db_editor_selection_select_only_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/selection/db_editor_selection_select_range_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/selection/db_editor_selection_toggle_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/selection/get_database_editor_selection_stream_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/selection/get_db_editor_selection_use_case.dart';
import 'package:sj_manager/features/database_editor/presentation/bloc/database_editor_change_status_cubit.dart';
import 'package:sj_manager/features/database_editor/presentation/bloc/database_editor_countries_cubit.dart';
import 'package:sj_manager/features/database_editor/presentation/bloc/database_editor_filters_cubit.dart';
import 'package:sj_manager/features/database_editor/presentation/bloc/database_editor_items_cubit.dart';
import 'package:sj_manager/features/database_editor/presentation/bloc/database_editor_items_type_cubit.dart';
import 'package:sj_manager/features/database_editor/presentation/bloc/database_editor_selection_cubit.dart';
import 'package:sj_manager/features/database_editor/presentation/pages/large/dialogs/database_editor_unsaved_changes_dialog.dart';
import 'package:sj_manager/features/database_editor/presentation/pages/large/widgets/appropriate_db_item_list_tile.dart';
import 'package:sj_manager/features/database_editor/presentation/pages/large/widgets/database_items_list.dart';
import 'package:sj_manager/features/game_variants/domain/entities/game_variant.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/presentation/ui/database_item_editors/jumper_editor.dart';
import 'package:sj_manager/presentation/ui/responsiveness/responsive_builder.dart';
import 'package:sj_manager/presentation/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/animations/animated_visibility.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/countries/countries_dropdown.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/database_item_images/db_item_image_generating_setup.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/filtering/search_text_field.dart';
import 'package:sj_manager/utilities/utils/colors.dart';
import 'package:sj_manager/utilities/utils/db_item_images.dart';
import 'package:sj_manager/utilities/utils/file_system.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/utilities/utils/show_dialog.dart';

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

class DatabaseEditorPage extends StatelessWidget {
  const DatabaseEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: defaultDbEditorRepositoryProviders(context),
      child: MultiBlocProvider(
        providers: defaultDbEditorBlocProviders(context),
        child: MultiProvider(
          providers: defaultDbEditorProviders(context),
          child: const ResponsiveBuilder(
            phone: _Large(),
            tablet: _Large(),
            desktop: _Large(),
            largeDesktop: _Large(),
          ),
        ),
      ),
    );
  }
}

List<BlocProvider> defaultDbEditorBlocProviders(BuildContext context) {
  final countriesRepository = context.read<CountriesRepository>();
  final defaultItemsRepository = context.read<DatabaseEditorDefaultItemsRepository>();
  final selectionRepository = context.read<DatabaseEditorSelectionRepository>();
  final changeStatusRepository = context.read<DatabaseEditorChangeStatusRepository>();
  final filtersRepository = context.read<DatabaseEditorFiltersRepository>();
  final itemsTypeRepository = context.read<DatabaseEditorItemsTypeRepository>();

  final maleJumpersRepository =
      context.read<DatabaseEditorItemsRepository<MaleJumperDbRecord>>();
  final femaleJumpersRepository =
      context.read<DatabaseEditorItemsRepository<FemaleJumperDbRecord>>();
  return [
    BlocProvider(
      create: (context) => DatabaseEditorChangeStatusCubit(
        getStreamUseCase: GetDatabaseEditorChangeStatusStreamUseCase(
          changeStatusRepository: changeStatusRepository,
        ),
        markAsChangedUseCase: MarkDatabaseEditorAsChangedUseCase(
          changeStatusRepository: changeStatusRepository,
        ),
      )..initialize(),
    ),
    BlocProvider(
      create: (context) => DatabaseEditorFiltersCubit(
        getFilterUseCase: GetDatabaseEditorFilterUseCase(
          filtersRepository: filtersRepository,
          itemsTypeRepository: itemsTypeRepository,
        ),
        getValidFiltersUseCase: GetValidDatabaseEditorFiltersUseCase(
          filtersRepository: filtersRepository,
          itemsTypeRepository: itemsTypeRepository,
        ),
        setFilterUseCase: SetDatabaseEditorFilterUseCase(
          filtersRepository: filtersRepository,
          itemsTypeRepository: itemsTypeRepository,
        ),
        getAllFiltersUseCase: GetAllDatabaseEditorFiltersUseCase(
          filtersRepository: filtersRepository,
        ),
        getItemsTypeUseCase: GetDatabaseEditorItemsTypeUseCase(
          itemsTypeRepository: itemsTypeRepository,
        ),
        clearFiltersUseCase: ClearDatabaseEditorFiltersUseCase(
          filtersRepository: filtersRepository,
        ),
      ),
    ),
    BlocProvider(
      create: (context) => DatabaseEditorItemsCubit(
        addItemUseCase: {
          DatabaseEditorItemsType.maleJumper: AddDatabaseEditorItemUseCase(
            defaultItemsRepository: defaultItemsRepository,
            itemsRepository: maleJumpersRepository,
            selectionRepository: selectionRepository,
            itemsTypeRepository: itemsTypeRepository,
            changeStatusRepository: changeStatusRepository,
          ),
          DatabaseEditorItemsType.femaleJumper: AddDatabaseEditorItemUseCase(
            defaultItemsRepository: defaultItemsRepository,
            itemsRepository: femaleJumpersRepository,
            selectionRepository: selectionRepository,
            itemsTypeRepository: itemsTypeRepository,
            changeStatusRepository: changeStatusRepository,
          ),
        },
        removeItemUseCase: {
          DatabaseEditorItemsType.maleJumper: RemoveDatabaseEditorItemUseCase(
            itemsRepository: maleJumpersRepository,
            selectionRepository: selectionRepository,
          ),
          DatabaseEditorItemsType.femaleJumper: RemoveDatabaseEditorItemUseCase(
            itemsRepository: femaleJumpersRepository,
            selectionRepository: selectionRepository,
          ),
        },
        updateItemUseCase: {
          DatabaseEditorItemsType.maleJumper: UpdateDatabaseEditorItemUseCase(
            itemsRepository: maleJumpersRepository,
            selectionRepository: selectionRepository,
          ),
          DatabaseEditorItemsType.femaleJumper: UpdateDatabaseEditorItemUseCase(
            itemsRepository: femaleJumpersRepository,
            selectionRepository: selectionRepository,
          ),
        },
        filterItemsUseCase: {
          DatabaseEditorItemsType.maleJumper: FilterDatabaseEditorItemsUseCase(
            itemsRepository: maleJumpersRepository,
            selectionRepository: selectionRepository,
            filtersRepository: filtersRepository,
            itemsTypeRepository: itemsTypeRepository,
          ),
          DatabaseEditorItemsType.femaleJumper: FilterDatabaseEditorItemsUseCase(
            itemsRepository: femaleJumpersRepository,
            selectionRepository: selectionRepository,
            filtersRepository: filtersRepository,
            itemsTypeRepository: itemsTypeRepository,
          ),
        },
        moveItemUseCase: {
          DatabaseEditorItemsType.maleJumper: MoveDatabaseEditorItemUseCase(
            itemsRepository: maleJumpersRepository,
            selectionRepository: selectionRepository,
            filtersRepository: filtersRepository,
          ),
          DatabaseEditorItemsType.femaleJumper: MoveDatabaseEditorItemUseCase(
            itemsRepository: femaleJumpersRepository,
            selectionRepository: selectionRepository,
            filtersRepository: filtersRepository,
          ),
        },
        saveItemsUseCase: {
          DatabaseEditorItemsType.maleJumper: SaveDatabaseEditorItemsUseCase(
            itemsRepository: maleJumpersRepository,
          ),
          DatabaseEditorItemsType.femaleJumper: SaveDatabaseEditorItemsUseCase(
            itemsRepository: femaleJumpersRepository,
          ),
        },
        getItemsTypeUseCase: GetDatabaseEditorItemsTypeUseCase(
          itemsTypeRepository: itemsTypeRepository,
        ),
        getFiltersStreamUseCase: GetDatabaseEditorFiltersStreamUseCase(
          filtersRepository: filtersRepository,
        ),
      )..initialize(),
    ),
    BlocProvider(
      create: (context) => DatabaseEditorCountriesCubit(
        getAllCountriesUseCase: GetAllDatabaseEditorCountriesUseCase(
          countriesRepository: countriesRepository,
        ),
        getFilteredCountriesUseCase: {
          DatabaseEditorItemsType.maleJumper: GetFilteredDatabaseEditorCountriesUseCase(
            countriesRepository: countriesRepository,
            itemsTypeRepository: itemsTypeRepository,
            itemsRepository: maleJumpersRepository,
          )
        },
      ),
    ),
    BlocProvider(
      create: (context) => DatabaseEditorItemsTypeCubit(
        getStreamUseCase: GetDatabaseEditorItemsTypeStreamUseCase(
          itemsTypeRepository: itemsTypeRepository,
        ),
        setItemsTypeUseCase: SetDatabaseEditorItemsTypeUseCase(
          itemsTypeRepository: itemsTypeRepository,
        ),
        setItemsTypeByIndexUseCase: SetDatabaseEditorItemsTypeByIndexUseCase(
          itemsTypeRepository: itemsTypeRepository,
        ),
      ),
    ),
    BlocProvider(
      create: (context) => DatabaseEditorSelectionCubit(
        getStreamUseCase: GetDatabaseEditorSelectionStreamUseCase(
          selectionRepository: selectionRepository,
        ),
        getSelectionUseCase: GetDbEditorSelectionUseCase(
          selectionRepository: selectionRepository,
        ),
        selectOnlyUseCase: DbEditorSelectionSelectOnlyUseCase(
          selectionRepository: selectionRepository,
        ),
        toggleUseCase: DbEditorSelectionToggleUseCase(
          selectionRepository: selectionRepository,
        ),
        selectRangeUseCase: DbEditorSelectionSelectRangeUseCase(
          selectionRepository: selectionRepository,
        ),
        clearUseCase: DbEditorSelectionClearUseCase(
          selectionRepository: selectionRepository,
        ),
      ),
    ),
  ];
}

List<Provider> defaultDbEditorRepositoryProviders(BuildContext context) {
  final gameVariant = context.read<GameVariant>();

  final countriesRepository = InMemoryCountriesRepository(countries: []); // TODO
  final changeStatusRepository =
      InMemoryDatabaseEditorChangeStatusRepository(initial: false);
  final defaultItemsRepository = PredefinedDatabaseEditorDefaultItemsRepository(
    countriesRepository: countriesRepository,
  );
  final filtersRepository = InMemoryDatabaseEditorFiltersRepository();
  final maleJumpersRepository = JsonDatabaseEditorItemsRepository<MaleJumperDbRecord>(
    itemsFromGameVariantDataSource: MaleJumpersFromGameVariantDataSource(
      gameVariant: gameVariant,
      saveVariant: (variant) async {
        // TODO: Save variant
      },
    ),
  );
  final femaleJumpersRepository = JsonDatabaseEditorItemsRepository(
    itemsFromGameVariantDataSource: FemaleJumpersFromGameVariantDataSource(
      gameVariant: gameVariant,
      saveVariant: (variant) async {
        // TODO: Save variant
      },
    ),
  );
  final itemsTypeRepository = InMemoryDatabaseEditorItemsTypeRepository(
      initial: DatabaseEditorItemsType.maleJumper);
  final selectionRepository = InMemoryDatabaseEditorSelectionRepository();

  return [
    Provider<DatabaseEditorChangeStatusRepository>(
      create: (context) => changeStatusRepository,
      dispose: (context, repo) => changeStatusRepository.dispose(),
    ),
    Provider<DatabaseEditorDefaultItemsRepository>(
      create: (context) => defaultItemsRepository,
    ),
    Provider<DatabaseEditorFiltersRepository>(
      create: (context) => filtersRepository,
      dispose: (context, value) => filtersRepository.dispose(),
    ),
    Provider<DatabaseEditorItemsRepository<MaleJumperDbRecord>>(
      create: (context) => maleJumpersRepository,
    ),
    Provider<DatabaseEditorItemsRepository<FemaleJumperDbRecord>>(
      create: (context) => femaleJumpersRepository,
    ),
    Provider<DatabaseEditorItemsTypeRepository>(
      create: (context) => itemsTypeRepository,
      dispose: (context, value) => itemsTypeRepository.dispose(),
    ),
    Provider<DatabaseEditorSelectionRepository>(
      create: (context) => selectionRepository,
      dispose: (context, value) => selectionRepository.dispose(),
    ),
  ];
}

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
        toFileName: jumperDbRecordImageName,
      );
    }),
  ];
}
