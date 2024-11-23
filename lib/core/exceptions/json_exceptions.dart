class JsonIsEmptyException implements Exception {
  const JsonIsEmptyException();

  @override
  String toString() {
    return 'The JSON is entirely empty';
  }
}
