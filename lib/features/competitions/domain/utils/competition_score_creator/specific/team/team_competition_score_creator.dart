import 'package:sj_manager/features/competitions/domain/entities/scoring/score/subjects/competition_team.dart';
import 'package:sj_manager/features/competitions/domain/utils/competition_score_creator/competition_score_creator.dart';

abstract interface class TeamCompetitionScoreCreator
    implements CompetitionScoreCreator<CompetitionTeam> {}
