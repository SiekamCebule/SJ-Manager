import 'package:sj_manager/features/competitions/domain/entities/scoring/judge_evaluation.dart';
import 'package:sj_manager/features/competitions/domain/utils/judges_creator/context/judges_creating_context.dart';
import 'package:sj_manager/features/competitions/domain/utils/judges_creator/judges_creator.dart';

class DefaultJudgesCreator implements JudgesCreator {
  late JudgesCreatingContext context;

  @override
  List<JudgeEvaluation> create(covariant JudgesCreatingContext context) {
    setUpContext(context);
    final judges = List<double>.generate(context.judgesCount, (_) => 0);
    // TODO: FILL IT
    return judges.map(JudgeEvaluation.from).toList();
  }

  void setUpContext(JudgesCreatingContext context) {
    this.context = context;
  }
}
