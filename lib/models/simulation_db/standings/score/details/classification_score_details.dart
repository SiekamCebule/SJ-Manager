import 'package:sj_manager/models/simulation_db/standings/score/details/competition_score_details.dart';
import 'package:sj_manager/models/simulation_db/standings/score/details/score_details.dart';
import 'package:sj_manager/models/simulation_db/standings/score/score.dart';

class ClassificationScoreDetails extends ScoreDetails {
  const ClassificationScoreDetails({
    required this.competitionScores,
  });

  final List<Score<dynamic, CompetitionScoreDetails>> competitionScores;

  @override
  List<Object?> get props => [super.props, competitionScores];
}
