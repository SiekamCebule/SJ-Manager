import 'package:sj_manager/models/db/event_series/competition/calendar_records/encapsulated_competition_record.dart';
import 'package:sj_manager/models/db/event_series/competition/calendar_records/calendar_main_competition_record_setup.dart';
import 'package:sj_manager/models/db/event_series/competition/competition.dart';
import 'package:sj_manager/models/db/hill/hill.dart';

class CalendarMainCompetitionRecord implements EncapsulatedCompetitionRecord {
  const CalendarMainCompetitionRecord({
    required this.hill,
    required this.date,
    required this.preset,
  });

  final Hill hill;
  final DateTime date;
  final CalendarMainCompetitionRecordSetup preset;

  @override
  List<Competition> createRawCompetitions() {
    return _Converter().convert(this);
  }
}

class _Converter {
  List<Competition> convert(CalendarMainCompetitionRecord record) {
    var trainingsDateSubtraction = Duration.zero;

    Competition? trialRound;
    if (record.preset.trialRoundRules != null) {
      trainingsDateSubtraction = const Duration(days: 1);
      trialRound = Competition(
        hill: record.hill,
        date: record.date,
        rules: record.preset.trialRoundRules!,
      );
    }

    final trainings = record.preset.trainingsRules.map((rules) {
      return Competition(
        hill: record.hill,
        date: record.date.subtract(trainingsDateSubtraction),
        rules: rules,
      );
    });

    final mainCompetition = Competition(
      hill: record.hill,
      date: record.date,
      rules: record.preset.rules,
    );

    final comps = [
      ...trainings,
      if (trialRound != null) trialRound,
      mainCompetition,
    ];

    return comps;
  }
}
