import 'package:sj_manager/domain/entities/simulation/classification/default_classification_rules.dart';
import 'package:sj_manager/domain/entities/simulation/competition/competition.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/classification_score_creator/classification_score_creator.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/classification_score_creator/concrete/default.dart';
import 'package:sj_manager/domain/entities/simulation/standings/score/typedefs.dart';
import 'package:sj_manager/domain/entities/simulation/standings/standings.dart';
import 'package:sj_manager/domain/entities/simulation/standings/utils/standings_utils.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/domain/entities/simulation/team/competition_team.dart';
import 'package:sj_manager/domain/entities/simulation/team/team.dart';

class DefaultTeamClassificationScoreCreator extends DefaultClassificationScoreCreator<
    Team, DefaultTeamClassificationScoreCreatingContext> {
  @override
  void setUpCompetitionScores() {
    final classificationRules =
        context.classification.rules as DefaultTeamClassificationRules;
    for (var competition in significantCompetitions) {
      if (competition is Competition<JumperDbRecord, Standings>) {
        if (classificationRules.includeJumperPointsFromIndividualCompetitions) {
          for (var jumperScore in _scoresOfTeamJumpers(competition)) {
            competitionScores.add(jumperScore);
          }
        }
      } else if (competition is Competition<Team, Standings>) {
        final score =
            competition.standings!.scoreOf(context.entity) as CompetitionTeamScore?;
        if (score != null) {
          competitionScores.add(score);
        }
      }
    }
  }

  List<CompetitionJumperScore> _scoresOfTeamJumpers(
      Competition<JumperDbRecord, Standings> competition) {
    final jumperScores = <CompetitionJumperScore>[];
    for (var score in competition.standings!.scores) {
      final individualScore = score as CompetitionJumperScore;
      final competitionTeam = context.entity as CompetitionTeam;
      if (competitionTeam.jumpers.contains(individualScore.entity)) {
        jumperScores.add(individualScore);
      }
    }
    return jumperScores;
  }

  @override
  void calculatePoints() {
    for (var competition in significantCompetitions) {
      if (competition is Competition<JumperDbRecord, Standings>) {
        _addPointsForIndividual(competition);
      } else if (competition is Competition<CompetitionTeam, Standings>) {
        _addPointsForTeam(competition);
      }
    }
  }

  void _addPointsForIndividual(Competition<JumperDbRecord, Standings> competition) {
    final rules = context.classification.rules as DefaultTeamClassificationRules;
    switch (rules.scoringType) {
      case DefaultClassificationScoringType.pointsFromCompetitions:
        final jumpersFromTeam = context.teamJumpersForIndividualCompetitions;
        for (var jumper in jumpersFromTeam) {
          final score = competition.standings!.scoreOf(jumper) as CompetitionJumperScore?;
          if (score != null) {
            points += score.points;
          }
        }
      case DefaultClassificationScoringType.pointsFromMap:
        final jumpersFromTeam = context.teamJumpersForIndividualCompetitions;
        for (var jumper in jumpersFromTeam) {
          final position = competition.standings!.positionOf(jumper);
          if (position != null) {
            points += rules.pointsMap![position] ?? 0;
          }
        }
    }
  }

  void _addPointsForTeam(Competition<CompetitionTeam, Standings> competition) {
    final rules = context.classification.rules as DefaultTeamClassificationRules;
    switch (rules.scoringType) {
      case DefaultClassificationScoringType.pointsFromCompetitions:
        final team =
            findCompetitionTeam(parentTeam: context.entity, competition: competition);
        final teamScore = competition.standings!.scoreOf(team)! as CompetitionTeamScore;
        final multiplier = rules.pointsModifiers[competition] ?? 1.0;
        points += teamScore.points * multiplier;
      case DefaultClassificationScoringType.pointsFromMap:
        final team =
            findCompetitionTeam(parentTeam: context.entity, competition: competition);
        final teamPosition = competition.standings!.positionOf(team)!;
        points += rules.pointsMap![teamPosition]!;
    }
  }
}
