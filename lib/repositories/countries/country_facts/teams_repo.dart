import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/json/db_items_json.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/user_db/db_items_file_system_paths.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';

class TeamsRepo<T extends Team> extends ItemsRepo<T> {
  TeamsRepo({super.initial});

  static Future<TeamsRepo> fromDirectory(Directory dir,
      {required BuildContext context, required FromJson<Team> fromJson}) async {
    final dbFsEntityNames = context.read<DbItemsFilePathsRegistry>();
    final file = File('${dir.path}/${dbFsEntityNames.get<Team>()}');
    final items = await loadItemsListFromJsonFile(file: file, fromJson: fromJson);
    return TeamsRepo(initial: items);
  }
}
