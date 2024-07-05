import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(constructor: 'Country')
class Country {
  const Country({
    required this.code,
    this.name,
  });
  final String code;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? name;

  factory Country.fromJson(String code) => Country(code: code);

  String toJson() => code;
}
