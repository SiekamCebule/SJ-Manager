import 'package:json_annotation/json_annotation.dart';

enum HillProfileType {
  @JsonValue(2)
  highlyFavorsInFlight,

  @JsonValue(1)
  favorsInFlight,

  @JsonValue(0)
  balanced,

  @JsonValue(-1)
  favorsInTakeoff,

  @JsonValue(-2)
  highlyFavorsInTakeoff,
}
