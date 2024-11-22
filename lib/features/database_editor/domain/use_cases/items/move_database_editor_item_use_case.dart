import 'package:sj_manager/features/database_editor/domain/repository/database_editor_filters_repository.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_selection_repository.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_items_repository.dart';

class MoveDatabaseEditorItemUseCase<T> {
  const MoveDatabaseEditorItemUseCase({
    required this.itemsRepository,
    required this.selectionRepository,
    required this.filtersRepository,
  });

  final DatabaseEditorItemsRepository<T> itemsRepository;
  final DatabaseEditorSelectionRepository selectionRepository;
  final DatabaseEditorFiltersRepository filtersRepository;

  Future<void> call(int index, int targetIndex) async {
    final selection = await selectionRepository.getSelection();
    if (selection.length != 1) {
      throw StateError(
          'To move an item, one or zero items should be selected (now ${selection.length} are selected)');
    }
    await itemsRepository.move(index, targetIndex);
    await selectionRepository.selectOnly(targetIndex);
  }
}
