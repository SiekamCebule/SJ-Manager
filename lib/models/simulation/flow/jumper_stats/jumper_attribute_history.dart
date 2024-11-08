import 'package:equatable/equatable.dart';
import 'package:sj_manager/json/json_types.dart';

class JumperAttributeHistory with EquatableMixin {
  JumperAttributeHistory({
    required this.values,
  });

  JumperAttributeHistory.empty() : this(values: {});

  final Map<DateTime, num> values;

  Map<DateTime, num> filterByDatesRange(DateTime start, DateTime end) {
    assert(start.isBefore(end));
    final filteredValues = Map.of(values);
    filteredValues
        .removeWhere((date, value) => date.isBefore(start) || date.isAfter(end));
    return filteredValues;
  }

  void register(num value, {required DateTime date}) {
    values[date] = value;
  }

  List<num> toDeltasList() {
    final deltas = <num>[];
    num? previousValue;
    for (var value in values.values) {
      if (previousValue == null) {
        deltas.add(0);
      } else {
        deltas.add(value - previousValue);
      }
      previousValue = value;
    }
    return deltas;
  }

  Json toJson() {
    return {
      'values': values.map((date, value) {
        return MapEntry(date.toString(), value);
      }),
    };
  }

  static JumperAttributeHistory fromJson(Json json) {
    final valuesJson = json['values'] as Map;
    return JumperAttributeHistory(
      values: valuesJson.map(
        (dateString, value) {
          return MapEntry(DateTime.parse(dateString), value);
        },
      ),
    );
  }

  @override
  List<Object?> get props => [
        values,
      ];
}
