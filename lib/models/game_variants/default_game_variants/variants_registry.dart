import 'package:flutter/material.dart';
import 'package:sj_manager/json/db_items_json.dart';
import 'package:sj_manager/models/game_variants/default_game_variants/test_variant.dart';
import 'package:sj_manager/models/game_variants/game_variant.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/repositories/generic/db_items_json_configuration.dart';
import 'package:sj_manager/utils/file_system.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

List<GameVariant> constructDefaultGameVariants({
  required BuildContext context,
}) {
  final testJumpers = <Jumper>[];
  /*final wcJumpers = loadJumpersForGameVariant(
      context: context, gameVariantId: 'wc_24_25');*/
  return [
    constructTestGameVariant(context: context, jumpers: testJumpers),
  ];
}

Future<List<Jumper>> loadJumpersForGameVariant({
  required BuildContext context,
  required String gameVariantId,
}) async {
  final file = fileInDirectory(
    databaseDirectory(
      context.read(),
      path.join('gameVariants', gameVariantId),
    ),
    'jumpers_male.json',
  );
  return await loadItemsListFromJsonFile(
    file: file,
    fromJson: context.read<DbItemsJsonConfiguration<Jumper>>().fromJson,
  );
}
