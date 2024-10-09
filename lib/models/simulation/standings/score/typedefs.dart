import 'package:sj_manager/models/simulation/standings/score/details/classification_score_details.dart';
import 'package:sj_manager/models/simulation/standings/score/details/competition_score_details.dart';
import 'package:sj_manager/models/simulation/standings/score/details/jump_score_details.dart';
import 'package:sj_manager/models/simulation/standings/score/score.dart';
import 'package:sj_manager/models/simulation/standings/standings.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/competition_team.dart';

typedef CompetitionJumperScore = Score<Jumper, CompetitionJumperScoreDetails>;
typedef CompetitionTeamScore = Score<CompetitionTeam, CompetitionTeamScoreDetails>;
typedef CompetitionScore<E> = Score<E, CompetitionScoreDetails<E>>;
typedef ClassificationScore<E> = Score<E, ClassificationScoreDetails>;
typedef CompetitionJumpScore = Score<Jumper, CompetitionJumpScoreDetails>;

typedef IndividualCompetitionStandings = Standings<Jumper, CompetitionJumperScoreDetails>;
typedef TeamCompetitionStandings
    = Standings<CompetitionTeam, CompetitionTeamScoreDetails>;
