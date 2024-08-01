import 'package:sj_manager/models/simulation_db/competition/competition.dart';

abstract interface class HighLevelCompetitionRecord {
  const HighLevelCompetitionRecord();

  List<Competition> createRawCompetitions();
}
