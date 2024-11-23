import 'package:sj_manager/core/general_utils/filtering/filter/filter.dart';
import 'package:sj_manager/core/database_editor/database_editor_filter_type.dart';
import 'package:sj_manager/core/database_editor/database_editor_items_type.dart';
import 'package:sj_manager/features/database_editor/domain/entities/filtering/database_editor_filters.dart';

abstract interface class DatabaseEditorFiltersRepository {
  Future<Filter?> get(
      DatabaseEditorItemsType itemsType, DatabaseEditorFilterType filterType);
  Future<DatabaseEditorFilters> getAll();
  Future<void> set(DatabaseEditorItemsType itemsType, DatabaseEditorFilterType filterType,
      Filter filter);
  Future<void> clear();
  Future<Stream<DatabaseEditorFilters>> get stream;
}
