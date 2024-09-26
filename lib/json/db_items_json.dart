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
  final decodedContent = safeJsonDecode(fileContent);
  final itemsInJson = decodedContent as List<dynamic>;

  final items = await Future.wait(
    itemsInJson.map((json) async => await fromJson(json)),
  );

  return items;
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
    final item = await fromJson(itemJson); // Await on FutureOr
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
    final item = await fromJson(json); // Await on FutureOr<T>
    items.add(item);
  }

  return items;
}

Future<void> saveItemsListToJsonFile<T>({
  required File file,
  required List<T> items,
  required ToJson<T> toJson,
  bool pretty = false,
}) async {
  final itemsInJson =
      await Future.wait(items.map((item) async => await toJson(item)).toList());
  final encoder = pretty ? const JsonEncoder.withIndent('  ') : const JsonEncoder();
  final jsonContent = encoder.convert(itemsInJson);
  await file.writeAsString(jsonContent);
}

Future<void> saveItemsMapToJsonFile<T>({
  required File file,
  required List<T> items,
  required ToJson<T> toJson,
  required ItemsIdsRepo idsRepo,
  bool createDirectoriesAndFilesIfNeeded = false,
}) async {
  final orderedIdsJson = <Object>[];
  var itemsJson = <Object, dynamic>{};

  for (var item in items) {
    final id = idsRepo.idOf(item);
    orderedIdsJson.add(id);
    if (!itemsJson.containsKey(id)) {
      final itemJson = await toJson(item); // Await to handle FutureOr
      print('ITEM JSON: $itemJson');
      itemsJson[id] = itemJson;
    }
  }

  dynamic convertToEncodable(dynamic value) {
    if (value is Map) {
      return value.map((key, innerValue) => MapEntry(
          key.toString(), convertToEncodable(innerValue))); // Ensure keys are Strings
    } else if (value is List) {
      return value.map((item) => convertToEncodable(item)).toList();
    } else {
      return value; // Return other types as they are
    }
  }

  itemsJson = convertToEncodable(itemsJson);

  final encodableJson = {
    'orderedIds': orderedIdsJson,
    'items': itemsJson,
  };

  final encodedJson = jsonEncode(encodableJson);

  if (!await file.exists()) {
    await file.create(recursive: createDirectoriesAndFilesIfNeeded);
  }
  await file.writeAsString(encodedJson);
}
