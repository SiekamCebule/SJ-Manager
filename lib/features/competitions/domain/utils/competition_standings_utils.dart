import 'package:sj_manager/features/competitions/domain/entities/scoring/score/competition_scores.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/standings.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/to_embrace/competition/competition.dart';
import 'package:sj_manager/features/competitions/domain/utils/standings_position_creators/standings_positions_creator.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/subjects/competition_team.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/simulation_team.dart';

Standings createIndividualStandingsForTeamCompetition({
  required Standings teamStandings,
  required StandingsPositionsCreator positionsCreator,
}) {
  final individualStandings = Standings(positionsCreator: positionsCreator);
  for (final score in teamStandings.scores) {
    final teamScore = score as CompetitionTeamScore;
    for (var jumperScore in teamScore.subscores.cast<CompetitionJumperScore>()) {
      individualStandings.add(jumperScore);
    }
  }
  return individualStandings;
}

Standings createTeamStandingsForIndividualCompetition({
  required Competition competition,
  required StandingsPositionsCreator positionsCreator,
  required List<CompetitionTeam> teams,
}) {
  final teamStandings = Standings(positionsCreator: positionsCreator);
  for (var team in teams) {
    teamStandings.add(
      CompetitionTeamScore(
        subject: team,
        points: 0,
        subscores: [],
        competition: competition,
      ),
    );
  }

  for (final score in competition.standings!.scores) {
    final teamOfJumper =
        teamOfJumperInStandings(jumper: score.subject, standings: teamStandings);
    final teamScore = teamStandings.scoreOf(teamOfJumper!) as CompetitionTeamScore;
    final updatedJumperScores = teamScore.subscores.map((jumperScore) {
      if (jumperScore.subject == score.subject) {
        return score;
      } else {
        return jumperScore;
      }
    }).toList();
    final newTeamScore = CompetitionTeamScore(
      subject: teamScore.subject,
      points: teamScore.points + score.points,
      subscores: updatedJumperScores,
      competition: competition,
    );
    teamStandings.add(newTeamScore);
  }

  return teamStandings;
}

E? teamOfJumperInStandings<E extends CompetitionTeam>({
  required SimulationJumper jumper,
  required Standings standings,
}) {
  for (var teamScore in standings.scores) {
    if (teamScore.subject.jumpers.contains(jumper)) {
      return teamScore.subject;
    }
  }
  return null;
}

CompetitionTeam<T> findCompetitionTeamFromSimulationTeam<T extends SimulationTeam>({
  required T parentTeam,
  required Competition<CompetitionTeam> competition,
}) {
  final competitionTeams = competition.standings!.scores.map((score) => score.subject);
  return competitionTeams
          .singleWhere((competitionTeam) => competitionTeam.parentTeam == parentTeam)
      as CompetitionTeam<T>;
}
