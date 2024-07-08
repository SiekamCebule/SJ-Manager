import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sj_manager/bloc/database_editing/repos/local_db_repos_repository.dart';

part 'local_db_repos_state.dart';

class LocalDbReposCubit extends Cubit<LocalDbReposState> {
  LocalDbReposCubit({
    required this.originalRepositories,
  }) : super(
          const LocalDbReposState(
            prepared: false,
            editableRepositories: null,
          ),
        );

  LocalDbReposRepository originalRepositories;

  Future<void> setUp() async {
    final editableMaleJumpersRepo = await originalRepositories.maleJumpersRepo.clone();
    final editableFemaleJumpersRepo =
        await originalRepositories.femaleJumpersRepo.clone();

    emit(
      state.copyWith(
        prepared: true,
        editableRepositories: LocalDbReposRepository(
          maleJumpersRepo: editableMaleJumpersRepo,
          femaleJumpersRepo: editableFemaleJumpersRepo,
        ),
      ),
    );
  }

  Future<void> endEditing() async {
    if (!state.prepared) {
      throw StateError(
          'Cannot end editing the local db, because the db have not been set up');
    }
    await originalRepositories.maleJumpersRepo
        .loadRaw(state.editableRepositories!.maleJumpersRepo.items.value);
    await originalRepositories.maleJumpersRepo.saveToSource();

    await originalRepositories.femaleJumpersRepo
        .loadRaw(state.editableRepositories!.femaleJumpersRepo.items.value);
    await originalRepositories.femaleJumpersRepo.saveToSource();
  }
}
