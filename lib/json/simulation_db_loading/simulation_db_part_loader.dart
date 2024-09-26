import 'dart:async';

import 'package:sj_manager/json/json_types.dart';

abstract class SimulationDbPartParser<T extends Object> {
  const SimulationDbPartParser();

  FutureOr<T> parse(Json json);
}
