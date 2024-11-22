import 'package:sj_manager/features/database_editor/domain/repository/database_editor_selection_repository.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_items_repository.dart';

class UpdateDatabaseEditorItemUseCase<T> {
  const UpdateDatabaseEditorItemUseCase({
    required this.itemsRepository,
    required this.selectionRepository,
  });

  final DatabaseEditorItemsRepository<T> itemsRepository;
  final DatabaseEditorSelectionRepository selectionRepository;

  Future<void> call(T item) async {
    final selection = await selectionRepository.getSelection();
    if (selection.length != 1) {
      throw StateError(
          'To add an item, exactly one item should be selected (now ${selection.length} are selected)');
    }
    await itemsRepository.update(selection.single, item);
  }
}
