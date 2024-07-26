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
    originalDb.editableByGenericType<T>().set(state!.editableByGenericType<T>().last);
    final file = databaseFile(
        context.read(), context.read<DbFileSystemEntityNames>().byGenericType<T>());
    await _saveItemsToJsonByType<T>(
      context: context,
      file: file,
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
      items: originalDb.editableByGenericType<T>().last,
      toJson: parameters.toJson,
    );
  }

  Future<void> loadExternal(BuildContext context, Directory directory) async {
    emit(await LocalDbRepo.fromDirectory(
      directory,
      context: context,
    ));
  }

  void dispose() {
    originalDb.dispose();
    state?.dispose();
  }
}
