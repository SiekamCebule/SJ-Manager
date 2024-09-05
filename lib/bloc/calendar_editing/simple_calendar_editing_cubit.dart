// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sj_manager/models/simulation_db/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar_preset.dart';

class SimpleCalendarEditingCubit extends Cubit<SimpleCalendarEditingState> {
  SimpleCalendarEditingCubit({
    required SimpleEventSeriesCalendarPreset preset,
  }) : super(
          SimpleCalendarEditingState(
              competitionRecords: preset.highLevelCalendar.highLevelCompetitions),
        );

  void add(CalendarMainCompetitionRecord record, int index) {
    final newList = List.of(state.competitionRecords);
    newList.insert(index, record);
    emit(state.copyWith(competitionRecords: newList));
  }

  void removeAt(int index) {
    final newList = List.of(state.competitionRecords);
    newList.removeAt(index);
    emit(state.copyWith(competitionRecords: newList));
  }
}

class SimpleCalendarEditingState with EquatableMixin {
  const SimpleCalendarEditingState({
    required this.competitionRecords,
  });

  final List<CalendarMainCompetitionRecord> competitionRecords;

  @override
  List<Object?> get props => [];

  SimpleCalendarEditingState copyWith({
    List<CalendarMainCompetitionRecord>? competitionRecords,
  }) {
    return SimpleCalendarEditingState(
      competitionRecords: competitionRecords ?? this.competitionRecords,
    );
  }
}
