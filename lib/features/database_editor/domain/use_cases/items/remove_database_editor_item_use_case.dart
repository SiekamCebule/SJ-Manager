import 'package:sj_manager/features/database_editor/domain/repository/database_editor_selection_repository.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_items_repository.dart';

class RemoveDatabaseEditorItemUseCase<T> {
  const RemoveDatabaseEditorItemUseCase({
    required this.itemsRepository,
    required this.selectionRepository,
  });

  final DatabaseEditorItemsRepository<T> itemsRepository;
  final DatabaseEditorSelectionRepository selectionRepository;

  Future<void> call() async {
    final selection = await selectionRepository.getSelection();
    if (selection.isEmpty) {
      throw StateError('To remove an item, one or more item should be selected');
    }
    if (selection.length == 1) {
      await itemsRepository.removeAt(selection.single);
      await selectionRepository.deselect(selection.single);
      if (selection.length > 1) {
        await selectionRepository.selectOnly(selection.single - 1);
      }
    } else {
      final sortedSelection = List.of(selection)..sort((a, b) => a.compareTo(b));
      await itemsRepository.removeMany(sortedSelection.toSet());
      await selectionRepository.clear();
    }
  }
}
