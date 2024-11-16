import 'package:sj_manager/data/models/simulation/standings/score/details/classification_score_details.dart';
import 'package:sj_manager/data/models/simulation/standings/score/details/competition_score_details.dart';
import 'package:sj_manager/data/models/simulation/standings/score/details/jump_score_details.dart';
import 'package:sj_manager/data/models/simulation/standings/score/score.dart';
import 'package:sj_manager/data/models/simulation/standings/standings.dart';
import 'package:sj_manager/data/models/database/jumper/jumper_db_record.dart';
import 'package:sj_manager/data/models/database/team/competition_team.dart';

typedef CompetitionJumperScore = Score<JumperDbRecord, CompetitionJumperScoreDetails>;
typedef CompetitionTeamScore = Score<CompetitionTeam, CompetitionTeamScoreDetails>;
typedef CompetitionScore<E> = Score<E, CompetitionScoreDetails<E>>;
typedef ClassificationScore<E> = Score<E, ClassificationScoreDetails>;
typedef CompetitionJumpScore = Score<JumperDbRecord, CompetitionJumpScoreDetails>;

typedef IndividualCompetitionStandings
    = Standings<JumperDbRecord, CompetitionJumperScoreDetails>;
typedef TeamCompetitionStandings
    = Standings<CompetitionTeam, CompetitionTeamScoreDetails>;
