import 'package:equatable/equatable.dart';

import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/entities/jumper_training_category.dart';

class JumperTrainingConfig with EquatableMixin {
  JumperTrainingConfig({
    required this.balance,
  });

  /// -1.0 do 1.0. Utrzymanie/Zmiana
  Map<JumperTrainingCategory, double> balance;

  Json toJson() {
    return {
      'balance': balance.map((category, value) {
        return MapEntry(category.name, value);
      }),
    };
  }

  static JumperTrainingConfig fromJson(Json json) {
    final balanceJson = json['balance'] as Json;
    final balance = balanceJson.map((categoryName, value) {
      final category = JumperTrainingCategory.values.singleWhere(
        (value) => value.name == categoryName,
      );
      return MapEntry(category, (value as num).toDouble());
    });
    return JumperTrainingConfig(
      balance: balance,
    );
  }

  @override
  List<Object?> get props => [
        balance.keys,
        balance.values,
      ];

  JumperTrainingConfig copyWith({
    Map<JumperTrainingCategory, double>? balance,
  }) {
    return JumperTrainingConfig(
      balance: balance ?? this.balance,
    );
  }
}

final initialJumperTrainingConfig = JumperTrainingConfig(
  balance: {
    JumperTrainingCategory.takeoff: 0.0,
    JumperTrainingCategory.flight: 0.0,
    JumperTrainingCategory.landing: 0.0,
    JumperTrainingCategory.form: 0.0,
  },
);
