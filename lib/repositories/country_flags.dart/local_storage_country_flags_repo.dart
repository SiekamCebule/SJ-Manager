import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sj_manager/models/country.dart';
import 'package:sj_manager/repositories/country_flags.dart/country_flags_repo.dart';

class LocalStorageCountryFlagsRepo implements CountryFlagsRepo {
  LocalStorageCountryFlagsRepo({
    required this.imagesDirectory,
    required this.imagesExtension,
  });

  final Directory imagesDirectory;
  final String imagesExtension;

  final _cache = <Country, ImageProvider>{};

  @override
  ImageProvider<Object> imageData(Country country) {
    if (_cache.containsKey(country)) {
      return _cache[country]!;
    } else {
      final path = '${imagesDirectory.path}/${country.code}.$imagesExtension';
      final imageData = FileImage(File(path));
      _cache[country] = imageData;
      return imageData;
    }
  }
}
