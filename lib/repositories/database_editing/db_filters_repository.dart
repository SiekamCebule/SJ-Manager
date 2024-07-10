import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/enums/database_item_type.dart';
import 'package:sj_manager/filters/filter.dart';
import 'package:sj_manager/models/hill/hill.dart';
import 'package:sj_manager/models/jumper/jumper.dart';

class DbFiltersRepository {
  DbFiltersRepository();

  final _maleJumpersFilters = BehaviorSubject<Set<Filter<Jumper>>>.seeded({});
  final _femaleJumpersFilters = BehaviorSubject<Set<Filter<Jumper>>>.seeded({});
  final _hillsFilters = BehaviorSubject<Set<Filter<Hill>>>.seeded({});

  void setJumpersFilters(Set<Filter<Jumper>> filters) {
    _maleJumpersFilters.add(filters);
    _femaleJumpersFilters.add(filters);
  }

  void setHillsFilters(Set<Filter<Hill>> filters) {
    _hillsFilters.add(filters);
  }

  ValueStream<Set<Filter<Jumper>>> get maleJumpersFilters => _maleJumpersFilters.stream;
  ValueStream<Set<Filter<Jumper>>> get femaleJumpersFilters =>
      _femaleJumpersFilters.stream;
  ValueStream<Set<Filter<Hill>>> get hillsFilters => _hillsFilters.stream;

  bool get hasValidFilter {
    final onMaleJumpers =
        _maleJumpersFilters.value.where((filter) => filter.isValid).isNotEmpty;
    final onFemaleJumpers =
        _femaleJumpersFilters.value.where((filter) => filter.isValid).isNotEmpty;
    return onMaleJumpers || onFemaleJumpers;
  }

  Set<Filter<dynamic>> filtersByType(DatabaseItemType type) {
    return switch (type) {
      DatabaseItemType.maleJumper => maleJumpersFilters.value,
      DatabaseItemType.femaleJumper => femaleJumpersFilters.value,
      DatabaseItemType.hill => hillsFilters.value,
    };
  }
}
