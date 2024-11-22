import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as path;
import 'package:sj_manager/domain/entities/simulation/competition/rules/competition_rules/default_competition_rules_preset.dart';
import 'package:sj_manager/domain/entities/simulation/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/domain/entities/simulation/event_series/event_series_setup.dart';
import 'package:sj_manager/core/classes/country/country.dart';
import 'package:sj_manager/data/repositories/db_items_file_system_paths.dart';
import 'package:sj_manager/domain/entities/game_variant/hill/hill.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/domain/entities/simulation/team/team.dart';

class PlarformSpecificPathsCache {
  PlarformSpecificPathsCache();
  late Directory _documents;

  Future<void> setup() async {
    _documents = await getApplicationDocumentsDirectory();
  }

  Directory get applicationDocumentsDirectory => _documents;
}

Directory sjmDirectory(PlarformSpecificPathsCache pathsCache) {
  final documentsDir = pathsCache.applicationDocumentsDirectory;
  final dir = Directory(path.join(documentsDir.path, 'sj_manager'));
  dir.createSync(recursive: true);
  return dir;
}

File userDataFile(PlarformSpecificPathsCache pathsCache, String fileName) {
  final documentsDir = pathsCache.applicationDocumentsDirectory;
  final databaseDir = Directory(path.join(documentsDir.path, 'sj_manager', 'user_data'));

  if (!databaseDir.existsSync()) {
    databaseDir.createSync(recursive: true);
  }

  final file = File(path.join(databaseDir.path, fileName));
  return file;
}

File databaseFile(PlarformSpecificPathsCache pathsCache, String fileName) {
  return userDataFile(pathsCache, path.join('database', fileName));
}

Directory userDataDirectory(PlarformSpecificPathsCache pathsCache, String directoryName) {
  final documentsDir = pathsCache.applicationDocumentsDirectory;
  final databaseDir = Directory(path.join(documentsDir.path, 'sj_manager', 'user_data'));

  if (!databaseDir.existsSync()) {
    databaseDir.createSync(recursive: true);
  }

  if (directoryName.isEmpty) return Directory(databaseDir.path);

  final dir = Directory(path.join(databaseDir.path, directoryName));

  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }

  return dir;
}

Directory databaseDirectory(PlarformSpecificPathsCache pathsCache, String directoryPath) {
  if (directoryPath.isEmpty) return userDataDirectory(pathsCache, 'database');
  return userDataDirectory(pathsCache, path.join('database', directoryPath));
}

Directory simulationDirectory({
  required PlarformSpecificPathsCache pathsCache,
  required String simulationId,
  String? directoryName,
}) {
  final secondPart = directoryName != null ? '/$directoryName' : '';
  final dirName = '$simulationId$secondPart';
  return userDataDirectory(pathsCache, path.join('simulations', dirName));
}

File simulationFile({
  required PlarformSpecificPathsCache pathsCache,
  required String simulationId,
  required String fileName,
}) {
  return fileInDirectory(
    simulationDirectory(
      pathsCache: pathsCache,
      simulationId: simulationId,
    ),
    fileName,
  );
}

File fileInDirectory(Directory directory, String name) {
  return File(path.join(directory.path, name));
}

File fileByNameWithoutExtension(Directory directory, String name) {
  final files = directory.listSync();
  for (var file in files) {
    if (file is File) {
      final fileNameWithoutExtension = path.basenameWithoutExtension(file.path);
      if (fileNameWithoutExtension == name) {
        return file;
      }
    }
  }
  throw FileSystemException('No file found with the base name $name');
}

bool directoryIsValidForDatabase(BuildContext context, Directory directory) {
  final dbRegistry = context.read<DbItemsFilePathsRegistry>();

  final correctFolderStructure = {
    fileInDirectory(directory, dbRegistry.get<MaleJumperDbRecord>()).path,
    fileInDirectory(directory, dbRegistry.get<FemaleJumperDbRecord>()).path,
    fileInDirectory(directory, dbRegistry.get<Hill>()).path,
    fileInDirectory(directory, dbRegistry.get<EventSeriesSetup>()).path,
    fileInDirectory(directory, dbRegistry.get<EventSeriesCalendarPreset>()).path,
    fileInDirectory(directory, dbRegistry.get<DefaultCompetitionRulesPreset>()).path,
    fileInDirectory(directory, dbRegistry.get<Team>()).path,
    fileInDirectory(directory, dbRegistry.get<Country>()).path,
  };

  final currentFolderStructure = <String>{};

  for (var entity in directory.listSync(recursive: true)) {
    if (entity is File) {
      currentFolderStructure.add(entity.path);
    }
  }

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
  try {
    // Load the asset manifest file
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    Map<String, dynamic> manifestMap = jsonDecode(manifestContent);

    // Filter asset paths based on the specified directory
    final assetPaths = manifestMap.keys
        .where((String key) => key.startsWith('assets/$assetsDirPath/'))
        .toList();

    for (String assetPath in assetPaths) {
      // Load the asset file as bytes
      ByteData data = await rootBundle.load(assetPath);
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Get the file name using path utilities
      String fileName = path.basename(assetPath);

      // Create the file in the destination directory
      File file = File(path.join(destination.path, fileName));

      // Ensure the destination directory exists
      if (!destination.existsSync()) {
        destination.createSync(recursive: true);
      }

      // Write the file to the target directory
      await file.writeAsBytes(bytes);
    }
  } catch (e) {
    rethrow;
  }
}

Future<void> copyDirectory(Directory sourceDir, Directory targetDir) async {
  if (!await targetDir.exists()) {
    await targetDir.create(recursive: true);
  }

  await for (var entity in sourceDir.list(recursive: false, followLinks: false)) {
    if (entity is Directory) {
      var newDirectory = Directory('${targetDir.path}/${entity.uri.pathSegments.last}');
      await copyDirectory(entity, newDirectory);
    } else if (entity is File) {
      var newFile = File('${targetDir.path}/${entity.uri.pathSegments.last}');
      await entity.copy(newFile.path);
    }
  }
}

List<String> filePathsInDirectory(Directory directory) {
  final fsEntities = directory.listSync();
  return fsEntities.whereType<File>().map((file) => file.path).toList();
}

void createFileWithEmptyJsonMap(String filePath) {
  final file = File(filePath);
  file.createSync(recursive: true);
  file.writeAsStringSync('{"items":{}, "orderedIds":[]}');
}
