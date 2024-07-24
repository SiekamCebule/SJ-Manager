import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/models/simulations/enums.dart';
import 'package:sj_manager/models/simulations/team.dart';

class SimulationWizardOptionsRepo {
  SimulationWizardOptionsRepo();

  final _modeSubject = BehaviorSubject<SimulationMode?>.seeded(null);
  ValueStream<SimulationMode?> get modeStream => _modeSubject.stream;
  SimulationMode? get mode => modeStream.value;
  set mode(SimulationMode? value) {
    _modeSubject.add(value);
  }

  final _teamSubject = BehaviorSubject<CountryTeam?>.seeded(null);
  ValueStream<CountryTeam?> get teamStream => _teamSubject.stream;
  CountryTeam? get team => teamStream.value;
  set team(CountryTeam? value) {
    _teamSubject.add(value);
  }
}
