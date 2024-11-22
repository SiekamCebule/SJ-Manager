import 'package:sj_manager/features/database_editor/domain/repository/database_editor_items_repository.dart';

class SaveDatabaseEditorItemsUseCase<T> {
  const SaveDatabaseEditorItemsUseCase({
    required this.itemsRepository,
  });

  final DatabaseEditorItemsRepository<T> itemsRepository;

  Future<void> call() async {
    await itemsRepository.save();
  }
}
