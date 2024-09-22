import 'package:json_annotation/json_annotation.dart';

enum JumpsConsistency {
  @JsonValue(3)
  veryConsistent,

  @JsonValue(2)
  consistent,

  @JsonValue(1)
  quiteConsistent,

  @JsonValue(0)
  average,

  @JsonValue(-1)
  slightlyInconsistent,

  @JsonValue(-1)
  inconsistent,

  @JsonValue(-2)
  veryInconsistent,
}
