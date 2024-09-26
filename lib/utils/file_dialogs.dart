/*
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sj_manager/models/user_db/items_repos_registry.dart';
import 'package:sj_manager/ui/screens/database_editor/large/dialogs/selected_db_is_not_valid_dialog.dart';
import 'package:sj_manager/utils/file_system.dart';
Future<ItemsReposRegistry?> pickDatabaseByDialog(BuildContext context) async {
  final path = await FilePicker.platform.getDirectoryPath();
  if (!context.mounted || path == null) return null;
  final dir = Directory(path);
  if (!directoryIsValidForDatabase(context, dir)) {
    await showDialog(
      context: context,
      builder: (context) => const SelectedDbIsNotValidDialog(),
    );
    return null;
  } else {
    return await ItemsReposRegistry.fromDirectory(dir, context: context);
  }
}*/
