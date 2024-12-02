import 'package:sj_manager/features/competitions/domain/entities/scoring/judge_evaluation.dart';

abstract interface class JudgesCreator {
  List<JudgeEvaluation> create(dynamic context);
}
