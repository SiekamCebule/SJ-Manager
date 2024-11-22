import 'package:sj_manager/domain/entities/simulation/standings/score/details/jump_score_details.dart';
import 'package:sj_manager/domain/entities/simulation/standings/score/details/score_details.dart';
import 'package:sj_manager/domain/entities/simulation/standings/score/score.dart';
import 'package:sj_manager/domain/entities/simulation/standings/score/typedefs.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:collection/collection.dart';

abstract class CompetitionScoreDetails<E> extends ScoreDetails {
  const CompetitionScoreDetails();

  List<Score<E, JumpScoreDetails>> get jumpScores;

  @override
  List<Object?> get props => [super.props, jumpScores];
}

class CompetitionJumperScoreDetails extends CompetitionScoreDetails<JumperDbRecord> {
  const CompetitionJumperScoreDetails({
    required List<Score<JumperDbRecord, JumpScoreDetails>> jumpScores,
  }) : _jumpScores = jumpScores;

  final List<Score<JumperDbRecord, JumpScoreDetails>> _jumpScores;

  @override
  List<Score<JumperDbRecord, JumpScoreDetails>> get jumpScores => _jumpScores;
}

class CompetitionTeamScoreDetails extends CompetitionScoreDetails<JumperDbRecord> {
  CompetitionTeamScoreDetails({
    required this.jumperScores,
  });

  final List<Score<JumperDbRecord, CompetitionJumperScoreDetails>> jumperScores;

  @override
  List<Score<JumperDbRecord, JumpScoreDetails>> get jumpScores {
    return jumperScores.expand((score) => score.details.jumpScores).toList();
  }

  CompetitionJumperScore? jumperScore(JumperDbRecord jumper) {
    return jumperScores.singleWhereOrNull((score) => score.entity == jumper);
  }

  @override
  List<Object?> get props => [super.props, jumperScores];
}
