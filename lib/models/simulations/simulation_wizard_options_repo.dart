import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/models/db/country.dart';
import 'package:sj_manager/models/simulations/enums.dart';

class SimulationWizardOptionsRepo {
  SimulationWizardOptionsRepo();

  final _modeSubject = BehaviorSubject<SimulationMode?>.seeded(null);
  ValueStream<SimulationMode?> get modeStream => _modeSubject.stream;
  SimulationMode? get mode => modeStream.value;
  set mode(SimulationMode? value) {
    _modeSubject.add(value);
  }

  final _countrySubject = BehaviorSubject<Country?>.seeded(null);
  ValueStream<Country?> get countryStream => _countrySubject.stream;
  Country? get country => countryStream.value;
  set country(Country? value) {
    _countrySubject.add(value);
  }
}
