import 'package:flutter/material.dart';
import 'package:sj_manager/models/country.dart';

abstract interface class CountryFlagsApi {
  const CountryFlagsApi();

  ImageProvider imageData(Country country);
}
