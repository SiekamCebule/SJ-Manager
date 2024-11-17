import 'package:sj_manager/domain/entities/game_variant/hill/hill.dart';

double defaultHillPointsForMeter(Hill hill) {
  return switch (hill.k) {
    < 25 => 4.8,
    < 30 => 4.4,
    < 35 => 4.0,
    < 40 => 3.6,
    < 50 => 3.2,
    < 60 => 2.8,
    < 70 => 2.4,
    < 80 => 2.2,
    < 100 => 2.0,
    < 135 => 1.8,
    < 165 => 1.6,
    _ => 1.2,
  };
}

double defaultHillPointsForK(Hill hill) {
  return switch (hill.hs) {
    < 200 => 60,
    _ => 120,
  };
}
