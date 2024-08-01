import 'package:json_annotation/json_annotation.dart';

enum LandingStyle {
  @JsonValue(3)
  perfect,

  @JsonValue(2)
  veryGraceful,

  @JsonValue(1)
  graceful,

  @JsonValue(0)
  average,

  @JsonValue(-1)
  ugly,

  @JsonValue(-2)
  veryUgly,

  @JsonValue(-3)
  terrible,
}
