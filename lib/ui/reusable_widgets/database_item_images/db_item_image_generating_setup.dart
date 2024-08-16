import 'dart:io';

import 'package:sj_manager/utils/file_system.dart';

class DbItemImageGeneratingSetup<T> {
  const DbItemImageGeneratingSetup({
    required this.imagesDirectory,
    required this.toFileName,
    this.extension,
  });

  final Directory imagesDirectory;
  final String Function(T item) toFileName;
  final String? extension;
}

String? dbItemImagePath<T>(DbItemImageGeneratingSetup<T> setup, T item) {
  final fileName = setup.toFileName(item);
  if (setup.extension != null) {
    return '${setup.imagesDirectory.path}/$fileName.${setup.extension}';
  } else {
    try {
      return fileByNameWithoutExtension(setup.imagesDirectory, fileName).path;
    } on FileSystemException {
      return null;
    }
  }
}
