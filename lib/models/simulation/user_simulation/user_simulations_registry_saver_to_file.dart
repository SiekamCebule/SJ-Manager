import 'package:sj_manager/json/db_items_json.dart';
import 'package:sj_manager/models/simulation/user_simulation/user_simulation.dart';
import 'package:sj_manager/utils/file_system.dart';
import 'package:path/path.dart' as path;

class UserSimulationsRegistrySaverToFile {
  const UserSimulationsRegistrySaverToFile({
    required this.userSimulations,
    required this.pathsCache,
  });

  final List<UserSimulation> userSimulations;
  final PlarformSpecificPathsCache pathsCache;

  Future<void> serialize() async {
    final file = userDataFile(pathsCache, path.join('simulations', 'simulations.json'));
    await saveItemsListToJsonFile(
      file: file,
      items: userSimulations,
      toJson: (userSimulation) => userSimulation.toJson(),
      pretty: true,
    );
  }
}
