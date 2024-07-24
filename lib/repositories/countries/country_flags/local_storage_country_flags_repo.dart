import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sj_manager/models/db/country/country.dart';
import 'package:sj_manager/repositories/countries/country_flags/country_flags_repo.dart';

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
      var file = File(path);
      if (!file.existsSync()) {
        file = File('${imagesDirectory.path}/none.$imagesExtension');
      }
      final imageData = FileImage(file);
      _cache[country] = imageData;
      return imageData;
    }
  }
}
