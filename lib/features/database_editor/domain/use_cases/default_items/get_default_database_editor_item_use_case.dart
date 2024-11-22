import 'package:sj_manager/features/database_editor/domain/repository/database_editor_default_items_repository.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_items_type_repository.dart';

class GetDefaultDatabaseEditorItemUseCase {
  const GetDefaultDatabaseEditorItemUseCase({
    required this.defaultItemsRepository,
    required this.itemsTypeRepository,
  });

  final DatabaseEditorDefaultItemsRepository defaultItemsRepository;
  final DatabaseEditorItemsTypeRepository itemsTypeRepository;

  Future<dynamic> call() async {
    final itemsType = await itemsTypeRepository.get();
    return await defaultItemsRepository.get(itemsType);
  }
}
