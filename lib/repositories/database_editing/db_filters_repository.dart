import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/enums/database_item_type.dart';
import 'package:sj_manager/filters/filter.dart';
import 'package:sj_manager/models/hill/hill.dart';
import 'package:sj_manager/models/jumper/jumper.dart';

class DbFiltersRepository {
  DbFiltersRepository();

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
    return onMaleJumpers || onFemaleJumpers;
  }

  List<Filter<dynamic>> filtersByType(DatabaseItemType type) {
    return switch (type) {
      DatabaseItemType.maleJumper => maleJumpersFilters.value,
      DatabaseItemType.femaleJumper => femaleJumpersFilters.value,
      DatabaseItemType.hill => hillsFilters.value,
    };
  }
}
