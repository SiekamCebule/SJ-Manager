import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sj_manager/models/db/db_items_file_system_entity.dart';
import 'package:sj_manager/models/db/hill/hill.dart';
import 'package:sj_manager/models/db/jumper/jumper.dart';
import 'package:path/path.dart' as path;

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
  throw FileSystemException('No file found with the base name $name');
}

File fileInDirectory(Directory directory, String name) {
  return File('${directory.path}/$name');
}

bool directoryIsValidForDatabase(BuildContext context, Directory directory) {
  final correctFolderStructure = {
    fileInDirectory(
            directory, context.read<DbItemsFileSystemEntity<MaleJumper>>().basename)
        .path,
    fileInDirectory(
            directory, context.read<DbItemsFileSystemEntity<FemaleJumper>>().basename)
        .path,
    fileInDirectory(directory, context.read<DbItemsFileSystemEntity<Hill>>().basename)
        .path,
  };
  final currentFolderStructure = directory.listSync().map((file) => file.path).toSet();

  return currentFolderStructure.containsAll(correctFolderStructure);
}

void copyDirectorySync(Directory source, Directory destination) {
  /// create destination folder if not exist
  if (!destination.existsSync()) {
    destination.createSync(recursive: true);
  }

  /// get all files from source (recursive: false is important here)
  source.listSync(recursive: false).forEach((entity) {
    final newPath =
        destination.path + Platform.pathSeparator + path.basename(entity.path);
    if (entity is File) {
      entity.copySync(newPath);
    } else if (entity is Directory) {
      copyDirectorySync(entity, Directory(newPath));
    }
  });
}

Future<void> copyAssetsDir(String assetsDirPath, Directory destination) async {
  final manifestContent = await rootBundle.loadString('AssetManifest.json');
  Map<String, dynamic> manifestMap = jsonDecode(manifestContent);

  final assetPaths = manifestMap.keys
      .where((String key) => key.startsWith('assets/$assetsDirPath/'))
      .toList();

  for (String assetPath in assetPaths) {
    // Load the asset file as bytes
    ByteData data = await rootBundle.load(assetPath);
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Get the file name
    String fileName = assetPath.split('/').last;

    // Write the file to the target directory
    File file = File('${destination.path}/$fileName');
    await file.writeAsBytes(bytes);
  }
}
