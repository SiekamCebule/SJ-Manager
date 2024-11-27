import 'package:equatable/equatable.dart';
import 'package:sj_manager/features/career_mode/subfeatures/jumper_stats/domain/entities/jumper_attribute.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/stats/jumper_attribute_history.dart';

class JumperStats with EquatableMixin {
  JumperStats({
    required this.progressableAttributeHistory,
  });

  JumperStats.empty() : this(progressableAttributeHistory: {});

  Map<JumperAttributeType, JumperAttributeHistory> progressableAttributeHistory;

  Map<String, dynamic> toJson() {
    return {
      'progressableAttributeHistory': progressableAttributeHistory
          .map((key, value) => MapEntry(key.name, value.toJson())),
    };
  }

  factory JumperStats.fromJson(Map<String, dynamic> json) {
    return JumperStats(
      progressableAttributeHistory:
          (json['progressableAttributeHistory'] as Map<String, dynamic>).map(
        (categoryName, historyJson) => MapEntry(
          JumperAttributeType.values.singleWhere((value) => value.name == categoryName),
          JumperAttributeHistory.fromJson(historyJson),
        ),
      ),
    );
  }

  JumperStats copyWith({
    Map<JumperAttributeType, JumperAttributeHistory>? progressableAttributeHistory,
  }) {
    return JumperStats(
      progressableAttributeHistory:
          progressableAttributeHistory ?? this.progressableAttributeHistory,
    );
  }

  @override
  List<Object?> get props => [
        progressableAttributeHistory,
      ];
}
