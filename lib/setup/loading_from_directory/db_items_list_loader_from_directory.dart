import 'dart:io';

import 'package:sj_manager/json/db_items_json.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/setup/db_items_list_loader.dart';

class DbItemsListLoaderFromDirectory<T extends Object> extends DbItemsListLoader {
  DbItemsListLoaderFromDirectory({
    required this.directoryPath,
    required this.fileMatches,
    required this.fromJson,
    required this.onError,
    required this.onFinish,
  });

  final String directoryPath;
  final bool Function(File file) fileMatches;
  final FromJson<T> fromJson;
  final Function(Object error, StackTrace stackTrace) onError;
  final Function(List<T> loaded) onFinish;

  @override
  Future<void> load() async {
    try {
      final directory = Directory(directoryPath);
      final loaded = await loadItemsFromDirectory(
          directory: directory, match: fileMatches, fromJson: fromJson);
      onFinish(loaded);
    } catch (error, stackTrace) {
      onError(error, stackTrace);
    }
  }
}
