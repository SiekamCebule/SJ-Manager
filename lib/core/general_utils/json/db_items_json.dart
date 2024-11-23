import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:sj_manager/core/exceptions/json_exceptions.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';
import 'package:sj_manager/core/general_utils/database_io.dart';

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

class LoadedItemsMap<T> with EquatableMixin {
  const LoadedItemsMap({
    required this.orderedIds,
    required this.items,
  });

  final List<dynamic> orderedIds;
  final Map<dynamic, (T, int)> items;

  List<T> getOrderedItems() {
    return orderedIds.map((id) {
      return items[id]!.$1;
    }).toList();
  }

  @override
  List<Object?> get props => [orderedIds, items];
}

Future<LoadedItemsMap<T>> loadItemsMapFromJsonFile<T>({
  required File file,
  required FromJson<T> fromJson,
}) async {
  final content = await file.readAsString();
  return await parseItemsMap(
    json: jsonDecode(content),
    fromJson: fromJson,
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
  required Iterable<T> items,
  required ToJson<T> toJson,
  required IdsRepository idsRepository,
  bool createDirectoriesAndFilesIfNeeded = false,
}) async {
  final encodableJson = await serializeItemsMap(
    items: items,
    idsRepository: idsRepository,
    toJson: toJson,
  );
  final encodedJson = jsonEncode(encodableJson);

  if (!await file.exists()) {
    await file.create(recursive: createDirectoriesAndFilesIfNeeded);
  }
  await file.writeAsString(encodedJson);
}
