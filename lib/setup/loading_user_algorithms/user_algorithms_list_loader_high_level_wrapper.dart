import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sj_manager/exceptions/user_algorithm_list_loading_exception.dart';
import 'package:sj_manager/models/user_algorithms/unary_algorithm.dart';
import 'package:sj_manager/models/user_algorithms/user_algorithm.dart';
import 'package:sj_manager/models/user_db/db_items_file_system_paths.dart';
import 'package:sj_manager/models/user_db/items_repos_registry.dart';
import 'package:sj_manager/setup/loading_user_algorithms/user_algorithms_list_loader.dart';
import 'package:sj_manager/ui/dialogs/loading_items/db_directory_not_found_warning.dart';
import 'package:sj_manager/ui/dialogs/loading_items/loading_items_failed_dialog.dart';
import 'package:sj_manager/utils/file_system.dart';
import 'package:sj_manager/utils/show_dialog.dart';

/// [W] is a wrapper
class UserAlgorithmsListLoaderHighLevelWrapper<T extends UnaryAlgorithm> {
  const UserAlgorithmsListLoaderHighLevelWrapper({
    required this.directoryNotFoundDialogTitle,
    required this.loadingFailedDialogTitle,
    this.processItems,
    this.customOnFinish,
    required this.wrap,
  });

  final String directoryNotFoundDialogTitle;
  final String loadingFailedDialogTitle;
  final List<UserAlgorithm> Function(List<UserAlgorithm> source)? processItems;
  final void Function(List<UserAlgorithm<T>> source)? customOnFinish;
  final T Function(UnaryAlgorithm algorithm) wrap;

  UserAlgorithmsListLoader toLowLevel(BuildContext context) {
    return UserAlgorithmsListLoader(
      directoryPath: databaseDirectory(
        context.read(),
        context.read<DbItemsDirectoryPathsRegistry>().get<UserAlgorithm<T>>(),
      ).path,
      onError: (error, stackTrace) {
        final directory = databaseDirectory(context.read(),
            context.read<DbItemsDirectoryPathsRegistry>().get<UserAlgorithm<T>>());
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
          showSjmDialog(
            context: context,
            child: LoadingItemsFailedDialog(
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
        var rawUserAlgorithms = List.of(loaded);
        if (processItems != null) {
          rawUserAlgorithms = processItems!(rawUserAlgorithms);
        }
        final wrappedUserAlgorithms = rawUserAlgorithms.map((userAlgorithm) {
          return UserAlgorithm<T>(
            id: userAlgorithm.id,
            name: userAlgorithm.name,
            description: userAlgorithm.description,
            algorithm: wrap(userAlgorithm.algorithm),
          );
        }).toList();
        if (customOnFinish != null) {
          customOnFinish!(wrappedUserAlgorithms);
        } else {
          context
              .read<ItemsReposRegistry>()
              .get<UserAlgorithm<T>>()
              .set(wrappedUserAlgorithms);
        }
      },
    );
  }
}
