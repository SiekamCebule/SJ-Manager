import 'package:sj_manager/models/simulation_db/standings/score/details/jump_score_details.dart';
import 'package:sj_manager/models/simulation_db/standings/score/details/score_details.dart';
import 'package:sj_manager/models/simulation_db/standings/score/score.dart';
import 'package:sj_manager/models/simulation_db/standings/score/typedefs.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:collection/collection.dart';

abstract class CompetitionScoreDetails<E> extends ScoreDetails {
  const CompetitionScoreDetails();

  List<Score<E, JumpScoreDetails>> get jumpScores;

  @override
  List<Object?> get props => [super.props, jumpScores];
}

class CompetitionJumperScoreDetails extends CompetitionScoreDetails<Jumper> {
  const CompetitionJumperScoreDetails({
    required List<Score<Jumper, JumpScoreDetails>> jumpScores,
  }) : _jumpScores = jumpScores;

  final List<Score<Jumper, JumpScoreDetails>> _jumpScores;

  @override
  List<Score<Jumper, JumpScoreDetails>> get jumpScores => _jumpScores;
}

class CompetitionTeamScoreDetails extends CompetitionScoreDetails<Jumper> {
  CompetitionTeamScoreDetails({
    required this.jumperScores,
  });

  final List<Score<Jumper, CompetitionJumperScoreDetails>> jumperScores;

  @override
  List<Score<Jumper, JumpScoreDetails>> get jumpScores {
    return jumperScores.expand((score) => score.details.jumpScores).toList();
  }

  CompetitionJumperScore? jumperScore(Jumper jumper) {
    return jumperScores.singleWhereOrNull((score) => score.entity == jumper);
  }

  @override
  List<Object?> get props => [super.props, jumperScores];
}
