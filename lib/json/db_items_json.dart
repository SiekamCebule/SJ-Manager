import 'dart:convert';
import 'dart:io';

import 'package:sj_manager/exceptions/json_exceptions.dart';
import 'package:sj_manager/json/json_types.dart';

// TODO: It is probably useless
/*Future<Map<K, V>> loadItemsMapFromJsonFile<K, V>({
  required File file,
  required FromJson<V> fromJson,
}) async {
  final fileContent = await file.readAsString();
  final jsonMap = jsonDecode(fileContent) as Map<String, dynamic>;
  final Map<K, V> itemsMap = {};

  jsonMap.forEach((key, value) {
    final parsedKey = key as K; // Ensure the key is of type T
    final parsedValue = fromJson(value as Map<String, dynamic>);
    itemsMap[parsedKey] = parsedValue;
  });

  return itemsMap;
}*/

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

dynamic safeJsonDecode(String source, {Object? Function(Object?, Object?)? reviver}) {
  try {
    return jsonDecode(source);
  } on FormatException {
    if (source == '') {
      throw const JsonIsEmptyException();
    }
  }
}

// TODO: It is probably useless
/* Future<T> loadSingleItemFromJsonFile<T>({
  required File file,
  required FromJson<T> fromJson,
}) async {
  final fileContent = await file.readAsString();
  final json = jsonDecode(fileContent);
  final item = fromJson(json);
  return item;
}*/

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
