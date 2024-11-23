import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/core/errors/translation_not_found_error.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/features/app_settings/presentation/bloc/app_settings_cubit.dart';

class MultilingualString with EquatableMixin {
  const MultilingualString(this.valuesByLanguage);

  const MultilingualString.empty() : valuesByLanguage = const {};

  final Map<String, String> valuesByLanguage;

  String translate(BuildContext context) {
    final code =
        (context.read<AppSettingsCubit>().state as AppSettingsInitialized).languageCode;
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
    return MultilingualString(newNames);
  }

  @override
  String toString() {
    return valuesByLanguage.toString();
  }

  Json toJson() => valuesByLanguage;

  static MultilingualString fromJson(Json json) => MultilingualString(
        json.cast(),
      );

  @override
  List<Object?> get props => [
        valuesByLanguage,
      ];
}
