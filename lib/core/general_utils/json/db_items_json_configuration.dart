import 'package:sj_manager/core/general_utils/json/json_types.dart';

class DbItemsJsonConfiguration<T> {
  DbItemsJsonConfiguration({
    required this.fromJson,
    required this.toJson,
  });

  final FromJson<T> fromJson;
  final ToJson<T> toJson;
}
