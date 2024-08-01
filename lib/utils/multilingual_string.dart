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
}
