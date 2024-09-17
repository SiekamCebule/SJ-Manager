import 'package:flutter/material.dart';
import 'package:sj_manager/json/db_items_json.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/game_variants/default_game_variants/test_variant.dart';
import 'package:sj_manager/models/game_variants/game_variant.dart';
import 'package:sj_manager/models/user_db/db_items_file_system_paths.dart';
import 'package:sj_manager/utils/file_system.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

Future<List<GameVariant>> constructDefaultGameVariants({
  required BuildContext context,
}) async {
  final testVariant = await constructTestGameVariant(context: context);
  return [
    testVariant,
  ];
}

Future<List<T>> loadItemsForGameVariant<T>({
  required BuildContext context,
  required FromJson<T> fromJson,
  required String gameVariantId,
}) async {
  print('T: $T');
  final fileName = context.read<DbItemsFilePathsRegistry>().get<T>();
  final file = fileInDirectory(
    userDataDirectory(
      context.read(),
      path.join('gameVariants', gameVariantId),
    ),
    fileName,
  );
  print('file: $file');
  return await loadItemsListFromJsonFile(
    file: file,
    fromJson: fromJson,
  );
}
