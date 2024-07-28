import 'package:sj_manager/models/db/event_series/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/models/db/event_series/competition/calendar_records/converter.dart';
import 'package:sj_manager/models/db/event_series/competition/competition.dart';
import 'package:sj_manager/models/db/event_series/competition/competition_type.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/competition_rules/competition_rules.dart';
import 'package:sj_manager/models/db/hill/hill.dart';
import 'package:sj_manager/models/db/jumper/jumper.dart';
import 'package:sj_manager/models/db/team/team.dart';
import 'package:sj_manager/utils/iterable.dart';

class CalendarMainCompetitionRecordsToCalendarConverter
    implements LowLevelCalendarCreator<CalendarMainCompetitionRecord> {
  late List<CalendarMainCompetitionRecord> _highLevelCalendar;
  late List<Competition> _lowLevelCalendar;
  late Set<Competition> _competitionsWhichShouldMoveBackIfHaveTeamCompBehind;
  late List<Competition> _compsBelongingToTeamComp;
  late Competition _firstBelongingToTeamComp;
  late Competition _previousComp;

  static const _day = Duration(days: 1);

  @override
  List<Competition> convert(List<CalendarMainCompetitionRecord> highLevelCalendar) {
    _highLevelCalendar = highLevelCalendar;
    _competitionsWhichShouldMoveBackIfHaveTeamCompBehind = {};
    _createLowCalendarAndAppropriatelyMarkCompetitions();
    _moveAppropriateCompetitionsBehindTeamComps();
    _addDayForTrainingsAndTrialRoundsAfterCompetitionOrQualificationsIfSameDay();
    return _lowLevelCalendar;
  }

  void _createLowCalendarAndAppropriatelyMarkCompetitions() {
    _lowLevelCalendar = _highLevelCalendar.expand((highLevelComp) {
      final rawComps = highLevelComp.createRawCompetitions();
      _maybeMarkCompetitionItShouldMoveBehindTeamComp(
          highLevelComp: highLevelComp, rawComps: rawComps);
      return rawComps;
    }).toList();
  }

  void _maybeMarkCompetitionItShouldMoveBehindTeamComp(
      {required CalendarMainCompetitionRecord highLevelComp,
      required List<Competition> rawComps}) {
    if (highLevelComp.setup.mainCompRules is CompetitionRules<Jumper>) {
      final trainings = highLevelComp.setup.trainingsRules != null
          ? rawComps.sublist(0, highLevelComp.setup.trainingsRules!.length)
          : null;
      Competition? quals;
      if (highLevelComp.setup.qualificationsRules != null) {
        quals = highLevelComp.setup.trialRoundRules != null
            ? rawComps[rawComps.length - 3]
            : rawComps.penultimate;
      }
      if (highLevelComp.setup.moveQualificationsBeforeTeamCompetition) {
        if (trainings != null) {
          _competitionsWhichShouldMoveBackIfHaveTeamCompBehind.addAll(trainings);
        }
        if (quals != null) {
          _competitionsWhichShouldMoveBackIfHaveTeamCompBehind.add(quals);
        }
      }
    }
  }

  void _moveAppropriateCompetitionsBehindTeamComps() {
    for (var current in _lowLevelCalendar) {
      if (_compShouldMoveBackIfHaveTeamCompBehind(current)) {
        final prev = _previous(current: current);
        if (prev == null) break;
        _previousComp = prev;
        if (_isTeamCompWithSameHill(_previousComp, requiredHill: current.hill)) {
          _findFirstCompBelongingToTeamComp();
          final moved = _moveCompetitionBehindOther(
              toMove: current, other: _firstBelongingToTeamComp);
          _subtractCompDate(comp: moved, delta: _day);
        }
      }
    }
  }

  bool _compShouldMoveBackIfHaveTeamCompBehind(Competition comp) {
    return _competitionsWhichShouldMoveBackIfHaveTeamCompBehind.contains(comp);
  }

  Competition? _previous({required Competition current}) {
    final currentIndex = _lowLevelCalendar.indexOf(current);
    if (currentIndex == 0) return null;
    if (currentIndex == -1) {
      throw StateError(
        'Cannot find the previous competition before $current, because competitions list does not even contain it',
      );
    }
    return _lowLevelCalendar[currentIndex - 1];
  }

  bool _isTeamCompWithSameHill(Competition? comp, {required Hill requiredHill}) {
    return comp != null &&
        comp.rules is CompetitionRules<Team> &&
        comp.hill == requiredHill;
  }

  void _findFirstCompBelongingToTeamComp() {
    final teamComp = _previousComp;
    final firstOfTeamComp = _firstBelongingComp(
      begin: _previousComp,
      requiredHill: teamComp.hill,
    );
    if (teamComp == firstOfTeamComp) {
      _firstBelongingToTeamComp = teamComp;
    } else {
      _compsBelongingToTeamComp = _lowLevelCalendar.sublist(
        _lowLevelCalendar.indexOf(firstOfTeamComp),
        _lowLevelCalendar.indexOf(teamComp),
      );
      _firstBelongingToTeamComp = _compsBelongingToTeamComp.first;
    }
  }

  Competition _firstBelongingComp(
      {required Competition begin, required Hill requiredHill}) {
    var currentlyChecked = begin;
    while (true) {
      final previous = _previous(current: begin);
      if (previous != null) {
        currentlyChecked = previous;
      }
      bool shouldGoFurther = begin.type.index >= currentlyChecked.type.index &&
          requiredHill == currentlyChecked.hill;
      if (shouldGoFurther) {
        continue;
      } else {
        break;
      }
    }
    return currentlyChecked;
  }

  Competition _moveCompetitionBehindOther(
      {required Competition toMove, required Competition other}) {
    _lowLevelCalendar.remove(toMove);
    _lowLevelCalendar.insert(_lowLevelCalendar.indexOf(other), toMove);
    final toMoveIndex = _lowLevelCalendar.indexOf(toMove);
    return _lowLevelCalendar[toMoveIndex];
  }

  void _addCompDate({required Competition comp, required Duration delta}) {
    final index = _lowLevelCalendar.indexOf(comp);
    _lowLevelCalendar[index] =
        _lowLevelCalendar[index].copyWith(date: _lowLevelCalendar[index].date.add(delta));
  }

  void _subtractCompDate({required Competition comp, required Duration delta}) {
    final index = _lowLevelCalendar.indexOf(comp);
    _lowLevelCalendar[index] = _lowLevelCalendar[index]
        .copyWith(date: _lowLevelCalendar[index].date.subtract(delta));
  }

  void _addDayForTrainingsAndTrialRoundsAfterCompetitionOrQualificationsIfSameDay() {
    final compsToChange = <Competition>[];
    CompetitionType? prevCompType;
    DateTime? prevCompDate;
    for (var comp in _lowLevelCalendar) {
      final byCurrentCompType = comp.type == CompetitionType.training ||
          comp.type == CompetitionType.trialRound;
      final byPrevCompType = prevCompType != null &&
          (prevCompType == CompetitionType.competition ||
              prevCompType == CompetitionType.qualifications);
      final byDate = (prevCompDate != null) &&
          (_withoutTime(comp.date) == _withoutTime(prevCompDate));
      final shouldBeChanged = byCurrentCompType && byPrevCompType && byDate;
      if (shouldBeChanged) {
        compsToChange.add(comp);
      }
      prevCompType = comp.type;
      prevCompDate = comp.date;
    }
    for (var compToChange in compsToChange) {
      _addCompDate(comp: compToChange, delta: _day);
    }
  }

  DateTime _withoutTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }
}
