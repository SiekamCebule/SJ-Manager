import 'package:sj_manager/models/database/hill/hill.dart';
import 'package:sj_manager/models/database/jumper/jumper_db_record.dart';
import 'package:sj_manager/models/simulation/jumper/simulation_jumper.dart';

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
