import 'dart:io';

import 'package:path_provider/path_provider.dart';

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
