import 'package:sj_manager/utilities/json/json_types.dart';

class DbItemsJsonConfiguration<T> {
  DbItemsJsonConfiguration({
    required this.fromJson,
    required this.toJson,
  });

  final FromJson<T> fromJson;
  final ToJson<T> toJson;
}
