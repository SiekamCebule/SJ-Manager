import 'package:sj_manager/features/database_editor/domain/repository/database_editor_change_status_repository.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_default_items_repository.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_items_type_repository.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_selection_repository.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_items_repository.dart';

class AddDatabaseEditorItemUseCase<T> {
  const AddDatabaseEditorItemUseCase({
    required this.defaultItemsRepository,
    required this.itemsRepository,
    required this.selectionRepository,
    required this.itemsTypeRepository,
    required this.changeStatusRepository,
  });

  final DatabaseEditorDefaultItemsRepository defaultItemsRepository;
  final DatabaseEditorItemsRepository<T> itemsRepository;
  final DatabaseEditorSelectionRepository selectionRepository;
  final DatabaseEditorItemsTypeRepository itemsTypeRepository;
  final DatabaseEditorChangeStatusRepository changeStatusRepository;

  Future<void> call() async {
    final selection = await selectionRepository.getSelection();
    if (selection.length > 1) {
      throw StateError(
          'To add an item, one or zero items should be selected (now ${selection.length} are selected)');
    }
    final item = await defaultItemsRepository.get(await itemsTypeRepository.get());
    if (selection.length == 1) {
      await itemsRepository.add(item, selection.single + 1);
      await selectionRepository.deselect(selection.single);
      await selectionRepository.selectOnly(selection.single + 1);
    } else {
      await itemsRepository.add(item);
      await selectionRepository.selectOnly(0);
    }
  }
}
