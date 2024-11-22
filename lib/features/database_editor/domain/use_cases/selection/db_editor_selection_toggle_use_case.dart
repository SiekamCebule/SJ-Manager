import 'package:sj_manager/features/database_editor/domain/repository/database_editor_selection_repository.dart';

class DbEditorSelectionToggleUseCase {
  const DbEditorSelectionToggleUseCase({
    required this.selectionRepository,
  });

  final DatabaseEditorSelectionRepository selectionRepository;

  Future<void> call(int index) async {
    await selectionRepository.toggle(index);
  }
}
