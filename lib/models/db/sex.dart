import 'package:json_annotation/json_annotation.dart';

enum Sex {
  @JsonValue('male')
  male,

  @JsonValue('female')
  female,
}
