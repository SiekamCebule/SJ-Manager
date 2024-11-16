import 'package:sj_manager/data/models/simulation/competition/competition.dart';
import 'package:sj_manager/data/models/simulation/standings/score/details/competition_score_details.dart';
import 'package:sj_manager/data/models/simulation/standings/score/typedefs.dart';
import 'package:sj_manager/data/models/simulation/standings/standings.dart';
import 'package:sj_manager/data/models/simulation/standings/standings_positions_map_creator/standings_positions_creator.dart';
import 'package:sj_manager/data/models/database/jumper/jumper_db_record.dart';
import 'package:sj_manager/data/models/database/team/competition_team.dart';
import 'package:sj_manager/data/models/database/team/team.dart';

Standings<JumperDbRecord, CompetitionJumperScoreDetails>
    createIndividualStandingsForTeamCompetition({
  required Standings<Team, CompetitionTeamScoreDetails> teamStandings,
  required StandingsPositionsCreator<CompetitionJumperScore> positionsCreator,
}) {
  final individualStandings = Standings<JumperDbRecord, CompetitionJumperScoreDetails>(
      positionsCreator: positionsCreator);
  for (final score in teamStandings.scores) {
    final teamScore = score as CompetitionTeamScore;
    for (var jumperScore in teamScore.details.jumperScores) {
      individualStandings.addScore(newScore: jumperScore);
    }
  }
  return individualStandings;
}

Standings<CompetitionTeam, CompetitionTeamScoreDetails>
    createTeamStandingsForIndividualCompetition({
  required Standings<JumperDbRecord, CompetitionJumperScoreDetails> individualStandings,
  required StandingsPositionsCreator<CompetitionTeamScore> positionsCreator,
  required List<CompetitionTeam> teams,
}) {
  final teamStandings = Standings<CompetitionTeam, CompetitionTeamScoreDetails>(
      positionsCreator: positionsCreator);
  for (var team in teams) {
    teamStandings.addScore(
      newScore: CompetitionTeamScore(
        entity: team,
        points: 0,
        details: CompetitionTeamScoreDetails(jumperScores: []),
      ),
    );
  }

  for (final score in individualStandings.scores) {
    final teamOfJumper =
        teamOfJumperInStandings(jumper: score.entity, standings: teamStandings);
    final teamScore = teamStandings.scoreOf(teamOfJumper!)!;
    final updatedJumperScores = teamScore.details.jumperScores.map((currentScore) {
      if (currentScore.entity == score.entity) {
        return score;
      } else {
        return currentScore;
      }
    }).toList();
    final newTeamScore = CompetitionTeamScore(
      entity: teamScore.entity,
      points: teamScore.points + score.points,
      details: CompetitionTeamScoreDetails(jumperScores: updatedJumperScores),
    );
    teamStandings.addScore(newScore: newTeamScore);
  }

  return teamStandings;
}

E? teamOfJumperInStandings<E extends CompetitionTeam>(
    {required JumperDbRecord jumper,
    required Standings<E, CompetitionTeamScoreDetails> standings}) {
  for (var teamScore in standings.scores) {
    if (teamScore.entity.jumpers.contains(jumper)) {
      return teamScore.entity;
    }
  }
  return null;
}

CompetitionTeam<T> findCompetitionTeam<T extends Team>({
  required T parentTeam,
  required Competition<CompetitionTeam, dynamic> competition,
}) {
  final competitionTeams = competition.standings!.scores.map((score) => score.entity);
  return competitionTeams
          .singleWhere((competitionTeam) => competitionTeam.parentTeam == parentTeam)
      as CompetitionTeam<T>;
}
