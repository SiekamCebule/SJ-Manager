import 'package:sj_manager/core/algorithms/filter/filter.dart';
import 'package:sj_manager/core/database_editor/database_editor_filter_type.dart';
import 'package:sj_manager/core/database_editor/database_editor_items_type.dart';

class DatabaseEditorFilters {
  const DatabaseEditorFilters({
    required this.filters,
  });

  const DatabaseEditorFilters.empty() : this(filters: const {});

  final Map<DatabaseEditorItemsType, Map<DatabaseEditorFilterType, Filter>> filters;
  Map<DatabaseEditorFilterType, Filter>? forItems(DatabaseEditorItemsType itemsType) {
    return filters[itemsType];
  }

  Filter? getFilter(
      DatabaseEditorItemsType itemsType, DatabaseEditorFilterType filterType) {
    return forItems(itemsType)?[filterType];
  }

  DatabaseEditorFilters setFilter(DatabaseEditorItemsType itemsType,
      DatabaseEditorFilterType filterType, Filter filter) {
    final newFilters = Map.of(filters)..[itemsType]![filterType] = filter;
    return DatabaseEditorFilters(filters: newFilters);
  }
}
