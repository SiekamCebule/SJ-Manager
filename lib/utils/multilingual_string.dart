import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/errors/translation_not_found.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/ui/providers/locale_cubit.dart';

class MultilingualString {
  const MultilingualString({
    required this.namesByLanguage,
  });

  const MultilingualString.empty() : namesByLanguage = const {};

  final Map<String, String> namesByLanguage;

  String translate(BuildContext context) {
    final code = context.read<LocaleCubit>().languageCode;
    return byCode(code);
  }

  String byCode(String languageCode) {
    if (!namesByLanguage.containsKey(languageCode)) {
      throw TranslationNotFoundError(
        multilingualString: this,
        languageCode: languageCode,
      );
    }
    return namesByLanguage[languageCode]!;
  }

  MultilingualString copyWith({
    required String languageCode,
    required String name,
  }) {
    final newNames = Map.of(namesByLanguage);
    newNames[languageCode] = name;
    return MultilingualString(namesByLanguage: newNames);
  }

  @override
  String toString() {
    return namesByLanguage.toString();
  }

  Json toJson() => namesByLanguage;

  static MultilingualString fromJson(Json json) => MultilingualString(
        namesByLanguage: json.cast(),
      );
}
