import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sj_manager/models/hill/hill.dart';
import 'package:sj_manager/models/jumper/jumper.dart';
import 'package:sj_manager/repositories/database_editing/db_io_parameters_repo.dart';

class PlarformSpecificPathsCache {
  PlarformSpecificPathsCache();
  late Directory _documents;

  Future<void> setup() async {
    _documents = await getApplicationDocumentsDirectory();
  }

  Directory get applicationDocumentsDirectory => _documents;
}

File userDataFile(PlarformSpecificPathsCache pathsCache, String fileName) {
  final documentsDir = pathsCache.applicationDocumentsDirectory;
  final databaseDir = Directory('${documentsDir.path}/sj_manager/user_data');
  if (!databaseDir.existsSync()) {
    databaseDir.createSync(recursive: true);
  }
  final file = File('${databaseDir.path}/$fileName');

  if (!file.existsSync()) {
    file.create(recursive: true);
  }
  return file;
}

Directory userDataDirectory(PlarformSpecificPathsCache pathsCache, String directoryName) {
  final documentsDir = pathsCache.applicationDocumentsDirectory;
  final databaseDir = Directory('${documentsDir.path}/sj_manager/user_data');
  if (!databaseDir.existsSync()) {
    databaseDir.createSync(recursive: true);
  }
  final dir = Directory('${databaseDir.path}/$directoryName');

  if (!dir.existsSync()) {
    dir.create(recursive: true);
  }
  return dir;
}

File fileByNameWithoutExtension(Directory directory, String name) {
  final files = directory.listSync();
  for (var file in files) {
    if (file is File &&
        file.path.contains(RegExp(r'/' + RegExp.escape(name) + r'\.\w+$'))) {
      return file;
    }
  }
  // Handle case when no file is found
  throw FileSystemException('No file found with the base name $name');
}

File fileInDirectory(Directory directory, String name) {
  return File('${directory.path}/$name');
}

bool directoryIsValidForDatabase(BuildContext context, Directory directory) {
  final correctFolderStructure = {
    fileInDirectory(
            directory, context.read<DbIoParametersRepo<MaleJumper>>().fileBasename)
        .path,
    fileInDirectory(
            directory, context.read<DbIoParametersRepo<FemaleJumper>>().fileBasename)
        .path,
    fileInDirectory(directory, context.read<DbIoParametersRepo<Hill>>().fileBasename)
        .path,
  };
  final currentFolderStructure = directory.listSync().map((file) => file.path).toSet();

  return currentFolderStructure.containsAll(correctFolderStructure);
}
