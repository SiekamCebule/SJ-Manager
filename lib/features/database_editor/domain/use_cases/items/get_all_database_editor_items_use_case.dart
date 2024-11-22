import 'package:sj_manager/features/database_editor/domain/repository/database_editor_items_repository.dart';

class GetAllDatabaseEditorItemsUseCase<T> {
  const GetAllDatabaseEditorItemsUseCase({
    required this.itemsRepository,
  });

  final DatabaseEditorItemsRepository<T> itemsRepository;

  Future<List<T>> call() async {
    return await itemsRepository.getAll();
  }
}
