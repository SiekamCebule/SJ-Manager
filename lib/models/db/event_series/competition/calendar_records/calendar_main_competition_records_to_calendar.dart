import 'package:sj_manager/models/db/event_series/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/models/db/event_series/competition/calendar_records/converter.dart';
import 'package:sj_manager/models/db/event_series/competition/competition.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/competition_rules/competition_rules.dart';
import 'package:sj_manager/models/db/jumper/jumper.dart';
import 'package:sj_manager/models/db/team/team.dart';
import 'package:sj_manager/utils/iterable.dart';

class CalendarMainCompetitionRecordsToCalendarConveter
    implements
        EncapsulatedCompetitionRecordsToRawCompetitionsConverter<
            CalendarMainCompetitionRecord> {
  @override
  List<Competition> convert(List<CalendarMainCompetitionRecord> records) {
    final competitionsWhichShouldMoveBackIfHaveTeamCompBehind = <Competition>{};
    final calendar = records.expand(
      (record) {
        final rawComps = record.createRawCompetitions();
        if (record.preset.rules is CompetitionRules<Jumper>) {
          final trainings = rawComps.sublist(0, record.preset.trainingsRules.length);
          Competition? quals;
          if (record.preset.qualificationsRules != null) {
            quals = rawComps.penultimate;
          }
          if (record.preset.moveQualificationsBeforeTeamCompetition) {
            competitionsWhichShouldMoveBackIfHaveTeamCompBehind.addAll(trainings);
            if (quals != null) {
              competitionsWhichShouldMoveBackIfHaveTeamCompBehind.add(quals);
            }
          }
        }
        return rawComps;
      },
    ).toList();
    var currentRawCompOndexSubtraction = 0;
    for (var currentRawComp in calendar) {
      if (competitionsWhichShouldMoveBackIfHaveTeamCompBehind.contains(currentRawComp)) {
        final previous = _previous(current: currentRawComp, competitions: calendar);
        if (previous != null && previous.rules is CompetitionRules<Team>) {
          final currentIndex = calendar.indexOf(currentRawComp);
          final teamComps = <Competition>[previous];
          var firstTeamComp = previous;
          for (var i = currentIndex - 2;; i--) {
            final comp = calendar[currentIndex];
            if (comp.rules is CompetitionRules<Team> && comp.hill == previous.hill) {
              firstTeamComp = comp;
              teamComps.add(comp);
            } else {
              print('break at i of $i (starting was $currentIndex - 2)');
              break;
            }
          }
          final firstTeamCompIndex = calendar.indexOf(firstTeamComp);
          calendar.removeAt(currentIndex);
          calendar.insert(
              firstTeamCompIndex - currentRawCompOndexSubtraction, currentRawComp);
          calendar[firstTeamCompIndex - currentRawCompOndexSubtraction] = currentRawComp
              .copyWith(date: currentRawComp.date.subtract(const Duration(days: 1)));
          for (int i = 0; i < teamComps.length; i++) {
            teamComps[i] = teamComps[i]
                .copyWith(date: teamComps[i].date.add(const Duration(days: 1)));
          }
          currentRawCompOndexSubtraction += 1;

          // Jeszcze kolejność będzie kuleć trochę.
        } else {
          currentRawCompOndexSubtraction = 0;
        }

        // 1. Zbierz wszystkie konkursy ind. na 'hill', aż do momentu wystąpienia konkursu drużynowego
        // 2. Znajdź index pierwszego drużynowego konkursu
        // 3. Dodaj wszystkie zebrane konkursy ind. przed znalezionym powyżej indeksem
        // 4. Upewnij się, że kolejność jest okej (w razie potrzeby Iterable.reversed albo coś)
        // TODO: Max 3 trainings in a day
      }
    }
    return calendar;
  }

  Competition? _previous(
      {required Competition current, required List<Competition> competitions}) {
    final currentIndex = competitions.indexOf(current);
    if (currentIndex == 0) return null;
    if (currentIndex == -1) {
      throw StateError(
        'Cannot find the previous competition before $current, because competitions list does not even contain it',
      );
    }
    return competitions[currentIndex - 1];
  }

  Competition? _next(
      {required Competition current, required List<Competition> competitions}) {
    final currentIndex = competitions.indexOf(current);
    if (currentIndex == competitions.length - 1) return null;
    if (currentIndex == -1) {
      throw StateError(
        'Cannot find the next competition after $current, because competitions list does not even contain it',
      );
    }
    return competitions[currentIndex + 1];
  }
}
