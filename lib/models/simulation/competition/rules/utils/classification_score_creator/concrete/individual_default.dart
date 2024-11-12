import 'package:sj_manager/models/simulation/classification/default_classification_rules.dart';
import 'package:sj_manager/models/simulation/competition/competition.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/classification_score_creator/classification_score_creator.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/classification_score_creator/concrete/default.dart';
import 'package:sj_manager/models/simulation/standings/score/typedefs.dart';
import 'package:sj_manager/models/simulation/standings/standings.dart';
import 'package:sj_manager/models/simulation/standings/standings_positions_map_creator/standings_positions_with_ex_aequos_creator.dart';
import 'package:sj_manager/models/simulation/standings/utils/standings_utils.dart';
import 'package:sj_manager/models/database/jumper/jumper_db_record.dart';
import 'package:sj_manager/models/database/team/competition_team.dart';

class DefaultIndividualClassificationScoreCreator
    extends DefaultClassificationScoreCreator<JumperDbRecord,
        DefaultIndividualClassificationScoreCreatingContext> {
  @override
  void setUpCompetitionScores() {
    final classificationRules =
        context.classification.rules as DefaultIndividualClassificationRules;
    for (var competition in significantCompetitions) {
      if (competition is Competition<JumperDbRecord, IndividualCompetitionStandings>) {
        final maybeScore = competition.standings!.scoreOf(context.entity);
        if (maybeScore != null) {
          competitionScores.add(maybeScore);
        }
      } else if (competition is Competition<CompetitionTeam, TeamCompetitionStandings>) {
        if (classificationRules.includeApperancesInTeamCompetitions) {
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
      if (competition is Competition<JumperDbRecord, IndividualCompetitionStandings>) {
        _addPointsForIndividual(competition);
      } else if (competition is Competition<CompetitionTeam, TeamCompetitionStandings>) {
        _addPointsForTeam(competition);
      }
    }
  }

  void _addPointsForIndividual(
      Competition<JumperDbRecord, IndividualCompetitionStandings> competition) {
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

  CompetitionJumperScore? _jumperScoreFromIndividual(
      Competition<JumperDbRecord, Standings> competition) {
    return competition.standings!.scoreOf(context.entity) as CompetitionJumperScore?;
  }

  void _addPointsForTeam(
      Competition<CompetitionTeam, TeamCompetitionStandings> competition) {
    final rules = context.classification.rules;
    switch (rules.scoringType) {
      case DefaultClassificationScoringType.pointsFromCompetitions:
        final multiplier = rules.pointsModifiers[competition] ?? 1.0;
        points += (_jumperScoreFromTeam(competition)!.points) * multiplier;
      case DefaultClassificationScoringType.pointsFromMap:
        final individualStandings = createIndividualStandingsForTeamCompetition(
          teamStandings: competition.standings!,
          positionsCreator: StandingsPositionsWithExAequosCreator(),
        );
        final position = individualStandings.positionOf(context.entity);
        if (position != null) {
          points += rules.pointsMap![position] ?? 0;
        }
    }
  }

  CompetitionJumperScore? _jumperScoreFromTeam(
      Competition<CompetitionTeam, TeamCompetitionStandings> competition) {
    final teamOfJumper = teamOfJumperInStandings(
      jumper: context.entity,
      standings: competition.standings!,
    );
    if (teamOfJumper != null) {
      final teamScore = competition.standings!.scoreOf(teamOfJumper)!;
      final jumperScore = teamScore.details.jumperScore(context.entity)!;
      return jumperScore;
    } else {
      return null;
    }
  }
}
