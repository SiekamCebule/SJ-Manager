import 'dart:convert';
import 'dart:io';

import 'package:sj_manager/models/country.dart';
import 'package:sj_manager/repositories/countries/countries_api.dart';

class LocalStorageMultilingualCountriesRepository implements CountriesApi {
  LocalStorageMultilingualCountriesRepository({
    required this.storageFile,
    required this.languageCode,
  });

  final File storageFile;
  final String languageCode;

  var _countries = <Country>{};

  @override
  Future<void> loadFromSource() async {
    final stringContent = await storageFile.readAsString();
    final jsonCountries = jsonDecode(stringContent) as List;
    _countries = jsonCountries.map((countryJson) {
      final names = countryJson['name'] as Map<String, dynamic>;
      return Country(
        code: countryJson['code'] as String,
        name: names[languageCode]!,
      );
    }).toSet();
  }

  @override
  Future<void> saveToSource() async {
    final json = _countries.map((country) {
      return country.toJson();
    }).toList();
    final stringContent = jsonEncode(json);
    await storageFile.writeAsString(stringContent);
  }

  @override
  Iterable<Country> get countries => _countries;

  @override
  Country? byCode(String code) {
    try {
      return _countries.singleWhere((country) => country.code == code);
    } on Error {
      return null;
    }
  }

  @override
  Country get none => _countries.singleWhere((country) => country.code == 'none');
}
