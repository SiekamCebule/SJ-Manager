import 'package:sj_manager/models/db/event_series/classification/classification.dart';
import 'package:sj_manager/models/db/event_series/competition/competition.dart';

class EventSeriesCalendar {
  const EventSeriesCalendar({
    required this.competitions,
    required this.classifications,
    required this.qualifications,
  });

  final List<Competition> competitions;
  final List<Classification> classifications;
  final Map<Competition, Competition> qualifications;

  List<Competition> compsWhoseQualsAre(Competition competition) {
    final areQualificationsForCompetiton = <Competition>[];
    for (final entry in qualifications.entries) {
      if (entry.value == competition) {
        areQualificationsForCompetiton.add(entry.key);
      }
    }
    return areQualificationsForCompetiton;
  }
}
