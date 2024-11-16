import 'package:json_annotation/json_annotation.dart';

enum JumpsVariability {
  @JsonValue(2)
  highlyVariable,

  @JsonValue(1)
  variable,

  @JsonValue(0)
  average,

  @JsonValue(-1)
  stable,

  @JsonValue(-2)
  highlyStable,
}
