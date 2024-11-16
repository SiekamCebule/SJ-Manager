// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sj_manager/data/models/simulation/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/data/models/simulation/competition/high_level_calendar.dart';
import 'package:sj_manager/data/models/simulation/event_series/event_series_calendar_preset.dart';

class SimpleCalendarEditingCubit extends Cubit<SimpleCalendarEditingState> {
  SimpleCalendarEditingCubit({
    required SimpleEventSeriesCalendarPreset preset,
  }) : super(
          SimpleCalendarEditingState(highLevelCalendar: preset.highLevelCalendar),
        );

  void addCompetition(CalendarMainCompetitionRecord record, int index) {
    final newList = List.of(state.highLevelCalendar.highLevelCompetitions);
    newList.insert(index, record);
    emit(state.copyWithCompetitions(highLevelCompetitions: newList));
  }

  void replaceCompetition(
      {required int index, required CalendarMainCompetitionRecord record}) {
    final newList = List.of(state.highLevelCalendar.highLevelCompetitions);
    newList[index] = record;
    emit(state.copyWithCompetitions(highLevelCompetitions: newList));
  }

  void moveCompetition({
    required int from,
    required int to,
  }) {
    final newList = List.of(state.highLevelCalendar.highLevelCompetitions);
    final removed = newList.removeAt(from);
    newList.insert(to, removed);
    emit(state.copyWithCompetitions(highLevelCompetitions: newList));
  }

  void removeCompetitionAt(int index) {
    final newList = List.of(state.highLevelCalendar.highLevelCompetitions);
    newList.removeAt(index);
    emit(state.copyWithCompetitions(highLevelCompetitions: newList));
  }
}

class SimpleCalendarEditingState with EquatableMixin {
  const SimpleCalendarEditingState({
    required this.highLevelCalendar,
  });

  final HighLevelCalendar<CalendarMainCompetitionRecord> highLevelCalendar;

  List<CalendarMainCompetitionRecord> get competitionRecords =>
      highLevelCalendar.highLevelCompetitions;

  @override
  List<Object?> get props => [
        highLevelCalendar,
      ];

  SimpleCalendarEditingState copyWithCompetitions({
    List<CalendarMainCompetitionRecord>? highLevelCompetitions,
  }) {
    return SimpleCalendarEditingState(
      highLevelCalendar:
          highLevelCalendar.copyWith(highLevelCompetitions: highLevelCompetitions),
    );
  }

  SimpleCalendarEditingState copyWith({
    HighLevelCalendar<CalendarMainCompetitionRecord>? highLevelCalendar,
  }) {
    return SimpleCalendarEditingState(
      highLevelCalendar: highLevelCalendar ?? this.highLevelCalendar,
    );
  }
}
