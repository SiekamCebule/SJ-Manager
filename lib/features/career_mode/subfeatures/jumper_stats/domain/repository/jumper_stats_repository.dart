import 'package:sj_manager/features/career_mode/subfeatures/jumper_stats/domain/entities/jumper_attribute.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/stats/jumper_attribute_history.dart';

abstract interface class JumperStatsRepository {
  Future<JumperAttributeHistory> getAttributeHistory({
    required SimulationJumper jumper,
    required JumperAttributeType attribute,
  });
  Future<void> registerAttributeChange({
    required SimulationJumper jumper,
    required JumperAttributeType attribute,
    required DateTime date,
    required double delta,
  });
}
