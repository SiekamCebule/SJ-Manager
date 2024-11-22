import 'package:sj_manager/features/database_editor/domain/repository/database_editor_change_status_repository.dart';

class MarkDatabaseEditorAsChangedUseCase {
  const MarkDatabaseEditorAsChangedUseCase({
    required this.changeStatusRepository,
  });

  final DatabaseEditorChangeStatusRepository changeStatusRepository;

  Future<dynamic> call() async {
    await changeStatusRepository.markAsChanged();
  }
}
