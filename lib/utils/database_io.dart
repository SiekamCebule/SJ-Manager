import 'package:sj_manager/json/db_items_json.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

Future<Json> serializeItemsMap<T>({
  required Iterable<T> items,
  required ItemsIdsRepo idsRepo,
  required ToJson<T> toJson,
}) async {
  final orderedIdsJson = <Object>[];
  var itemsJson = <Object, dynamic>{};

  for (var item in items) {
    final id = idsRepo.id(item);
    orderedIdsJson.add(id);
    if (!itemsJson.containsKey(id)) {
      final itemJson = await toJson(item);
      itemsJson[id] = itemJson;
    }
  }

  dynamic convertToEncodable(dynamic value) {
    if (value is Map) {
      return value.map(
        (key, innerValue) => MapEntry(key.toString(), convertToEncodable(innerValue)),
      );
    } else if (value is List) {
      return value.map((item) => convertToEncodable(item)).toList();
    } else {
      return value;
    }
  }

  itemsJson = convertToEncodable(itemsJson);

  return {
    'orderedIds': orderedIdsJson,
    'items': itemsJson,
  };
}

Future<LoadedItemsMap<T>> parseItemsMap<T>({
  required Json json,
  required FromJson<T> fromJson,
}) async {
  final orderedIds = List<dynamic>.from(json['orderedIds']);
  final itemsMap = Map<dynamic, dynamic>.from(json['items']);
  final items = <dynamic, (T, int)>{};
  for (var id in orderedIds) {
    if (!itemsMap.containsKey(id)) {
      throw StateError(
        'An ID contained in \'orderedIds\' is not contained in the \'items\' ($id)',
      );
    }

    final itemJson = itemsMap[id];
    final item = await fromJson(itemJson); // Await on FutureOr
    final count = items[id] != null ? items[id]!.$2 + 1 : 1;
    items[id] = (item, count);
  }

  return LoadedItemsMap(
    orderedIds: orderedIds,
    items: items,
  );
}
