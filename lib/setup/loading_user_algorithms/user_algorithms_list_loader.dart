import 'dart:io';

import 'package:sj_manager/exceptions/user_algorithm_list_loading_exception.dart';
import 'package:sj_manager/models/user_algorithms/unary_algorithm.dart';
import 'package:sj_manager/models/user_algorithms/user_algorithm.dart';
import 'package:sj_manager/setup/db_items_list_loader.dart';
import 'package:sj_manager/dart_eval/user_algorithms/user_algorithm_loader_from_file.dart';

class UserAlgorithmsListLoader extends DbItemsListLoader {
  const UserAlgorithmsListLoader({
    required this.directoryPath,
    required this.onError,
    required this.onFinish,
  });

  final String directoryPath;
  final Function(Object error, StackTrace stackTrace) onError;
  final Function(List<UserAlgorithm<UnaryAlgorithm>> loaded) onFinish;

  @override
  Future<void> load() async {
    final directory = Directory(directoryPath);
    var loaded = <UserAlgorithm<UnaryAlgorithm>>[];
    final files = (await directory.list().toList()).whereType<File>();
    for (var file in files) {
      try {
        final loader = UserAlgorithmLoaderFromFile();
        final source = await file.readAsString();
        final algorithm = await loader.load(source);
        loaded.add(algorithm);
        onFinish(loaded);
      } catch (lowLevelError, stackTrace) {
        final exception = UserAlgorithmListLoadingException(
          error: lowLevelError,
          failureFile: file,
        );
        onError(exception, stackTrace);
      }
    }
  }
}
