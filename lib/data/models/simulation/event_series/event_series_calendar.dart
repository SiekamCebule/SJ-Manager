import 'package:equatable/equatable.dart';
import 'package:sj_manager/data/models/simulation/classification/classification.dart';
import 'package:sj_manager/data/models/simulation/competition/competition.dart';

class EventSeriesCalendar with EquatableMixin {
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

  @override
  List<Object?> get props => [
        competitions,
        classifications,
        qualifications,
      ];
}
