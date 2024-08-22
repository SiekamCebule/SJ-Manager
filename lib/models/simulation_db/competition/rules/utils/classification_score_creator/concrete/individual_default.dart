import 'package:sj_manager/models/simulation_db/classification/default_classification_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/competition.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/classification_score_creator/classification_score_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/classification_score_creator/concrete/default.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/competition_scores.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/single_jump_score.dart';
import 'package:sj_manager/models/simulation_db/standings/utils/standings_utils.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/competition_team.dart';

class DefaultIndividualClassificationScoreCreator
    extends DefaultClassificationScoreCreator<Jumper,
        DefaultIndividualClassificationScoreCreatingContext, SingleJumpScore<Jumper>> {
  @override
  void setUpCompetitionScores() {
    final classificationRules =
        context.classification.rules as DefaultIndividualClassificationRules;
    for (var competition in significantCompetitions) {
      if (competition is Competition<Jumper>) {
        final maybeScore =
            competition.standings!.scoreOf(context.entity) as CompetitionJumperScore?;
        if (maybeScore != null) {
          competitionScores.add(maybeScore);
        }
      } else if (competition is Competition<CompetitionTeam>) {
        if (classificationRules.includeIndividualPlaceFromTeamCompetitions) {
          final score = _jumperScoreFromTeam(competition);
          if (score != null) {
            competitionScores.add(score);
          }
        }
      }
    }
  }

  @override
  void calculatePoints() {
    for (var competition in significantCompetitions) {
      if (competition is Competition<Jumper>) {
        _addPointsForIndividual(competition);
      } else if (competition is Competition<CompetitionTeam>) {
        _addPointsForTeam(competition);
      }
    }
  }

  void _addPointsForIndividual(Competition<Jumper> competition) {
    final rules = context.classification.rules;
    switch (rules.scoringType) {
      case DefaultClassificationScoringType.pointsFromCompetitions:
        final multiplier = rules.pointsModifiers[competition] ?? 1.0;
        points += (_jumperScoreFromIndividual(competition)!.points) * multiplier;
      case DefaultClassificationScoringType.pointsFromMap:
        final position = competition.standings!.positionOf(context.entity);
        points += rules.pointsMap![position] ?? 0;
    }
  }

  CompetitionJumperScore? _jumperScoreFromIndividual(Competition<Jumper> competition) {
    return competition.standings!.scoreOf(context.entity) as CompetitionJumperScore?;
  }

  void _addPointsForTeam(Competition<CompetitionTeam> competition) {
    final rules = context.classification.rules;
    switch (rules.scoringType) {
      case DefaultClassificationScoringType.pointsFromCompetitions:
        final multiplier = rules.pointsModifiers[competition] ?? 1.0;
        points += (_jumperScoreFromTeam(competition)!.points) * multiplier;
      case DefaultClassificationScoringType.pointsFromMap:
        final individualStandings = createIndividualStandingsForTeamCompetition(
            teamStandings: competition.standings!,
            positionsCreator: competition.standings!.positionsCreator);
        final position = individualStandings.positionOf(context.entity);
        if (position != null) {
          points += rules.pointsMap![position] ?? 0;
        }
    }
  }

  CompetitionJumperScore? _jumperScoreFromTeam(Competition<CompetitionTeam> competition) {
    final teamOfJumper = teamOfJumperInStandings(
      jumper: context.entity,
      standings: competition.standings!,
    );
    if (teamOfJumper != null) {
      final teamScore =
          competition.standings!.scoreOf(teamOfJumper)! as CompetitionTeamScore;
      final jumperScore = teamScore.jumperScore(context.entity);
      return jumperScore;
    } else {
      return null;
    }
  }
}
