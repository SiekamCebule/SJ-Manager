import 'dart:async';

import 'package:sj_manager/core/general_utils/json/json_types.dart';

abstract class SimulationDbPartParser<T extends Object> {
  const SimulationDbPartParser();

  FutureOr<T> parse(Json json);
}
