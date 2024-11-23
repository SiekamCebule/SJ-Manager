import 'package:equatable/equatable.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';

class JumperAttributeHistory with EquatableMixin {
  JumperAttributeHistory({
    required this.values,
    this.limit,
  });

  JumperAttributeHistory.empty({this.limit}) : values = {};

  final Map<DateTime, num> values;
  final int? limit;

  Map<DateTime, num> filterByDatesRange(DateTime start, DateTime end) {
    assert(start.isBefore(end));
    final filteredValues = Map.of(values);
    filteredValues
        .removeWhere((date, value) => date.isBefore(start) || date.isAfter(end));
    return filteredValues;
  }

  void register(num value, {required DateTime date}) {
    values[date] = value;
    if (limit != null && values.length > limit!) {
      final oldestDate = values.keys.reduce((a, b) => a.isBefore(b) ? a : b);
      values.remove(oldestDate);
    }
  }

  List<num> toDeltasList() {
    final deltas = <num>[];
    num? previousValue;
    for (var value in values.values) {
      deltas.add(previousValue == null ? 0 : value - previousValue);
      previousValue = value;
    }
    return deltas;
  }

  Json toJson() {
    return {
      'limit': limit,
      'values': values.map((date, value) => MapEntry(date.toString(), value)),
    };
  }

  static JumperAttributeHistory fromJson(Json json) {
    final valuesJson = json['values'] as Map;
    return JumperAttributeHistory(
      limit: json['limit'],
      values: valuesJson
          .map((dateString, value) => MapEntry(DateTime.parse(dateString), value)),
    );
  }

  @override
  List<Object?> get props => [
        values,
        limit,
      ];
}
