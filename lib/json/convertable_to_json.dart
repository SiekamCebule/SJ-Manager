import 'package:sj_manager/json/json_types.dart';

abstract interface class ConvertableToJson<T> {
  const ConvertableToJson();
  Json toJson();
}
