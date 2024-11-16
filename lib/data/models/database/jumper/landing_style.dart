import 'package:json_annotation/json_annotation.dart';

enum LandingStyle {
  @JsonValue(3)
  veryGraceful,

  @JsonValue(2)
  graceful,

  @JsonValue(1)
  quiteGraceful,

  @JsonValue(0)
  average,

  @JsonValue(-1)
  slightlyUgly,

  @JsonValue(-2)
  ugly,

  @JsonValue(-3)
  veryUgly,
}
