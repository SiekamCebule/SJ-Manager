import 'package:sj_manager/features/database_editor/domain/repository/database_editor_selection_repository.dart';

class DbEditorSelectionClearUseCase {
  const DbEditorSelectionClearUseCase({
    required this.selectionRepository,
  });

  final DatabaseEditorSelectionRepository selectionRepository;

  Future<void> call() async {
    await selectionRepository.clear();
  }
}
