import 'package:sj_manager/utilities/json/json_types.dart';

abstract interface class ConvertableToJson<T> {
  const ConvertableToJson();
  Json toJson();
}
