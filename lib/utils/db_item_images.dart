import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';

/// Example: 'aut_stefan_huber'
String jumperImageName(Jumper jumper) {
  return '${jumper.country.code.toLowerCase()}_${jumper.name.toLowerCase()}_${jumper.surname.toLowerCase()}'
      .replaceAll(' ', '_');
}

/// Example: 'planica_240'
String hillImageName(Hill hill) {
  return '${hill.locality.toLowerCase()}_${hill.hs.truncate().toString()}'
      .replaceAll(' ', '_');
}
