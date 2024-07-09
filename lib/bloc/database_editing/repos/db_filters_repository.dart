import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/enums/database_item_type.dart';
import 'package:sj_manager/filters/filter.dart';
import 'package:sj_manager/models/jumper.dart';

class DbFiltersRepository {
  DbFiltersRepository();

  final _maleJumpersSubject = BehaviorSubject<Set<Filter<Jumper>>>.seeded({});
  final _femaleJumpersSubject = BehaviorSubject<Set<Filter<Jumper>>>.seeded({});

  void setJumpersFilters(Set<Filter<Jumper>> filters) {
    _maleJumpersSubject.add(filters);
    _femaleJumpersSubject.add(filters);
  }

  ValueStream<Set<Filter<Jumper>>> get maleJumpersFilters => _maleJumpersSubject.stream;
  ValueStream<Set<Filter<Jumper>>> get femaleJumpersFilters =>
      _femaleJumpersSubject.stream;

  Set<Filter<Jumper>> byType(DatabaseItemType type) {
    return switch (type) {
      DatabaseItemType.maleJumper => maleJumpersFilters.value,
      DatabaseItemType.femaleJumper => femaleJumpersFilters.value,
    };
  }
}
