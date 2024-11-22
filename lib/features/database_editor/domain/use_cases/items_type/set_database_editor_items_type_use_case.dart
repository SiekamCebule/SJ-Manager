import 'package:sj_manager/core/database_editor/database_editor_items_type.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_items_type_repository.dart';

class SetDatabaseEditorItemsTypeUseCase {
  const SetDatabaseEditorItemsTypeUseCase({
    required this.itemsTypeRepository,
  });

  final DatabaseEditorItemsTypeRepository itemsTypeRepository;

  Future<void> call(DatabaseEditorItemsType type) async {
    await itemsTypeRepository.set(type);
  }
}
