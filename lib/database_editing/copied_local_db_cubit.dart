import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/json/db_items_json.dart';
import 'package:sj_manager/models/jumper/jumper.dart';
import 'package:sj_manager/repositories/database_editing/db_io_parameters_repo.dart';
import 'package:sj_manager/repositories/database_editing/local_db_repos_repository.dart';

class CopiedLocalDbCubit extends Cubit<LocalDbReposRepository?> {
  CopiedLocalDbCubit({
    required this.originalRepositories,
  }) : super(null);

  LocalDbReposRepository originalRepositories;

  Future<void> setUp() async {
    final editableMaleJumpersRepo = originalRepositories.maleJumpersRepo.clone();
    final editableFemaleJumpersRepo = originalRepositories.femaleJumpersRepo.clone();
    final editableHillsRepo = originalRepositories.hillsRepo.clone();

    emit(
      LocalDbReposRepository(
        maleJumpersRepo: editableMaleJumpersRepo,
        femaleJumpersRepo: editableFemaleJumpersRepo,
        hillsRepo: editableHillsRepo,
      ),
    );
  }

  Future<void> saveChangesToOriginalRepos(BuildContext context) async {
    await _saveChangesByType<MaleJumper>(context);
    if (!context.mounted) return;
    await _saveChangesByType<MaleJumper>(context);
    if (!context.mounted) return;
    await _saveChangesByType<MaleJumper>(context);
  }

  Future<void> _saveChangesByType<T>(BuildContext context) async {
    final parameters = context.read<DbIoParametersRepo<T>>();
    originalRepositories.byGenericType<T>().setItems(state!.byGenericType<T>().lastItems);
    await saveItemsListToJsonFile(
      file: parameters.storageFile,
      items: originalRepositories.byGenericType<T>().lastItems,
      toJson: parameters.toJson,
    );
  }
}
