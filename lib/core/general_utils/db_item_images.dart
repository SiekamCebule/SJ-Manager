import 'package:sj_manager/core/core_classes/hill/hill.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

/// Example: 'aut_stefan_huber'
String jumperDbRecordImageName(JumperDbRecord jumper) {
  return '${jumper.country.code.toLowerCase()}_${jumper.name.toLowerCase()}_${jumper.surname.toLowerCase()}'
      .replaceAll(' ', '_');
}

String simulationJumperImageName(SimulationJumper jumper) {
  return '${jumper.country.code.toLowerCase()}_${jumper.name.toLowerCase()}_${jumper.surname.toLowerCase()}'
      .replaceAll(' ', '_');
}

/// Example: 'planica_240'
String hillImageName(Hill hill) {
  return '${hill.locality.toLowerCase()}_${hill.hs.truncate().toString()}'
      .replaceAll(' ', '_');
}
