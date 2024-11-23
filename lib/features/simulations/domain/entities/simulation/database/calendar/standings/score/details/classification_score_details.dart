import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/score/details/competition_score_details.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/score/details/score_details.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/score/score.dart';

class ClassificationScoreDetails extends ScoreDetails {
  const ClassificationScoreDetails({
    required this.competitionScores,
  });

  final List<Score<dynamic, CompetitionScoreDetails<dynamic>>> competitionScores;

  @override
  List<Object?> get props => [super.props, competitionScores];
}
