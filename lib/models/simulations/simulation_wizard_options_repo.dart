import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/models/simulations/enums.dart';
import 'package:sj_manager/models/db/team/team.dart';

class SimulationWizardOptionsRepo {
  SimulationWizardOptionsRepo();

  final _modeSubject = BehaviorSubject<SimulationMode?>.seeded(null);
  ValueStream<SimulationMode?> get modeStream => _modeSubject.stream;
  SimulationMode? get mode => modeStream.value;
  set mode(SimulationMode? value) {
    _modeSubject.add(value);
  }

  final _teamSubject = BehaviorSubject<Team?>.seeded(null);
  ValueStream<Team?> get teamStream => _teamSubject.stream;
  Team? get team => teamStream.value;
  set team(Team? value) {
    _teamSubject.add(value);
  }
}
