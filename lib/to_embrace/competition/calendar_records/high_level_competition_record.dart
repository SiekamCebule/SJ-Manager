import 'package:sj_manager/to_embrace/competition/competition.dart';

abstract interface class HighLevelCompetitionRecord {
  const HighLevelCompetitionRecord();

  List<Competition> createRawCompetitions();
}
