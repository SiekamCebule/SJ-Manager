import 'package:sj_manager/json/json_types.dart';

abstract class SimulationDbPartParser<T extends Object> {
  const SimulationDbPartParser();

  T parse(Json json);
}
