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

  Json toJson() => _$CountryToJson(this);

  @override
  String toString() {
    return '$name ($code)';
  }
}
