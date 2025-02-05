import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sj_manager/core/core_classes/country/country.dart';
import 'package:sj_manager/core/country_flags/country_flags_repository.dart';
import 'package:path/path.dart' as path;

class LocalStorageCountryFlagsRepo implements CountryFlagsRepository {
  LocalStorageCountryFlagsRepo({
    required this.imagesDirectory,
    required this.imagesExtension,
  });

  final Directory imagesDirectory;
  final String imagesExtension;

  final _cache = <Country, ImageProvider>{};

  @override
  ImageProvider<Object> imageData(Country country, {bool throwWhenNull = false}) {
    if (_cache.containsKey(country)) {
      return _cache[country]!;
    } else {
      final filePath = path.join(
          imagesDirectory.path, '${country.code.toLowerCase()}.$imagesExtension');
      var file = File(filePath);
      if (!file.existsSync()) {
        file = File(path.join(imagesDirectory.path, 'none.$imagesExtension'));
      }
      final imageData = FileImage(file);
      _cache[country] = imageData;
      return imageData;
    }
  }
}
