import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';

class SimulationDatabaseCubit extends Cubit<SimulationDatabase> {
  SimulationDatabaseCubit({required SimulationDatabase initial}) : super(initial);

  void update(SimulationDatabase database) {
    //print('update db: $database');
    emit(database);
  }
}
