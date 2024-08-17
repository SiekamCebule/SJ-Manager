import 'package:sj_manager/json/json_types.dart';

abstract class SimulationDbPartLoader<T extends Object> {
  const SimulationDbPartLoader();

  T load(Json json);
}
