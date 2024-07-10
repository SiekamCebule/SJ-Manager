import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sj_manager/repositories/database_editing/local_db_repos_repository.dart';

part 'local_db_repos_state.dart';

class CopiedLocalDbCubit extends Cubit<LocalDbReposRepository?> {
  CopiedLocalDbCubit({
    required this.originalRepositories,
  }) : super(null);

  LocalDbReposRepository originalRepositories;

  Future<void> setUp() async {
    final editableMaleJumpersRepo = await originalRepositories.maleJumpersRepo.clone();
    final editableFemaleJumpersRepo =
        await originalRepositories.femaleJumpersRepo.clone();
    final editableHillsRepo = await originalRepositories.hillsRepo.clone();

    emit(
      LocalDbReposRepository(
        maleJumpersRepo: editableMaleJumpersRepo,
        femaleJumpersRepo: editableFemaleJumpersRepo,
        hillsRepo: editableHillsRepo,
      ),
    );
  }

  Future<void> saveChangesToOriginalRepos() async {
    await originalRepositories.maleJumpersRepo
        .loadRaw(state!.maleJumpersRepo.items.value);
    await originalRepositories.maleJumpersRepo.saveToSource();

    await originalRepositories.femaleJumpersRepo
        .loadRaw(state!.femaleJumpersRepo.items.value);
    await originalRepositories.femaleJumpersRepo.saveToSource();
  }
}
