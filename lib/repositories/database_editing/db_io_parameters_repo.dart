import 'dart:io';

import 'package:path/path.dart';
import 'package:sj_manager/json/json_types.dart';

class DbIoParametersRepo<T> {
  DbIoParametersRepo({
    required this.storageFile,
    required this.fromJson,
    required this.toJson,
  });

  final File storageFile;
  final FromJson<T> fromJson;
  final ToJson<T> toJson;

  String get fileBasename => basename(storageFile.path);
}
