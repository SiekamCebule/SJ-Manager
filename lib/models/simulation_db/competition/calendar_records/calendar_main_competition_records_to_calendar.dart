import 'package:sj_manager/models/simulation_db/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/models/simulation_db/competition/calendar_records/converter.dart';
import 'package:sj_manager/models/simulation_db/competition/competition.dart';
import 'package:sj_manager/models/simulation_db/competition/competition_type.dart';
import 'package:sj_manager/models/simulation_db/competition/high_level_calendar.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/utils/iterable.dart';

class CalendarMainCompetitionRecordsToCalendarConverter
    implements LowLevelCalendarCreator<CalendarMainCompetitionRecord> {
  late List<CalendarMainCompetitionRecord> _highLevelComps;
  late List<Competition> _lowLevelComps;
  var _qualifications = <Competition, Competition>{};
  late Set<Competition> _competitionsWhichShouldMoveBackIfHaveTeamCompBehind;
  late List<Competition> _compsBelongingToTeamComp;
  late Competition _firstBelongingToTeamComp;
  late Competition _previousComp;

  static const _day = Duration(days: 1);

  @override
  EventSeriesCalendar convert(
      HighLevelCalendar<CalendarMainCompetitionRecord> highLevelCalendar) {
    _qualifications = {};
    _highLevelComps = highLevelCalendar.highLevelCompetitions;
    _competitionsWhichShouldMoveBackIfHaveTeamCompBehind = {};
    _createLowCalendarAndAppropriatelyMarkCompetitions();
    _moveAppropriateCompetitionsBehindTeamComps();
    _addDayForTrainingsAndTrialRoundsAfterCompetitionOrQualificationsIfSameDay();

    return EventSeriesCalendar(
      competitions: _lowLevelComps,
      classifications: highLevelCalendar.classifications,
      qualifications: _qualifications,
    );
  }

  void _createLowCalendarAndAppropriatelyMarkCompetitions() {
    _lowLevelComps = _highLevelComps.expand((highLevelComp) {
      final rawComps = highLevelComp.createRawCompetitions();
      if (highLevelComp.setup.qualificationsRules != null) {
        _qualifications[rawComps.last] = rawComps.penultimate;
      }
      _maybeMarkCompetitionItShouldMoveBehindTeamComp(
          highLevelComp: highLevelComp, rawComps: rawComps);
      return rawComps;
    }).toList();
  }

  void _maybeMarkCompetitionItShouldMoveBehindTeamComp(
      {required CalendarMainCompetitionRecord highLevelComp,
      required List<Competition> rawComps}) {
    if (highLevelComp.setup.mainCompRules is DefaultCompetitionRules<Jumper>) {
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
    for (var current in _lowLevelComps) {
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
    final currentIndex = _lowLevelComps.indexOf(current);
    if (currentIndex == 0) return null;
    if (currentIndex == -1) {
      throw StateError(
        'Cannot find the previous competition before $current, because competitions list does not even contain it',
      );
    }
    return _lowLevelComps[currentIndex - 1];
  }

  bool _isTeamCompWithSameHill(Competition? comp, {required Hill requiredHill}) {
    return comp != null &&
        comp.rules is DefaultCompetitionRules<Team> &&
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
      _compsBelongingToTeamComp = _lowLevelComps.sublist(
        _lowLevelComps.indexOf(firstOfTeamComp),
        _lowLevelComps.indexOf(teamComp),
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
      bool shouldGoFurther =
          _competitionType(begin)!.index >= _competitionType(currentlyChecked)!.index &&
              requiredHill == currentlyChecked.hill;
      if (shouldGoFurther) {
        continue;
      } else {
        break;
      }
    }
    return currentlyChecked;
  }

  CompetitionType? _competitionType(Competition competition) {
    final types = competition.labels.whereType<CompetitionType>();
    if (types.length > 1) {
      throw StateError(
          'The competition ($competition) has more than two competition types');
    }
    return types.singleOrNull;
  }

  Competition _moveCompetitionBehindOther(
      {required Competition toMove, required Competition other}) {
    _lowLevelComps.remove(toMove);
    _lowLevelComps.insert(_lowLevelComps.indexOf(other), toMove);
    final toMoveIndex = _lowLevelComps.indexOf(toMove);
    return _lowLevelComps[toMoveIndex];
  }

  void _addCompDate({required Competition comp, required Duration delta}) {
    final index = _lowLevelComps.indexOf(comp);
    _lowLevelComps[index] =
        _lowLevelComps[index].copyWith(date: _lowLevelComps[index].date.add(delta));
  }

  void _subtractCompDate({required Competition comp, required Duration delta}) {
    final index = _lowLevelComps.indexOf(comp);
    _lowLevelComps[index] =
        _lowLevelComps[index].copyWith(date: _lowLevelComps[index].date.subtract(delta));
  }

  void _addDayForTrainingsAndTrialRoundsAfterCompetitionOrQualificationsIfSameDay() {
    final compsToChange = <Competition>[];
    CompetitionType? prevCompType;
    DateTime? prevCompDate;
    for (var comp in _lowLevelComps) {
      final compType = _competitionType(comp);
      final byCurrentCompType =
          compType == CompetitionType.training || compType == CompetitionType.trialRound;
      final byPrevCompType = prevCompType != null &&
          (prevCompType == CompetitionType.competition ||
              prevCompType == CompetitionType.qualifications);
      final byDate = (prevCompDate != null) &&
          (_withoutTime(comp.date) == _withoutTime(prevCompDate));
      final shouldBeChanged = byCurrentCompType && byPrevCompType && byDate;
      if (shouldBeChanged) {
        compsToChange.add(comp);
      }
      prevCompType = compType;
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
