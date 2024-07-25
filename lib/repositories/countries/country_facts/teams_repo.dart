import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/json/db_items_json.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/db/db_file_system_entity_names.dart';
import 'package:sj_manager/models/db/team/team.dart';
import 'package:sj_manager/repositories/generic/db_items_repo.dart';

class TeamsRepo extends DbItemsRepo<Team> {
  TeamsRepo({super.initial});

  static Future<TeamsRepo> fromDirectory(Directory dir,
      {required BuildContext context, required FromJson<Team> fromJson}) async {
    final dbFsEntityNames = context.read<DbFileSystemEntityNames>();
    final file = File('${dir.path}/${dbFsEntityNames.teams}');
    final items = await loadItemsListFromJsonFile(file: file, fromJson: fromJson);
    return TeamsRepo(initial: items);
  }
}
