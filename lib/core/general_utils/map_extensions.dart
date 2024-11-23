extension AsyncMap<K, V> on Map<K, V> {
  Future<Map<K2, V2>> asyncMap<K2, V2>(
      Future<MapEntry<K2, V2>> Function(K key, V value) convert) async {
    final entryFutures =
        entries.map((entry) async => await convert(entry.key, entry.value));
    return Map.fromEntries(await Future.wait(entryFutures));
  }
}
