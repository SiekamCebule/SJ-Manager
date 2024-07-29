import 'package:sj_manager/models/db/event_series/competition/competition.dart';

class CompetitionInCalendarConfig<T> {
  const CompetitionInCalendarConfig({
    required this.qualifications,
    required this.areQualificationsFor,
    required this.composeStartlist,
  });

  final Competition<T>? qualifications;
  final List<Competition<T>> areQualificationsFor;
  final Startlist<T> Function(Startlist<T> nonSorted) composeStartlist;
}

// TODO: Do work around startlist
typedef Startlist<T> = List<T>;
