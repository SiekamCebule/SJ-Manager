class LoadingDatabaseFailedException implements Exception {
  const LoadingDatabaseFailedException({
    required this.lowLevelError,
  });

  final Object lowLevelError;

  @override
  String toString() {
    return lowLevelError.toString();
  }
}
