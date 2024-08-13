import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules_preset.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';

class DatabaseItemsTypeCubit extends Cubit<Type> {
  DatabaseItemsTypeCubit() : super(MaleJumper);

  void select(int index) {
    emit(
      switch (index) {
        0 => MaleJumper,
        1 => FemaleJumper,
        2 => Hill,
        3 => EventSeriesSetup,
        4 => EventSeriesCalendar,
        5 => CompetitionRulesPreset,
        _ => throw TypeError(),
      },
    );
  }

  void setType(Type type) {
    emit(type);
  }
}
