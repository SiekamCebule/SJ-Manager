import 'package:sj_manager/features/database_editor/domain/entities/filtering/database_editor_filters.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_filters_repository.dart';

class GetAllDatabaseEditorFiltersUseCase {
  const GetAllDatabaseEditorFiltersUseCase({
    required this.filtersRepository,
  });

  final DatabaseEditorFiltersRepository filtersRepository;

  Future<DatabaseEditorFilters> call() async {
    return await filtersRepository.getAll();
  }
}
