import 'package:sj_manager/models/simulation_db/classification/classification.dart';
import 'package:sj_manager/models/simulation_db/competition/calendar_records/high_level_competition_record.dart';
import 'package:equatable/equatable.dart';

class HighLevelCalendar<C extends HighLevelCompetitionRecord> with EquatableMixin {
  const HighLevelCalendar({
    required this.highLevelCompetitions,
    required this.classifications,
  });

  const HighLevelCalendar.empty()
      : this(highLevelCompetitions: const [], classifications: const []);

  final List<C> highLevelCompetitions;
  final List<Classification> classifications;

  HighLevelCalendar<C> copyWith({
    List<C>? highLevelCompetitions,
    List<Classification>? classifications,
  }) {
    return HighLevelCalendar<C>(
      highLevelCompetitions: highLevelCompetitions ?? this.highLevelCompetitions,
      classifications: classifications ?? this.classifications,
    );
  }

  @override
  List<Object?> get props => [highLevelCompetitions, classifications];
}
