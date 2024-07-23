import 'dart:io';

import 'package:sj_manager/models/db/hill/hill.dart';
import 'package:sj_manager/utils/file_system.dart';

class HillImageGeneratingSetup {
  const HillImageGeneratingSetup({
    required this.imagesDirectory,
    required this.toFileName,
    this.extension,
  });

  final Directory imagesDirectory;
  final String Function(Hill hill) toFileName;
  final String? extension;
}

String? hillImagePath(HillImageGeneratingSetup setup, Hill hill) {
  final fileName = setup.toFileName(hill);

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
