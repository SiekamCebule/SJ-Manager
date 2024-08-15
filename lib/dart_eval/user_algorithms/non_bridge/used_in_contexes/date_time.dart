import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';

class $DateTime implements DateTime, $Instance {
  $DateTime.wrap(this.$value) : _superclass = $Object($value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'DateTime',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType(
      $type,
      $implements: [$Comparable.$declaration.type.type],
    ),
    constructors: {
      // TODO: OMITTED THE CONSTRUCTORS - USELESS AT THE MOMENT
    },
    fields: {
      'year': BridgeFieldDef($int.$declaration.type.type.annotate),
      'month': BridgeFieldDef($int.$declaration.type.type.annotate),
      'day': BridgeFieldDef($int.$declaration.type.type.annotate),
      'hour': BridgeFieldDef($int.$declaration.type.type.annotate),
      'minute': BridgeFieldDef($int.$declaration.type.type.annotate),
      'second': BridgeFieldDef($int.$declaration.type.type.annotate),
      'millisecond': BridgeFieldDef($int.$declaration.type.type.annotate),
      'microsecond': BridgeFieldDef($int.$declaration.type.type.annotate),
      'weekday': BridgeFieldDef($int.$declaration.type.type.annotate),
    },
    wrap: true,
  );

  @override
  final DateTime $value;

  @override
  DateTime get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'year':
        return $int($value.year);
      case 'month':
        return $int($value.month);
      case 'day':
        return $int($value.day);
      case 'hour':
        return $int($value.hour);
      case 'minute':
        return $int($value.minute);
      case 'second':
        return $int($value.second);
      case 'millisecond':
        return $int($value.millisecond);
      case 'microsecond':
        return $int($value.microsecond);
      case 'weekday':
        return $int($value.weekday);
      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }

  @override
  int get year => $value.year;

  @override
  int get month => $value.month;

  @override
  int get day => $value.day;

  @override
  int get hour => $value.hour;

  @override
  int get minute => $value.minute;

  @override
  int get second => $value.second;

  @override
  int get millisecond => $value.millisecond;

  @override
  int get microsecond => $value.microsecond;

  @override
  int get weekday => $value.weekday;

  // TODO: MAYBE APPROPRIATELY IMPLEMENT THE METHODS (AND ADD TO CLASS DECLARATION)

  @override
  DateTime add(Duration duration) {
    throw UnimplementedError();
  }

  @override
  int compareTo(DateTime other) {
    throw UnimplementedError();
  }

  @override
  Duration difference(DateTime other) {
    throw UnimplementedError();
  }

  @override
  bool isAfter(DateTime other) {
    throw UnimplementedError();
  }

  @override
  bool isAtSameMomentAs(DateTime other) {
    throw UnimplementedError();
  }

  @override
  bool isBefore(DateTime other) {
    throw UnimplementedError();
  }

  @override
  DateTime subtract(Duration duration) {
    throw UnimplementedError();
  }

  @override
  String toIso8601String() {
    throw UnimplementedError();
  }

  @override
  DateTime toLocal() {
    throw UnimplementedError();
  }

  @override
  DateTime toUtc() {
    throw UnimplementedError();
  }

  @override
  bool get isUtc => throw UnimplementedError();

  @override
  int get microsecondsSinceEpoch => throw UnimplementedError();

  @override
  int get millisecondsSinceEpoch => throw UnimplementedError();

  @override
  String get timeZoneName => throw UnimplementedError();

  @override
  Duration get timeZoneOffset => throw UnimplementedError();
}
