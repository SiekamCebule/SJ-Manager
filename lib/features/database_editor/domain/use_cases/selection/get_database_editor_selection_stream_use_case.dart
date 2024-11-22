import 'package:sj_manager/features/database_editor/domain/repository/database_editor_selection_repository.dart';

class GetDatabaseEditorSelectionStreamUseCase {
  const GetDatabaseEditorSelectionStreamUseCase({
    required this.selectionRepository,
  });

  final DatabaseEditorSelectionRepository selectionRepository;

  Future<Stream<Set<int>>> call() async {
    return await selectionRepository.stream;
  }
}
