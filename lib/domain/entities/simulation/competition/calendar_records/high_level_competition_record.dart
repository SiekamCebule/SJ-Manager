import 'package:sj_manager/domain/entities/simulation/competition/competition.dart';

abstract interface class HighLevelCompetitionRecord {
  const HighLevelCompetitionRecord();

  List<Competition> createRawCompetitions();
}
