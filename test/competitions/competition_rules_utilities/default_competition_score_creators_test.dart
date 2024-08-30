import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/competition_score_creator/competition_score_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/competition_score_creator/concrete/individual/default_linear.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/competition_score_creator/concrete/team/default_linear.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/competition_scores.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/jump_score.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/country/team_facts.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/sex.dart';
import 'package:sj_manager/models/user_db/team/competition_team.dart';
import 'package:sj_manager/models/user_db/team/country_team.dart';

import 'default_competition_score_creators_test.mocks.dart';

@GenerateMocks([
  IndividualCompetitionScoreCreatingContext,
  TeamCompetitionScoreCreatingContext,
  Country
])
void main() {
  test(DefaultLinearIndividualCompetitionScoreCreator, () {
    final creator = DefaultLinearIndividualCompetitionScoreCreator();
    final context = MockIndividualCompetitionScoreCreatingContext();
    final jumper = MaleJumper.empty(country: MockCountry())
        .copyWith(name: 'Kamil', surname: 'Stoch');
    final jumps = [
      SimpleJumpScore(
        entity: jumper,
        jumpRecord: const JumpSimulationRecord(
          distance: 128.5,
          landingType: LandingType.telemark,
        ),
        points: 130.4,
      ),
      SimpleJumpScore(
        entity: jumper,
        jumpRecord: const JumpSimulationRecord(
            distance: 124.5, landingType: LandingType.twoFooted),
        points: 115.2,
      ),
    ];
    when(context.entity).thenReturn(jumper);
    when(context.currentRound).thenReturn(2);
    when(context.currentScore).thenReturn(
      CompetitionJumperScore(
        entity: jumper,
        points: 130.4,
        jumpScores: [jumps[0]],
      ),
    );
    when(context.lastJumpScore).thenReturn(jumps[1]);
    final score = creator.compute(context);
    expect(
      score,
      CompetitionJumperScore<Jumper>(
        entity: jumper,
        points: 130.4 + 115.2,
        jumpScores: jumps,
      ),
    );
  });

  test(DefaultLinearTeamCompetitionScoreCreator, () {
    final creator = DefaultLinearTeamCompetitionScoreCreator();
    final context = MockTeamCompetitionScoreCreatingContext();
    final germany = Country.monolingual(code: 'de', language: 'en', name: 'Germany');
    final team = CompetitionTeam(
      parentTeam: CountryTeam(
        facts: const TeamFacts.empty(),
        sex: Sex.male,
        country: germany,
      ),
      jumpers: [
        Jumper.empty(country: germany).copyWith(name: 'Markus', surname: 'Eisenbichler'),
        Jumper.empty(country: germany).copyWith(name: 'Karl', surname: 'Geiger'),
        Jumper.empty(country: germany).copyWith(name: 'Luca', surname: 'Roth'),
        Jumper.empty(country: germany).copyWith(name: 'Andreas', surname: 'Wellinger'),
      ],
    );
    final jumperScores = [
      CompetitionJumperScore(
        entity: team.jumpers[0],
        points: 120.1,
        jumpScores: [
          SimpleJumpScore(
            entity: team.jumpers[0],
            jumpRecord: const JumpSimulationRecord(
              distance: 134.5,
              landingType: LandingType.telemark,
            ),
            points: 120.1,
          ),
        ],
      ),
      CompetitionJumperScore(
        entity: team.jumpers[1],
        points: 134.5,
        jumpScores: [
          SimpleJumpScore(
            entity: team.jumpers[1],
            jumpRecord: const JumpSimulationRecord(
              distance: 141.0,
              landingType: LandingType.telemark,
            ),
            points: 134.5,
          ),
        ],
      ),
    ];
    when(context.entity).thenReturn(team);
    when(context.currentRound).thenReturn(1);
    when(context.currentGroup).thenReturn(3);
    final currentScore = CompetitionTeamScore(
      entity: team,
      points: 254.6,
      jumperScores: jumperScores,
    );
    when(context.currentScore).thenReturn(currentScore);
    final lastJumpScore = SimpleJumpScore(
      entity: team.jumpers[2],
      jumpRecord: const JumpSimulationRecord(
        distance: 132.5,
        landingType: LandingType.telemark,
      ),
      points: 122.2,
    );
    when(context.lastJumpScore).thenReturn(lastJumpScore);
    final score = creator.compute(context);
    expect(
      score,
      CompetitionTeamScore<CompetitionTeam>(
        entity: team,
        points: 376.8,
        jumperScores: [
          ...jumperScores,
          CompetitionJumperScore(
            entity: team.jumpers[2],
            points: 122.2,
            jumpScores: [
              lastJumpScore,
            ],
          ),
        ],
      ),
    );
  });
}
