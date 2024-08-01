import 'package:sj_manager/models/simulation_db/classification/classification.dart';
import 'package:sj_manager/models/simulation_db/competition/calendar_records/high_level_competition_record.dart';

class HighLevelCalendar<C extends HighLevelCompetitionRecord> {
  const HighLevelCalendar({
    required this.highLevelCompetitions,
    required this.classifications,
  });

  final List<C> highLevelCompetitions;
  final List<Classification> classifications;
}
