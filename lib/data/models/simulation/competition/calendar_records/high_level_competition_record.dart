import 'package:sj_manager/data/models/simulation/competition/competition.dart';

abstract interface class HighLevelCompetitionRecord {
  const HighLevelCompetitionRecord();

  List<Competition> createRawCompetitions();
}
