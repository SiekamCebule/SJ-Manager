import 'package:sj_manager/features/competitions/domain/entities/scoring/score/classification_scores.dart';

abstract interface class ClassificationScoreCreator<T> {
  ClassificationScore<T> create(dynamic context);
}
