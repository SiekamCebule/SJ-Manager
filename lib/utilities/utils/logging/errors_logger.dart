import 'dart:io';
import 'dart:async';
import 'package:sj_manager/utilities/utils/file_system.dart';

class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  factory LoggerService() => _instance;

  LoggerService._internal();

  File? _logFile;

  Future<void> init(PlarformSpecificPathsCache pathsCache) async {
    final directory = sjmDirectory(pathsCache);
    _logFile = File('${directory.path}/log.txt');
    if (!await _logFile!.exists()) {
      await _logFile!.create();
    }
    await _logFile!.writeAsString('');
  }

  Future<void> logError(Object error, StackTrace? stackTrace) async {
    final timestamp = DateTime.now().toIso8601String();

    if (_logFile != null) {
      await _logFile!.writeAsString(
        '[$timestamp] ERROR: $error\nStackTrace: $stackTrace\n\n',
        mode: FileMode.append,
      );
    }
  }
}
