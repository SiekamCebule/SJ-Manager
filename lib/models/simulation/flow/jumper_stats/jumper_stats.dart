import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/simulation/flow/jumper_stats/jumper_attribute_history.dart';
import 'package:sj_manager/models/simulation/flow/reports/jumper_reports.dart';

class JumperStats with EquatableMixin {
  const JumperStats({
    required this.progressableAttributeHistory,
  });

  const JumperStats.empty() : this(progressableAttributeHistory: const {});

  final Map<TrainingProgressCategory, JumperAttributeHistory>
      progressableAttributeHistory;

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
          TrainingProgressCategory.values
              .singleWhere((value) => value.name == categoryName),
          JumperAttributeHistory.fromJson(historyJson),
        ),
      ),
    );
  }

  JumperStats copyWith({
    Map<TrainingProgressCategory, JumperAttributeHistory>? progressableAttributeHistory,
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
