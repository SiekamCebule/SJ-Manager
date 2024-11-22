import 'package:sj_manager/features/database_editor/domain/repository/database_editor_filters_repository.dart';

class ClearDatabaseEditorFiltersUseCase {
  const ClearDatabaseEditorFiltersUseCase({
    required this.filtersRepository,
  });

  final DatabaseEditorFiltersRepository filtersRepository;

  Future<void> call() async {
    await filtersRepository.clear();
    /*return {
      for (final itemsType in allFilters.keys)
        itemsType: {
          for (final filterType in allFilters[itemsType]!.keys) filterType: NoFilter(),
        }
    };*/
  }
}
