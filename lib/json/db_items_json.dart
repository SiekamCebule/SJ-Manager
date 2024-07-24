import 'dart:convert';
import 'dart:io';

import 'package:sj_manager/json/json_types.dart';

Future<Map<K, V>> loadItemsMapFromJsonFile<K, V>({
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
}

Future<List<T>> loadItemsListFromJsonFile<T>({
  required File file,
  required FromJson<T> fromJson,
}) async {
  final fileContent = await file.readAsString();
  final itemsInJson = jsonDecode(fileContent) as List<dynamic>;
  final items = itemsInJson.map((json) => fromJson(json));
  return items.toList();
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
