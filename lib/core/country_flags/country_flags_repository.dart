import 'package:flutter/material.dart';
import 'package:sj_manager/core/core_classes/country/country.dart';

abstract interface class CountryFlagsRepository {
  ImageProvider imageData(Country country);
}
