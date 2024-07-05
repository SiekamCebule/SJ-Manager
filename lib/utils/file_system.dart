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

File databaseFile(PlarformSpecificPathsCache pathsCache, String fileName) {
  final documentsDir = pathsCache.applicationDocumentsDirectory;
  final databaseDir = Directory('${documentsDir.path}/sj_manager/database');
  if (!databaseDir.existsSync()) {
    databaseDir.createSync(recursive: true);
  }
  final file = File('${databaseDir.path}/$fileName');

  if (!file.existsSync()) {
    file.create(recursive: true);
  }
  return file;
}
