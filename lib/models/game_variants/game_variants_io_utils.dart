import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:sj_manager/json/db_items_json.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/user_db/db_items_file_system_paths.dart';
import 'package:sj_manager/utils/file_system.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

Future<List<T>> loadGameVariantItems<T>({
  required BuildContext context,
  required FromJson<T> fromJson,
  required String gameVariantId,
}) async {
  return await loadItemsListFromJsonFile<T>(
    file: getFileForGameVariantItems<T>(
      context: context,
      gameVariantId: gameVariantId,
    ),
    fromJson: fromJson,
  );
}

File getFileForGameVariantItems<T>({
  required BuildContext context,
  required String gameVariantId,
}) {
  final fileName = context.read<DbItemsFilePathsRegistry>().get<T>();
  return fileInDirectory(
    userDataDirectory(
      context.read(),
      path.join('gameVariants', gameVariantId),
    ),
    fileName,
  );
}

Future<void> saveGameVariantItems<T>({
  required List<T> items,
  required BuildContext context,
  required ToJson<T> toJson,
  required String gameVariantId,
}) async {
  await saveItemsListToJsonFile<T>(
    file: getFileForGameVariantItems<T>(context: context, gameVariantId: gameVariantId),
    items: items,
    toJson: toJson,
  );
}
