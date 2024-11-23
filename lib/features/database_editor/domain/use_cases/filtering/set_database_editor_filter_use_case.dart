import 'package:sj_manager/core/general_utils/filtering/filter/filter.dart';
import 'package:sj_manager/core/database_editor/database_editor_filter_type.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_filters_repository.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_items_type_repository.dart';

class SetDatabaseEditorFilterUseCase {
  const SetDatabaseEditorFilterUseCase({
    required this.filtersRepository,
    required this.itemsTypeRepository,
  });

  final DatabaseEditorFiltersRepository filtersRepository;
  final DatabaseEditorItemsTypeRepository itemsTypeRepository;

  Future<void> call(DatabaseEditorFilterType filterType, Filter filter) async {
    return await filtersRepository.set(
        await itemsTypeRepository.get(), filterType, filter);
  }
}
