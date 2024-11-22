import 'package:sj_manager/core/algorithms/filter/composite_filter.dart';
import 'package:sj_manager/core/algorithms/filter/filter.dart';
import 'package:sj_manager/core/database_editor/database_editor_filter_type.dart';
import 'package:sj_manager/core/database_editor/database_editor_items_type.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_filters_repository.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_items_type_repository.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_selection_repository.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_items_repository.dart';

class FilterDatabaseEditorItemsUseCase<T> {
  const FilterDatabaseEditorItemsUseCase({
    required this.itemsRepository,
    required this.selectionRepository,
    required this.filtersRepository,
    required this.itemsTypeRepository,
  });

  final DatabaseEditorItemsRepository<T> itemsRepository;
  final DatabaseEditorSelectionRepository selectionRepository;
  final DatabaseEditorFiltersRepository filtersRepository;
  final DatabaseEditorItemsTypeRepository itemsTypeRepository;

  Future<List<T>> call() async {
    final items = await itemsRepository.getAll();
    final itemsType = await itemsTypeRepository.get();
    final filter = CompositeFilter(
        filters: [
      if (itemsType == DatabaseEditorItemsType.maleJumper) ...[
        await filtersRepository.get(
          DatabaseEditorItemsType.maleJumper,
          DatabaseEditorFilterType.nameSurname,
        ),
        await filtersRepository.get(
          DatabaseEditorItemsType.maleJumper,
          DatabaseEditorFilterType.country,
        ),
      ],
      if (itemsType == DatabaseEditorItemsType.femaleJumper) ...[
        await filtersRepository.get(
          DatabaseEditorItemsType.femaleJumper,
          DatabaseEditorFilterType.nameSurname,
        ),
        await filtersRepository.get(
          DatabaseEditorItemsType.femaleJumper,
          DatabaseEditorFilterType.country,
        ),
      ],
    ].cast<Filter>());
    final filteredItems = filter(items).toList();
    return filteredItems.cast();
  }
}
