import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/json/db_items_json.dart';
import 'package:sj_manager/models/db_items_file_system_entity.dart';
import 'package:sj_manager/models/hill/hill.dart';
import 'package:sj_manager/models/jumper/jumper.dart';
import 'package:sj_manager/repositories/database_editing/db_items_json_configuration.dart';
import 'package:sj_manager/repositories/database_editing/local_db_repos_repository.dart';
import 'package:sj_manager/utils/file_system.dart';

class CopiedLocalDbCubit extends Cubit<LocalDbReposRepo?> {
  CopiedLocalDbCubit({
    required this.originalRepositories,
  }) : super(null);

  LocalDbReposRepo originalRepositories;

  Future<void> setUp() async {
    final editableMaleJumpersRepo = originalRepositories.maleJumpersRepo.clone();
    final editableFemaleJumpersRepo = originalRepositories.femaleJumpersRepo.clone();
    final editableHillsRepo = originalRepositories.hillsRepo.clone();

    emit(
      LocalDbReposRepo(
        maleJumpersRepo: editableMaleJumpersRepo,
        femaleJumpersRepo: editableFemaleJumpersRepo,
        hillsRepo: editableHillsRepo,
      ),
    );
  }

  Future<void> saveChangesToOriginalRepos(BuildContext context) async {
    await _saveChangesByType<MaleJumper>(context);
    if (!context.mounted) return;
    await _saveChangesByType<FemaleJumper>(context);
    if (!context.mounted) return;
    await _saveChangesByType<Hill>(context);
  }

  Future<void> _saveChangesByType<T>(BuildContext context) async {
    originalRepositories.byGenericType<T>().setItems(state!.byGenericType<T>().lastItems);
    _saveItemsToJsonByType<T>(
      context: context,
      file: context.read<DbItemsFileSystemEntity<T>>().entity as File,
    );
  }

  Future<void> saveAs(BuildContext context, Directory directory) async {
    await _saveItemsToJsonByType<MaleJumper>(
      context: context,
      file: fileInDirectory(
        directory,
        context.read<DbItemsFileSystemEntity<MaleJumper>>().basename,
      ),
    );
    if (!context.mounted) return;
    await _saveItemsToJsonByType<FemaleJumper>(
      context: context,
      file: fileInDirectory(
        directory,
        context.read<DbItemsFileSystemEntity<FemaleJumper>>().basename,
      ),
    );
    if (!context.mounted) return;
    await _saveItemsToJsonByType<Hill>(
      context: context,
      file: fileInDirectory(
        directory,
        context.read<DbItemsFileSystemEntity<Hill>>().basename,
      ),
    );
  }

  Future<void> _saveItemsToJsonByType<T>(
      {required BuildContext context, required File file}) async {
    final parameters = context.read<DbItemsJsonConfiguration<T>>();
    await saveItemsListToJsonFile(
      file: file,
      items: state!.byGenericType<T>().lastItems,
      toJson: parameters.toJson,
    );
  }

  Future<void> loadExternal(BuildContext context, Directory directory) async {
    final males = await _loadItemsFromJsonByType<MaleJumper>(
      context: context,
      file: fileInDirectory(
        directory,
        context.read<DbItemsFileSystemEntity<MaleJumper>>().basename,
      ),
    );
    state!.maleJumpersRepo.setItems(males);
    if (!context.mounted) return;
    final females = await _loadItemsFromJsonByType<FemaleJumper>(
      context: context,
      file: fileInDirectory(
        directory,
        context.read<DbItemsFileSystemEntity<FemaleJumper>>().basename,
      ),
    );
    state!.femaleJumpersRepo.setItems(females);
    if (!context.mounted) return;
    final hills = await _loadItemsFromJsonByType<Hill>(
      context: context,
      file: fileInDirectory(
        directory,
        context.read<DbItemsFileSystemEntity<Hill>>().basename,
      ),
    );
    state!.hillsRepo.setItems(hills);

    emit(LocalDbReposRepo(
      maleJumpersRepo: state!.maleJumpersRepo,
      femaleJumpersRepo: state!.femaleJumpersRepo,
      hillsRepo: state!.hillsRepo,
    ));
  }

  Future<List<T>> _loadItemsFromJsonByType<T>(
      {required BuildContext context, required File file}) async {
    final parameters = context.read<DbItemsJsonConfiguration<T>>();
    return await loadItemsListFromJsonFile(
      file: file,
      fromJson: parameters.fromJson,
    );
  }
}
