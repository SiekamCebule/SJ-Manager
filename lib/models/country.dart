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

  static Country fromJson(Json json) => _$CountryFromJson(json);

  static Country fromMultilingualJson(Json json, String languageCode) {
    final names = json['name'] as Map<String, dynamic>;
    return Country(code: json['code'] as String, name: names[languageCode]!);
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
