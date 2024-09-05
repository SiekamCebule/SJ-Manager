import 'package:sj_manager/models/simulation_db/classification/classification.dart';
import 'package:sj_manager/models/simulation_db/competition/competition.dart';

class EventSeriesCalendar {
  const EventSeriesCalendar({
    required this.competitions,
    required this.classifications,
    required this.qualifications,
  });

  const EventSeriesCalendar.empty()
      : this(
          competitions: const [],
          classifications: const [],
          qualifications: const {},
        );

  final List<Competition> competitions;
  final List<Classification> classifications;
  final Map<Competition, Competition> qualifications;

  bool get isEmpty {
    return competitions.isEmpty && classifications.isEmpty;
  }

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
