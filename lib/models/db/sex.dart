import 'package:json_annotation/json_annotation.dart';

enum Sex {
  @JsonValue(0)
  male,

  @JsonValue(1)
  female,
}
