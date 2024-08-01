import 'package:json_annotation/json_annotation.dart';
import 'package:osje_sim/osje_sim.dart';

enum TypicalWindDirection {
  @JsonValue('headwind')
  headwind,

  @JsonValue('leftHeadwind')
  leftHeadwind,

  @JsonValue('rightHeadwind')
  rightHeadwind,

  @JsonValue('leftWind')
  leftWind,

  @JsonValue('rightWind')
  rightWind,

  @JsonValue('leftTailwind')
  leftTailwind,

  @JsonValue('rightTailwind')
  rightTailwind,

  @JsonValue('tailwind')
  tailwind;

  Degrees get degrees {
    return switch (this) {
      TypicalWindDirection.headwind => Degrees(0),
      TypicalWindDirection.leftHeadwind => Degrees(315),
      TypicalWindDirection.rightHeadwind => Degrees(45),
      TypicalWindDirection.leftWind => Degrees(270),
      TypicalWindDirection.rightWind => Degrees(90),
      TypicalWindDirection.leftTailwind => Degrees(225),
      TypicalWindDirection.rightTailwind => Degrees(135),
      TypicalWindDirection.tailwind => Degrees(180),
    };
  }
}
