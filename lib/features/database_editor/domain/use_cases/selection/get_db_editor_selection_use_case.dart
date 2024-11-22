import 'package:sj_manager/features/database_editor/domain/repository/database_editor_selection_repository.dart';

class GetDbEditorSelectionUseCase {
  const GetDbEditorSelectionUseCase({
    required this.selectionRepository,
  });

  final DatabaseEditorSelectionRepository selectionRepository;

  Future<Set<int>> call() async {
    return await selectionRepository.getSelection();
  }
}
