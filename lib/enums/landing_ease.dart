import 'package:json_annotation/json_annotation.dart';

enum LandingEase {
  @JsonValue(3)
  veryHigh,

  @JsonValue(2)
  high,

  @JsonValue(1)
  fairlyHigh,

  @JsonValue(0)
  average,

  @JsonValue(-1)
  fairlyLow,

  @JsonValue(-2)
  low,

  @JsonValue(-3)
  veryLow,
}
