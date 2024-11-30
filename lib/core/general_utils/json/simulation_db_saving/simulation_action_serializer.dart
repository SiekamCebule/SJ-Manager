import 'dart:async';

import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action.dart';

class SimulationActionSerializer implements SimulationDbPartSerializer<SimulationAction> {
  const SimulationActionSerializer();

  @override
  FutureOr<Json> serialize(SimulationAction action) {
    return {
      'type': action.type,
      'deadline': action.deadline?.toString(),
      'isCompleted': action.isCompleted,
    };
  }
}
