import 'package:sj_manager/core/general_utils/filtering/filter/filter.dart';
import 'package:sj_manager/core/database_editor/database_editor_filter_type.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_filters_repository.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_items_type_repository.dart';

class GetDatabaseEditorFilterUseCase {
  const GetDatabaseEditorFilterUseCase({
    required this.filtersRepository,
    required this.itemsTypeRepository,
  });

  final DatabaseEditorFiltersRepository filtersRepository;
  final DatabaseEditorItemsTypeRepository itemsTypeRepository;

  Future<Filter> call(DatabaseEditorFilterType filterType) async {
    return (await filtersRepository.get(await itemsTypeRepository.get(), filterType))!;
  }
}
