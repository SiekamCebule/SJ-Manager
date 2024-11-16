extension SingleWhereType on Iterable {
  T? singleWhereTypeOrNull<T>() => whereType<T>().singleOrNull;
  T singleWhereType<T>() => singleWhereTypeOrNull<T>()!;
}
