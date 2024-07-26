import 'package:sj_manager/models/db/event_series/competition/competition.dart';

abstract interface class EncapsulatedCompetitionRecord {
  const EncapsulatedCompetitionRecord();

  List<Competition> createRawCompetitions();
}
