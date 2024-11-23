import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sj_manager/core/general_utils/file_system.dart';

class EventSeriesAssetsProvider {
  const EventSeriesAssetsProvider({
    required this.eventSeriesDirectory,
  });

  final Directory eventSeriesDirectory;

  ImageProvider logo() {
    final file = fileByNameWithoutExtension(eventSeriesDirectory, 'logo');
    return FileImage(file);
  }

  ImageProvider trophy() {
    final file = fileByNameWithoutExtension(eventSeriesDirectory, 'trophy');
    return FileImage(file);
  }
}
