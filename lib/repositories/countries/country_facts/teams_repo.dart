import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/json/db_items_json.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/user_db/db_items_file_system_paths.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';
import 'package:sj_manager/setup/loading_from_file/db_items_list_loader_from_file_high_level_wrapper.dart';

class TeamsRepo<T extends Team> extends ItemsRepo<T> {
  TeamsRepo({super.initial});

  static Future<TeamsRepo> fromDirectory(
    Directory dir, {
    required BuildContext context,
    required FromJson<Team> fromJson,
    required ItemsIdsRepo idsRepo,
  }) async {
    final dbFsEntityNames = context.read<DbItemsFilePathsRegistry>();
    final file = File('${dir.path}/${dbFsEntityNames.get<Team>()}');
    final loadedItemsMap = await loadItemsMapFromJsonFile(file: file, fromJson: fromJson);
    final items = loadedItemsMapToItemsList(loadedItemsMap: loadedItemsMap);
    final idsByItems = Map.fromEntries(
      loadedItemsMap.items.entries.map(
        (entry) => MapEntry(entry.value.$1, entry.key),
      ),
    );
    idsRepo.registerMany(
      items,
      generateId: (item) => idsByItems[item],
    );
    return TeamsRepo(initial: items);
  }
}
