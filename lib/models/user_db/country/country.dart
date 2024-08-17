import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/utils/multilingual_string.dart';

part 'country.g.dart';

@JsonSerializable()
class Country with EquatableMixin {
  const Country({
    required this.code,
    required this.multilingualName,
  });

  Country.monolingual(
      {required String code, required String language, required String name})
      : this(
          code: code,
          multilingualName: MultilingualString(
            namesByLanguage: {language: name},
          ),
        );

  final String code;

  @JsonKey(fromJson: MultilingualString.fromJson, toJson: _multilingualStringToJson)
  final MultilingualString multilingualName;
  static Json _multilingualStringToJson(MultilingualString string) {
    return string.toJson();
  }

  String name(BuildContext context) {
    return multilingualName.translate(context);
  }

  const Country.emptyNone()
      : code = 'none',
        multilingualName = const MultilingualString.empty();

  static Country fromJson(Json json) => _$CountryFromJson(json);

  Json toJson() => _$CountryToJson(this);

  @override
  String toString() {
    return '$multilingualName ($code)';
  }

  Country copyWith({
    String? code,
    MultilingualString? multilingualName,
  }) {
    return Country(
      code: code ?? this.code,
      multilingualName: multilingualName ?? this.multilingualName,
    );
  }

  @override
  List<Object?> get props => [code, multilingualName];
}

String stringFromMultilingualJson(Json json,
    {required String languageCode, required String parameterName}) {
  return json[parameterName]![languageCode]!;
}
