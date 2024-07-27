import 'package:sj_manager/models/db/event_series/competition/competition.dart';

abstract interface class HighLevelCompetitionRecord {
  const HighLevelCompetitionRecord();

  List<Competition> createRawCompetitions();
}
