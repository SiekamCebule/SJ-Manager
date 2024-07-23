import 'dart:io';

import 'package:sj_manager/models/db/jumper/jumper.dart';
import 'package:sj_manager/utils/file_system.dart';

class JumperImageGeneratingSetup {
  const JumperImageGeneratingSetup({
    required this.imagesDirectory,
    required this.toFileName,
    this.extension,
  });

  final Directory imagesDirectory;
  final String Function(Jumper jumper) toFileName;
  final String? extension;
}

String? jumperImagePath(JumperImageGeneratingSetup setup, Jumper jumper) {
  final fileName = setup.toFileName(jumper);

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
