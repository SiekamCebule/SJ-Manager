import 'package:flutter/material.dart';
import 'package:sj_manager/models/user_db/country/country.dart';

abstract interface class CountryFlagsRepo {
  const CountryFlagsRepo();

  ImageProvider imageData(Country country);
}
