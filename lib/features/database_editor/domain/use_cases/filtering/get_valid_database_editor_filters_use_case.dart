import 'package:sj_manager/core/general_utils/filtering/filter/filter.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_filters_repository.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_items_type_repository.dart';

class GetValidDatabaseEditorFiltersUseCase {
  const GetValidDatabaseEditorFiltersUseCase({
    required this.filtersRepository,
    required this.itemsTypeRepository,
  });

  final DatabaseEditorFiltersRepository filtersRepository;
  final DatabaseEditorItemsTypeRepository itemsTypeRepository;

  Future<Set<Filter>> call() async {
    final itemsType = await itemsTypeRepository.get();
    final filters = await filtersRepository.getAll();
    return filters.forItems(itemsType)!.values.where((filter) => filter.isValid).toSet();
  }
}
