import 'dart:convert';
import 'dart:io';

import 'package:sj_manager/exceptions/json_exceptions.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

Future<List<T>> loadItemsListFromJsonFile<T>({
  required File file,
  required FromJson<T> fromJson,
}) async {
  final fileContent = await file.readAsString();
  final itemsInJson = safeJsonDecode(fileContent) as List<dynamic>;
  final items = itemsInJson.map((json) => fromJson(json)).toList();

  final list = items.toList();
  return list;
}

class LoadedItemsMap<T> {
  const LoadedItemsMap({
    required this.orderedIds,
    required this.items,
  });

  final List<dynamic> orderedIds;
  final Map<dynamic, (T, int)> items;
}

Future<LoadedItemsMap<T>> loadItemsMapFromJsonFile<T>({
  required File file,
  required FromJson<T> fromJson,
}) async {
  final content = await file.readAsString();
  final json = jsonDecode(content);

  final orderedIds = List<dynamic>.from(json['orderedIds']);
  final itemsMap = Map<dynamic, dynamic>.from(json['items']);
  final items = <dynamic, (T, int)>{};

  for (var id in orderedIds) {
    if (!itemsMap.containsKey(id)) {
      throw StateError(
        'An ID contained in \'orderedIds\' is not contained in \'items\' ($id)',
      );
    }
    final itemJson = itemsMap[id];
    final item = fromJson(itemJson);
    final count = items[id] != null ? items[id]!.$2 + 1 : 1;
    items[id] = (item, count);
  }

  return LoadedItemsMap<T>(
    orderedIds: orderedIds,
    items: items,
  );
}

dynamic safeJsonDecode(String source, {Object? Function(Object?, Object?)? reviver}) {
  try {
    return jsonDecode(source);
  } on FormatException {
    if (source == '') {
      throw const JsonIsEmptyException();
    }
  }
}

Future<List<T>> loadItemsFromDirectory<T>({
  required Directory directory,
  required bool Function(File file) match,
  required FromJson<T> fromJson,
}) async {
  final items = <T>[];
  final files = directory.listSync().whereType<File>();
  final matchingFiles = files.where(match);
  for (var file in matchingFiles) {
    final json = safeJsonDecode(await file.readAsString());
    final item = fromJson(json);
    items.add(item);
  }
  return items;
}

Future<void> saveItemsListToJsonFile<T>({
  required File file,
  required List<T> items,
  required ToJson<T> toJson,
}) async {
  final itemsInJson = items.map((item) => toJson(item)).toList();
  final jsonContent = jsonEncode(itemsInJson);
  await file.writeAsString(jsonContent);
}

Future<void> saveItemsMapToJsonFile<T>({
  required File file,
  required List<T> items,
  required ToJson<T> toJson,
  required ItemsIdsRepo idsRepo,
}) async {
  final orderedIdsJson = <Object>[];
  final itemsJson = <Object, dynamic>{};
  for (var item in items) {
    final id = idsRepo.idOf(item);
    orderedIdsJson.add(id);
    if (!itemsJson.containsKey(id)) {
      itemsJson[id] = toJson(item);
    }
  }
  final json = {
    'orderedIds': orderedIdsJson,
    'items': itemsJson,
  };
  print('ok');
  print('json: $json');
  final encodedJson = jsonEncode(json);
  await file.writeAsString(encodedJson);
}
