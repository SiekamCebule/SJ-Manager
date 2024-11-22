import 'package:sj_manager/features/database_editor/domain/repository/database_editor_items_type_repository.dart';

class SetDatabaseEditorItemsTypeByIndexUseCase {
  const SetDatabaseEditorItemsTypeByIndexUseCase({
    required this.itemsTypeRepository,
  });

  final DatabaseEditorItemsTypeRepository itemsTypeRepository;

  Future<void> call(int index) async {
    await itemsTypeRepository.setByIndex(index);
  }
}
