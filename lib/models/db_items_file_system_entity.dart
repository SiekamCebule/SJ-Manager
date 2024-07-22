import 'dart:io';

import 'package:path/path.dart' as path;

class DbItemsFileSystemEntity<T> {
  DbItemsFileSystemEntity(this.entity);

  final FileSystemEntity entity;

  String get basename => path.basename(entity.path);
}
