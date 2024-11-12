// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:sj_manager/json/json_types.dart';

class JumperTrainingConfig with EquatableMixin {
  const JumperTrainingConfig({
    required this.balance,
  });

  /// -1.0 do 1.0. Utrzymanie/Zmiana
  final Map<JumperTrainingCategory, double> balance;

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

enum JumperTrainingCategory {
  takeoff,
  flight,
  landing,
  form,
}

const initialJumperTrainingConfig = JumperTrainingConfig(
  balance: {
    JumperTrainingCategory.takeoff: 0.0,
    JumperTrainingCategory.flight: 0.0,
    JumperTrainingCategory.landing: 0.0,
    JumperTrainingCategory.form: 0.0,
  },
);
