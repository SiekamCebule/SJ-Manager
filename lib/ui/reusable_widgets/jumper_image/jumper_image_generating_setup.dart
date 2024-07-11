import 'dart:io';

import 'package:sj_manager/models/jumper/jumper.dart';

class JumperImageGeneratingSetup {
  const JumperImageGeneratingSetup({
    required this.imagesDirectory,
    required this.toFileName,
    required this.extension,
  });

  final Directory imagesDirectory;
  final String Function(Jumper jumper) toFileName;
  final String extension;
}

String jumperImagePath(JumperImageGeneratingSetup setup, Jumper jumper) {
  final fileName = setup.toFileName(jumper);
  return '${setup.imagesDirectory.path}/$fileName.${setup.extension}';
}
