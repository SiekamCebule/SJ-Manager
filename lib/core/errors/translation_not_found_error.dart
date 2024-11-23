import 'package:sj_manager/core/general_utils/multilingual_string.dart';

class TranslationNotFoundError extends Error {
  TranslationNotFoundError({
    required this.multilingualString,
    required this.languageCode,
  });

  final MultilingualString multilingualString;
  final String languageCode;

  @override
  String toString() {
    return 'The string does not appear in the \'$languageCode\' language';
  }
}
