import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/filters/filter.dart';

class DbFiltersRepo with EquatableMixin {
  DbFiltersRepo({Map<Type, BehaviorSubject<List<Filter>>> initial = const {}})
      : _filtersByType = Map.of(initial);

  final Map<Type, BehaviorSubject<List<Filter>>> _filtersByType;

  void set<T>(List<Filter<T>> filters) {
    if (_filtersByType.containsKey(T)) {
      _filtersByType[T]!.add(filters);
    } else {
      _filtersByType[T] = BehaviorSubject<List<Filter<T>>>.seeded(filters);
    }
  }

  void setByGenericAndArgumentType<T>(
      {required Type type, required List<Filter<T>> filters}) {
    if (_filtersByType.containsKey(type)) {
      _filtersByType[type]!.add(filters);
    } else {
      _filtersByType[type] = BehaviorSubject<List<Filter<T>>>.seeded(filters);
    }
  }

  void clear() {
    _filtersByType.forEach((type, filters) {
      filters.add([]);
    });
  }

  void close() {
    _filtersByType.forEach((type, filters) {
      filters.close();
    });
  }

  ValueStream<List<Filter<T>>> stream<T>() {
    /*if (!containsType(T)) {
      throw _doesNotHaveTypeInMap(T);
    }*/
    return (_filtersByType[T]?.stream as ValueStream<List<Filter<T>>>?) ?? _neverStream();
  }

  ValueStream<List<Filter>> streamByTypeArgument(Type type) {
    /*if (!containsType(type)) {
      throw _doesNotHaveTypeInMap(type);
    }*/
    return _filtersByType[type]?.stream ?? _neverStream();
  }

  static _doesNotHaveTypeInMap(Type type) =>
      StateError('The DbFiltersRepo does not have a filters list subject for type $type');

  bool containsType(Type type) => _filtersByType.containsKey(type);

  bool get hasValidFilter {
    return _filtersByType.values.any((filtersSubject) {
      return filtersSubject.value.any((filter) => filter.isValid);
    });
  }

  ValueStream<T> _neverStream<T>() => BehaviorSubject<T>()
    ..close()
    ..stream;

  @override
  List<Object?> get props => [
        _filtersByType,
      ];
}
