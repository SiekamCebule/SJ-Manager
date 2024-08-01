// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:sj_manager/json/json_types.dart';

part 'country.g.dart';

@JsonSerializable()
class Country {
  const Country({
    required this.code,
    required this.name,
  });
  final String code;
  final String name;

  const Country.emptyNone()
      : code = 'none',
        name = '';

  static Country fromJson(Json json) => _$CountryFromJson(json);

  static Country fromMultilingualJson(Json json, String languageCode) {
    final name = stringFromMultilingualJson(json,
        languageCode: languageCode, parameterName: 'name');
    return Country(code: json['code'] as String, name: name);
  }

  Json toJson() => _$CountryToJson(this);

  @override
  String toString() {
    return '$name ($code)';
  }

  Country copyWith({
    String? code,
    String? name,
  }) {
    return Country(
      code: code ?? this.code,
      name: name ?? this.name,
    );
  }
}

String stringFromMultilingualJson(Json json,
    {required String languageCode, required String parameterName}) {
  return json[parameterName]![languageCode]!;
}
