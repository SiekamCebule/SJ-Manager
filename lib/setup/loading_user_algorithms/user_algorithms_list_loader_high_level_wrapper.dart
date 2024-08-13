import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sj_manager/exceptions/user_algorithm_list_loading_exception.dart';
import 'package:sj_manager/models/user_algorithms/user_algorithm.dart';
import 'package:sj_manager/models/user_db/db_items_file_system_paths.dart';
import 'package:sj_manager/models/user_db/items_repos_registry.dart';
import 'package:sj_manager/setup/loading_user_algorithms/user_algorithms_list_loader.dart';
import 'package:sj_manager/ui/dialogs/loading_items/db_directory_not_found_warning.dart';
import 'package:sj_manager/ui/dialogs/loading_items/loading_items_failed_dialog.dart';
import 'package:sj_manager/utils/file_system.dart';
import 'package:sj_manager/utils/show_dialog.dart';

class UserAlgorithmsListLoaderHighLevelWrapper<T extends UserAlgorithm> {
  const UserAlgorithmsListLoaderHighLevelWrapper({
    required this.directoryNotFoundDialogTitle,
    required this.loadingFailedDialogTitle,
    this.processItems,
    this.customOnFinish,
  });

  final String directoryNotFoundDialogTitle;
  final String loadingFailedDialogTitle;
  final List<T> Function(List<T> source)? processItems;
  final void Function(List<T> source)? customOnFinish;

  UserAlgorithmsListLoader<T> toLowLevel(BuildContext context) {
    return UserAlgorithmsListLoader<T>(
      directoryPath: databaseDirectory(
        context.read(),
        context.read<DbItemsDirectoryPathsRegistry>().get<T>(),
      ).path,
      onError: (error, stackTrace) {
        final directory = databaseDirectory(
            context.read(), context.read<DbItemsDirectoryPathsRegistry>().get<T>());
        if (error is PathNotFoundException) {
          directory.createSync();
          showSjmDialog(
            context: context,
            child: DbDirectoryNotFoundWarning(
              title: directoryNotFoundDialogTitle,
              newDirectoryPath: basename(directory.path),
              targetDirectory: databaseDirectory(context.read(), '').absolute.path,
            ),
          );
        } else if (error is UserAlgorithmListLoadingException) {
          showDialog(
            context: context,
            builder: (context) => LoadingItemsFailedDialog(
              titleText: loadingFailedDialogTitle,
              filePath: error.failureFile.path,
              error: error,
            ),
          );
        } else {
          throw UnimplementedError('Got an unknown error');
        }
      },
      onFinish: (loaded) {
        var items = List.of(loaded);
        if (processItems != null) {
          items = processItems!(items);
        }
        if (customOnFinish != null) {
          customOnFinish!(items);
        } else {
          context.read<ItemsReposRegistry>().get<T>().set(items);
        }
      },
    );
  }
}
