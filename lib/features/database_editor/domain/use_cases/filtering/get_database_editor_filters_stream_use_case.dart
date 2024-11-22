import 'package:sj_manager/features/database_editor/domain/entities/filtering/database_editor_filters.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_filters_repository.dart';

class GetDatabaseEditorFiltersStreamUseCase {
  const GetDatabaseEditorFiltersStreamUseCase({
    required this.filtersRepository,
  });

  final DatabaseEditorFiltersRepository filtersRepository;

  Future<Stream<DatabaseEditorFilters>> call() async {
    return await filtersRepository.stream;
  }
}
