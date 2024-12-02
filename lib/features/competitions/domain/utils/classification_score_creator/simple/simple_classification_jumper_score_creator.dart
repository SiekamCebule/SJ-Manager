import 'package:sj_manager/features/competitions/domain/entities/scoring/score/classification_scores.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/competition_scores.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/subjects/competition_team.dart';
import 'package:sj_manager/features/competitions/domain/utils/classification_score_creator/context/simple_classification_score_creating_context.dart';
import 'package:sj_manager/features/competitions/domain/utils/classification_score_creator/simple/simple_classification_score_creator.dart';
import 'package:sj_manager/features/competitions/domain/utils/standings_position_creators/standings_positions_with_ex_aequos_creator.dart';
import 'package:sj_manager/features/competitions/domain/utils/competition_standings_utils.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/to_embrace/classification/simple_classification_rules.dart';
import 'package:sj_manager/to_embrace/competition/competition.dart';
import 'package:sj_manager/to_embrace/competition/competition_labels.dart';

class SimpleClassificationJumperScoreCreator extends SimpleClassificationScoreCreator<
    SimulationJumper,
    ClassificationJumperScore,
    SimpleClassificationJumperScoreCreatingContext> {
  @override
  void determineSignificantCompetitions() {
    significantCompetitions.clear();
    for (final competition in context.classification.rules.competitions) {
      if (competition is Competition<SimulationJumper>) {
        if (competition.labels.contains(CompetitionPlayedStatus.played)) {
          significantCompetitions.add(competition);
        }
      }
    }
  }

  @override
  void calculatePoints() {
    for (var competition in significantCompetitions) {
      if (competition is Competition<SimulationJumper>) {
        _addPointsForIndividual(competition);
      } else if (competition is Competition<CompetitionTeam>) {
        _addPointsForTeam(competition);
      }
    }
  }

  void _addPointsForIndividual(Competition<SimulationJumper> competition) {
    final rules = context.classification.rules;
    switch (rules.scoringType) {
      case SimpleClassificationScoringType.pointsFromCompetitions:
        final multiplier = rules.pointsModifiers[competition] ?? 1.0;
        points += (_jumperScoreFromIndividual(competition)!.points) * multiplier;
      case SimpleClassificationScoringType.pointsFromMap:
        final position = competition.standings!.positionOf(context.subject);
        points += rules.pointsMap![position] ?? 0;
    }
  }

  CompetitionJumperScore? _jumperScoreFromIndividual(
      Competition<SimulationJumper> competition) {
    return competition.standings!.scoreOf(context.subject) as CompetitionJumperScore?;
  }

  void _addPointsForTeam(Competition<CompetitionTeam> competition) {
    final rules = context.classification.rules;
    switch (rules.scoringType) {
      case SimpleClassificationScoringType.pointsFromCompetitions:
        final multiplier = rules.pointsModifiers[competition] ?? 1.0;
        points += (_jumperScoreFromTeam(competition)!.points) * multiplier;
      case SimpleClassificationScoringType.pointsFromMap:
        final individualStandings = createIndividualStandingsForTeamCompetition(
          teamStandings: competition.standings!,
          positionsCreator: StandingsPositionsWithExAequosCreator(),
        );
        final position = individualStandings.positionOf(context.subject);
        if (position != null) {
          points += rules.pointsMap![position] ?? 0;
        }
    }
  }

  CompetitionJumperScore? _jumperScoreFromTeam(Competition<CompetitionTeam> competition) {
    final teamOfJumper = teamOfJumperInStandings(
      jumper: context.subject,
      standings: competition.standings!,
    );
    if (teamOfJumper != null) {
      final teamScore =
          competition.standings!.scoreOf(teamOfJumper)! as CompetitionTeamScore;
      final jumperScore = teamScore.jumperScore(context.subject)!;
      return jumperScore;
    } else {
      return null;
    }
  }

  @override
  void setUpCompetitionScores() {
    final classificationRules =
        context.classification.rules as SimpleIndividualClassificationRules;
    for (var competition in significantCompetitions) {
      if (competition is Competition<SimulationJumper>) {
        final maybeScore =
            competition.standings!.scoreOf(context.subject) as CompetitionJumperScore?;
        if (maybeScore != null) {
          competitionScores.add(maybeScore);
        }
      } else if (competition is Competition<CompetitionTeam>) {
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
  ClassificationJumperScore constructScore() {
    return ClassificationJumperScore(
      subject: context.subject,
      classification: context.classification,
      competitionScores: competitionScores,
      points: points,
    );
  }
}
