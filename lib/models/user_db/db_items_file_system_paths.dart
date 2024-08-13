class DbItemsFileSystemPaths {
  DbItemsFileSystemPaths({
    Map<Type, String> initial = const {},
  }) : _registry = Map.of(initial);

  final Map<Type, String> _registry;

  void register({required Type type, required String path, bool overwrite = false}) {
    if (!_registry.containsKey(type) && !overwrite) {
      throw StateError(
          'The registry do contains a path with associated $type type, but cannot overwrite it since the flag is set to false');
    }
    _registry[type] = path;
  }

  String byTypeArgument(Type type) {
    if (!_registry.containsKey(type)) {
      throw StateError('Invalid generic type ($type)');
    }
    final key = _registry.keys.singleWhere((key) => key == type);
    return _registry[key]!;
  }

  String get<T>() {
    return byTypeArgument(T);
  }
}

class DbItemsDirectoryPathsRegistry extends DbItemsFileSystemPaths {
  DbItemsDirectoryPathsRegistry({super.initial});
}

class DbItemsFilePathsRegistry extends DbItemsFileSystemPaths {
  DbItemsFilePathsRegistry({super.initial});
}
