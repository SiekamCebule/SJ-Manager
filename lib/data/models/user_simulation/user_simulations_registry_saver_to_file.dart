import 'package:sj_manager/utilities/json/db_items_json.dart';
import 'package:sj_manager/data/models/user_simulation/simulation_model.dart';
import 'package:sj_manager/utilities/utils/file_system.dart';
import 'package:path/path.dart' as path;

class UserSimulationsRegistrySaverToFile {
  const UserSimulationsRegistrySaverToFile({
    required this.userSimulations,
    required this.pathsCache,
  });

  final List<SimulationModel> userSimulations;
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
