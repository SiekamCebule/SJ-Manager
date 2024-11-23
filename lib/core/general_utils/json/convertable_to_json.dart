import 'package:sj_manager/core/general_utils/json/json_types.dart';

abstract interface class ConvertableToJson<T> {
  const ConvertableToJson();
  Json toJson();
}
