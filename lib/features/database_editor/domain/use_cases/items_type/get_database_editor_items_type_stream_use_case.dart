import 'package:sj_manager/core/database_editor/database_editor_items_type.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_items_type_repository.dart';

class GetDatabaseEditorItemsTypeStreamUseCase {
  const GetDatabaseEditorItemsTypeStreamUseCase({
    required this.itemsTypeRepository,
  });

  final DatabaseEditorItemsTypeRepository itemsTypeRepository;

  Future<Stream<DatabaseEditorItemsType>> call() async {
    return await itemsTypeRepository.stream;
  }
}
