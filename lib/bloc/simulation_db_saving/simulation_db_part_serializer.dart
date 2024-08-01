import 'package:sj_manager/json/json_types.dart';

abstract class SimulationDbPartSerializer<T extends Object> {
  const SimulationDbPartSerializer();

  Json serialize(T input);
}
