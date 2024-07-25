import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/json/db_items_json.dart';
import 'package:sj_manager/models/db/db_file_system_entity_names.dart';
import 'package:sj_manager/models/db/hill/hill.dart';
import 'package:sj_manager/models/db/jumper/jumper.dart';
import 'package:sj_manager/models/db/local_db_repo.dart';
import 'package:sj_manager/repositories/generic/db_items_json_configuration.dart';
import 'package:sj_manager/utils/file_system.dart';

import 'package:path/path.dart' as path;

class CopiedLocalDbCubit extends Cubit<LocalDbRepo?> {
  CopiedLocalDbCubit({
    required this.originalDb,
  }) : super(null);

  LocalDbRepo originalDb;

  Future<void> setUp() async {
    final editableMaleJumpers = originalDb.maleJumpers.clone();
    final editableFemaleJumpers = originalDb.femaleJumpers.clone();
    final editableHills = originalDb.hills.clone();

    emit(
      LocalDbRepo(
        maleJumpers: editableMaleJumpers,
        femaleJumpers: editableFemaleJumpers,
        hills: editableHills,
        countries: originalDb.countries,
        teams: originalDb.teams,
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
    originalDb
        .editableByGenericType<T>()
        .set(state!.editableByGenericType<T>().lastItems);
    _saveItemsToJsonByType<T>(
      context: context,
      file: File(context.read<DbFileSystemEntityNames>().byGenericType<T>()),
    );
  }

  Future<void> saveAs(BuildContext context, Directory directory) async {
    await _saveItemsToJsonByType<MaleJumper>(
      context: context,
      file: fileInDirectory(
        directory,
        path.basename(context.read<DbFileSystemEntityNames>().maleJumpers),
      ),
    );
    if (!context.mounted) return;
    await _saveItemsToJsonByType<FemaleJumper>(
      context: context,
      file: fileInDirectory(
        directory,
        path.basename(context.read<DbFileSystemEntityNames>().femaleJumpers),
      ),
    );
    if (!context.mounted) return;
    await _saveItemsToJsonByType<Hill>(
      context: context,
      file: fileInDirectory(
        directory,
        path.basename(context.read<DbFileSystemEntityNames>().hills),
      ),
    );
  }

  Future<void> _saveItemsToJsonByType<T>(
      {required BuildContext context, required File file}) async {
    final parameters = context.read<DbItemsJsonConfiguration<T>>();
    await saveItemsListToJsonFile(
      file: file,
      items: state!.editableByGenericType<T>().lastItems,
      toJson: parameters.toJson,
    );
  }

  Future<void> loadExternal(BuildContext context, Directory directory) async {
    final males = await _loadItemsFromJsonByType<MaleJumper>(
      context: context,
      file: fileInDirectory(
        directory,
        path.basename(context.read<DbFileSystemEntityNames>().maleJumpers),
      ),
    );
    state!.maleJumpers.set(males);
    if (!context.mounted) return;
    final females = await _loadItemsFromJsonByType<FemaleJumper>(
      context: context,
      file: fileInDirectory(
        directory,
        path.basename(context.read<DbFileSystemEntityNames>().femaleJumpers),
      ),
    );
    state!.femaleJumpers.set(females);
    if (!context.mounted) return;
    final hills = await _loadItemsFromJsonByType<Hill>(
      context: context,
      file: fileInDirectory(
        directory,
        path.basename(context.read<DbFileSystemEntityNames>().hills),
      ),
    );
    state!.hills.set(hills);

    emit(LocalDbRepo(
      maleJumpers: state!.maleJumpers,
      femaleJumpers: state!.femaleJumpers,
      hills: state!.hills,
      countries: state!.countries,
      teams: state!.teams,
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

  void dispose() {
    originalDb.dispose();
  }
}
