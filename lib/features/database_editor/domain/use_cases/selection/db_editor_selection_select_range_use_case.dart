import 'package:sj_manager/features/database_editor/domain/repository/database_editor_selection_repository.dart';

class DbEditorSelectionSelectRangeUseCase {
  const DbEditorSelectionSelectRangeUseCase({
    required this.selectionRepository,
  });

  final DatabaseEditorSelectionRepository selectionRepository;

  Future<void> call(int start, int end) async {
    await selectionRepository.selectRange(start, end);
  }
}
