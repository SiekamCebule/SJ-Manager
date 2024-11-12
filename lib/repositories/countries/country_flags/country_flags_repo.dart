import 'package:flutter/material.dart';
import 'package:sj_manager/models/database/country/country.dart';

abstract interface class CountryFlagsRepo {
  const CountryFlagsRepo();

  ImageProvider imageData(Country country);
}
