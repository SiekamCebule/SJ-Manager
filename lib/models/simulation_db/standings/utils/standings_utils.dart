import 'package:sj_manager/models/simulation_db/competition/competition.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/competition_scores.dart';
import 'package:sj_manager/models/simulation_db/standings/standings.dart';
import 'package:sj_manager/models/simulation_db/standings/standings_positions_map_creator/standings_positions_creator.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/competition_team.dart';
import 'package:sj_manager/models/user_db/team/team.dart';

Standings<Jumper> createIndividualStandingsForTeamCompetition({
  required Standings<Team> teamStandings,
  required StandingsPositionsCreator positionsCreator,
}) {
  final individualStandings = Standings<Jumper>(positionsCreator: positionsCreator);
  for (final score in teamStandings.scores) {
    final teamScore = score as CompetitionTeamScore;
    for (var jumperScore in teamScore.jumperScores) {
      individualStandings.addScore(newScore: jumperScore);
    }
  }
  return individualStandings;
}

Standings<CompetitionTeam> createTeamStandingsForIndividualCompetition({
  required Standings<Jumper> individualStandings,
  required StandingsPositionsCreator positionsCreator,
  required List<CompetitionTeam> teams,
}) {
  final teamStandings = Standings<CompetitionTeam>(positionsCreator: positionsCreator);
  for (var team in teams) {
    teamStandings.addScore(
      newScore: CompetitionTeamScore(entity: team, points: 0, jumperScores: []),
    );
  }

  for (final score in individualStandings.scores) {
    final individualScore = score as CompetitionJumperScore;
    final teamOfJumper =
        teamOfJumperInStandings(jumper: individualScore.entity, standings: teamStandings);
    final teamScore =
        teamStandings.scoreOf(teamOfJumper!)! as CompetitionTeamScore<CompetitionTeam>;
    final updatedJumperScores = teamScore.jumperScores.map((currentScore) {
      if (currentScore.entity == individualScore.entity) {
        return individualScore;
      } else {
        return currentScore;
      }
    }).toList();
    final newTeamScore = CompetitionTeamScore(
      entity: teamScore.entity,
      points: teamScore.points + individualScore.points,
      jumperScores: updatedJumperScores,
    );
    teamStandings.addScore(newScore: newTeamScore);
  }

  return teamStandings;
}

E? teamOfJumperInStandings<E extends CompetitionTeam>(
    {required Jumper jumper, required Standings<E> standings}) {
  for (var teamScore in standings.scores) {
    if (teamScore.entity.jumpers.contains(jumper)) {
      return teamScore.entity;
    }
  }
  return null;
}

CompetitionTeam<T> findCompetitionTeam<T extends Team>({
  required T parentTeam,
  required Competition<CompetitionTeam> competition,
}) {
  final competitionTeams = competition.standings!.scores.map((score) => score.entity);
  return competitionTeams
          .singleWhere((competitionTeam) => competitionTeam.parentTeam == parentTeam)
      as CompetitionTeam<T>;
}
