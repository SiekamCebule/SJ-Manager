import 'package:sj_manager/data/models/simulation/standings/score/details/competition_score_details.dart';
import 'package:sj_manager/data/models/simulation/standings/score/details/score_details.dart';
import 'package:sj_manager/data/models/simulation/standings/score/score.dart';

class ClassificationScoreDetails extends ScoreDetails {
  const ClassificationScoreDetails({
    required this.competitionScores,
  });

  final List<Score<dynamic, CompetitionScoreDetails<dynamic>>> competitionScores;

  @override
  List<Object?> get props => [super.props, competitionScores];
}
