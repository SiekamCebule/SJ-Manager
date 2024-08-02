import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/enums/db_editable_item_type.dart';
import 'package:sj_manager/filters/filter.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';

class DbFiltersRepo {
  DbFiltersRepo();

  final _maleJumpersFilters = BehaviorSubject<List<Filter<Jumper>>>.seeded([]);
  final _femaleJumpersFilters = BehaviorSubject<List<Filter<Jumper>>>.seeded([]);
  final _hillsFilters = BehaviorSubject<List<Filter<Hill>>>.seeded([]);

  void setMaleAndFemaleJumpersFilters(List<Filter<Jumper>> filters) {
    setMaleJumpersFilters(filters);
    setFemaleJumpersFilters(filters);
  }

  void setMaleJumpersFilters(List<Filter<Jumper>> filters) {
    _maleJumpersFilters.add(filters);
  }

  void setFemaleJumpersFilters(List<Filter<Jumper>> filters) {
    _femaleJumpersFilters.add(filters);
  }

  void setHillsFilters(List<Filter<Hill>> filters) {
    _hillsFilters.add(filters);
  }

  void clear() {
    setMaleJumpersFilters([]);
    setFemaleJumpersFilters([]);
    setHillsFilters([]);
  }

  void close() {
    _maleJumpersFilters.close();
    _femaleJumpersFilters.close();
    _hillsFilters.close();
  }

  ValueStream<List<Filter<Jumper>>> get maleJumpersFilters => _maleJumpersFilters.stream;
  ValueStream<List<Filter<Jumper>>> get femaleJumpersFilters =>
      _femaleJumpersFilters.stream;
  ValueStream<List<Filter<Hill>>> get hillsFilters => _hillsFilters.stream;

  bool get hasValidFilter {
    final onMaleJumpers =
        _maleJumpersFilters.value.where((filter) => filter.isValid).isNotEmpty;
    final onFemaleJumpers =
        _femaleJumpersFilters.value.where((filter) => filter.isValid).isNotEmpty;
    final onHills = _hillsFilters.value.where((filter) => filter.isValid).isNotEmpty;
    return onMaleJumpers || onFemaleJumpers || onHills;
  }

  ValueStream<List<Filter<dynamic>>> byType(DbEditableItemType type) {
    return switch (type) {
      DbEditableItemType.maleJumper => maleJumpersFilters,
      DbEditableItemType.femaleJumper => femaleJumpersFilters,
      DbEditableItemType.hill => hillsFilters,
      DbEditableItemType.eventSeriesSetup => _neverStream(),
      DbEditableItemType.eventSeriesCalendarPreset => _neverStream(),
      DbEditableItemType.competitionRulesPreset => _neverStream(),
    };
  }

  ValueStream<T> _neverStream<T>() => BehaviorSubject<T>()
    ..close()
    ..stream;
}
