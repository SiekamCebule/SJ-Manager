import 'package:sj_manager/features/competitions/domain/entities/scoring/score/competition_scores.dart';

abstract interface class CompetitionScoreCreator<T> {
  CompetitionScore<T> create(dynamic context);
}
