class MultilingualString {
  const MultilingualString({
    required this.namesByLanguage,
  });

  final Map<String, String> namesByLanguage;

  String translate(String languageCode) {
    if (!namesByLanguage.containsKey(languageCode)) {
      throw StateError('The string does not appear in the \'$languageCode\' language');
    }
    return namesByLanguage[languageCode]!;
  }

  MultilingualString copyWith({
    required String languageCode,
    required String name,
  }) {
    if (!namesByLanguage.containsKey(languageCode)) {
      throw StateError(
          'Cannot replace name in $languageCode language, because it is not even contained in the multilingual string');
    }
    final newNames = Map.of(namesByLanguage);
    newNames[languageCode] = name;
    return MultilingualString(namesByLanguage: newNames);
  }

  @override
  String toString() {
    return namesByLanguage.toString();
  }
}
