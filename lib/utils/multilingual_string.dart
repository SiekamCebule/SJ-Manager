import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/errors/translation_not_found.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/ui/providers/locale_cubit.dart';

class MultilingualString {
  const MultilingualString({
    required this.valuesByLanguage,
  });

  const MultilingualString.empty() : valuesByLanguage = const {};

  final Map<String, String> valuesByLanguage;

  String translate(BuildContext context) {
    final code = context.read<LocaleCubit>().languageCode;
    return byCode(code);
  }

  String byCode(String languageCode) {
    if (!valuesByLanguage.containsKey(languageCode)) {
      throw TranslationNotFoundError(
        multilingualString: this,
        languageCode: languageCode,
      );
    }
    return valuesByLanguage[languageCode]!;
  }

  MultilingualString copyWith({
    required String languageCode,
    required String value,
  }) {
    final newNames = Map.of(valuesByLanguage);
    newNames[languageCode] = value;
    return MultilingualString(valuesByLanguage: newNames);
  }

  @override
  String toString() {
    return valuesByLanguage.toString();
  }

  Json toJson() => valuesByLanguage;

  static MultilingualString fromJson(Json json) => MultilingualString(
        valuesByLanguage: json.cast(),
      );
}
