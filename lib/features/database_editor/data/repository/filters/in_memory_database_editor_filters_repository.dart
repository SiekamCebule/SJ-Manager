import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/core/general_utils/filtering/filter/filter.dart';
import 'package:sj_manager/core/database_editor/database_editor_filter_type.dart';
import 'package:sj_manager/core/database_editor/database_editor_items_type.dart';
import 'package:sj_manager/features/database_editor/domain/entities/filtering/database_editor_filters.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_filters_repository.dart';

class InMemoryDatabaseEditorFiltersRepository implements DatabaseEditorFiltersRepository {
  var _filters = const DatabaseEditorFilters.empty();

  final _streamController = PublishSubject<DatabaseEditorFilters>();

  @override
  Future<Filter?> get(
      DatabaseEditorItemsType itemsType, DatabaseEditorFilterType filterType) async {
    return _filters.getFilter(itemsType, filterType);
  }

  @override
  Future<void> set(DatabaseEditorItemsType itemsType, DatabaseEditorFilterType filterType,
      Filter filter) async {
    _filters = _filters.setFilter(
      itemsType,
      filterType,
      filter,
    );
    _updateStream();
  }

  @override
  Future<void> clear() async {
    _filters = const DatabaseEditorFilters.empty();
    _updateStream();
  }

  @override
  Future<DatabaseEditorFilters> getAll() async => _filters;

  void _updateStream() => _streamController.add(_filters);

  @override
  Future<Stream<DatabaseEditorFilters>> get stream async => _streamController.stream;

  void dispose() {
    _streamController.close();
  }
}
