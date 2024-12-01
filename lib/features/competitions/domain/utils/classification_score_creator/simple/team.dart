import 'package:sj_manager/features/competitions/domain/entities/scoring/score/classification_scores.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/competition_scores.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/subjects/classification_team.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/subjects/competition_team.dart';
import 'package:sj_manager/features/competitions/domain/utils/classification_score_creator/context/simple_classification_score_creating_context.dart';
import 'package:sj_manager/features/competitions/domain/utils/classification_score_creator/simple/generic.dart';
import 'package:sj_manager/features/competitions/domain/utils/competition_standings_utils.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/to_embrace/classification/simple_classification_rules.dart';
import 'package:sj_manager/to_embrace/competition/competition.dart';
import 'package:sj_manager/to_embrace/competition/competition_labels.dart';

class SimpleClassificationTeamScoreCreator extends SimpleClassificationScoreCreator<
    ClassificationTeam,
    ClassificationTeamScore,
    SimpleClassificationTeamScoreCreatingContext> {
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
  void setUpCompetitionScores() {
    final classificationRules =
        context.classification.rules as SimpleTeamClassificationRules;
    for (var competition in significantCompetitions) {
      if (competition is Competition<SimulationJumper>) {
        if (classificationRules.includeJumperPointsFromIndividualCompetitions) {
          for (var jumperScore in _scoresOfTeamJumpers(competition)) {
            competitionScores.add(jumperScore);
          }
        }
      } else if (competition is Competition<CompetitionTeam>) {
        final score =
            competition.standings!.scoreOf(context.subject) as CompetitionTeamScore?;
        if (score != null) {
          competitionScores.add(score);
        }
      }
    }
  }

  List<CompetitionJumperScore> _scoresOfTeamJumpers(
      Competition<SimulationJumper> competition) {
    final jumperScores = <CompetitionJumperScore>[];
    for (var score in competition.standings!.scores) {
      final individualScore = score as CompetitionJumperScore;
      final competitionTeam = context.subject as CompetitionTeam;
      if (competitionTeam.subjects.contains(individualScore.subject)) {
        jumperScores.add(individualScore);
      }
    }
    return jumperScores;
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
    final rules = context.classification.rules as SimpleTeamClassificationRules;
    switch (rules.scoringType) {
      case SimpleClassificationScoringType.pointsFromCompetitions:
        final jumpersFromTeam = context.simulationTeam.jumpers;
        for (var jumper in jumpersFromTeam) {
          final score = competition.standings!.scoreOf(jumper) as CompetitionJumperScore?;
          if (score != null) {
            points += score.points;
          }
        }
      case SimpleClassificationScoringType.pointsFromMap:
        final jumpersFromTeam = context.simulationTeam.jumpers;
        for (var jumper in jumpersFromTeam) {
          final position = competition.standings!.positionOf(jumper);
          if (position != null) {
            points += rules.pointsMap![position] ?? 0;
          }
        }
    }
  }

  void _addPointsForTeam(Competition<CompetitionTeam> competition) {
    final rules = context.classification.rules as SimpleTeamClassificationRules;
    switch (rules.scoringType) {
      case SimpleClassificationScoringType.pointsFromCompetitions:
        final team = findCompetitionTeamFromSimulationTeam(
          parentTeam: context.simulationTeam,
          competition: competition,
        );
        final teamScore = competition.standings!.scoreOf(team)! as CompetitionTeamScore;
        final multiplier = rules.pointsModifiers[competition] ?? 1.0;
        points += teamScore.points * multiplier;
      case SimpleClassificationScoringType.pointsFromMap:
        final team = findCompetitionTeamFromSimulationTeam(
          parentTeam: context.simulationTeam,
          competition: competition,
        );
        final teamPosition = competition.standings!.positionOf(team)!;
        points += rules.pointsMap![teamPosition]!;
    }
  }

  @override
  ClassificationTeamScore constructScore() {
    return ClassificationTeamScore(
      subject: context.subject,
      classification: context.classification,
      competitionScores: competitionScores,
      points: points,
    );
  }
}
