import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/core/general_utils/filtering/filter/filter.dart';
import 'package:sj_manager/core/database_editor/database_editor_filter_type.dart';
import 'package:sj_manager/core/database_editor/database_editor_items_type.dart';
import 'package:sj_manager/features/database_editor/domain/entities/filtering/database_editor_filters.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/filtering/clear_database_editor_filters_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/filtering/get_all_database_editor_filters_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/filtering/get_database_editor_filter_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/filtering/get_valid_database_editor_filters_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/filtering/set_database_editor_filter_use_case.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/items_type/get_database_editor_items_type_use_case.dart';

class DatabaseEditorFiltersCubit extends Cubit<DatabaseEditorFiltersState> {
  DatabaseEditorFiltersCubit({
    required this.getFilterUseCase,
    required this.getValidFiltersUseCase,
    required this.setFilterUseCase,
    required this.getAllFiltersUseCase,
    required this.getItemsTypeUseCase,
    required this.clearFiltersUseCase,
  }) : super(initial);

  static const initial = DatabaseEditorFiltersState(
    validFilterExists: false,
    filters: DatabaseEditorFilters.empty(),
  );

  final GetDatabaseEditorFilterUseCase getFilterUseCase;
  final GetAllDatabaseEditorFiltersUseCase getAllFiltersUseCase;
  final GetValidDatabaseEditorFiltersUseCase getValidFiltersUseCase;
  final SetDatabaseEditorFilterUseCase setFilterUseCase;
  final GetDatabaseEditorItemsTypeUseCase getItemsTypeUseCase;
  final ClearDatabaseEditorFiltersUseCase clearFiltersUseCase;

  Future<void> clearFilters() async {
    await clearFiltersUseCase();
    emit(DatabaseEditorFiltersState(
      validFilterExists: false,
      filters: await getAllFiltersUseCase(),
    ));
  }

  Future<void> setFilter(DatabaseEditorItemsType itemType,
      DatabaseEditorFilterType filterType, Filter filter) async {
    await setFilterUseCase(filterType, filter);
    final validFilters = await getValidFiltersUseCase();
    emit(DatabaseEditorFiltersState(
      validFilterExists: validFilters.isNotEmpty,
      filters: await getAllFiltersUseCase(),
    ));
  }
}

class DatabaseEditorFiltersState extends Equatable {
  const DatabaseEditorFiltersState({
    required this.validFilterExists,
    required this.filters,
  });

  final bool validFilterExists;
  final DatabaseEditorFilters filters;

  @override
  List<Object?> get props => [validFilterExists, filters];
}
