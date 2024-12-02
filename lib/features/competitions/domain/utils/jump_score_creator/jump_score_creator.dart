import 'package:sj_manager/features/competitions/domain/entities/scoring/score/competition_scores.dart';

abstract interface class JumpScoreCreator<C> {
  CompetitionJumpScore create(C context);
}
