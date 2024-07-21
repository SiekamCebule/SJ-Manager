extension SingleWhereType on Iterable {
  T? maybeSingleWhereType<T>() => whereType<T>().singleOrNull;
  T singleWhereType<T>() => maybeSingleWhereType<T>()!;
}
