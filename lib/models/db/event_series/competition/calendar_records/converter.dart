import 'package:sj_manager/models/db/event_series/competition/calendar_records/encapsulated_competition_record.dart';
import 'package:sj_manager/models/db/event_series/competition/competition.dart';

abstract interface class EncapsulatedCompetitionRecordsToRawCompetitionsConverter<
    T extends EncapsulatedCompetitionRecord> {
  List<Competition> convert(List<T> records);
}
