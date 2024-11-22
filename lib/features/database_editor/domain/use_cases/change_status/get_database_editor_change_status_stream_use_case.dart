import 'package:sj_manager/features/database_editor/domain/repository/database_editor_change_status_repository.dart';

class GetDatabaseEditorChangeStatusStreamUseCase {
  const GetDatabaseEditorChangeStatusStreamUseCase({
    required this.changeStatusRepository,
  });

  final DatabaseEditorChangeStatusRepository changeStatusRepository;

  Future<Stream<bool>> call() async {
    return await changeStatusRepository.stream;
  }
}
