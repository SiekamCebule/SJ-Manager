import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/competition_score_creator/competition_score_creator.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/competition_score_creator/concrete/individual/default_linear.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/competition_score_creator/concrete/team/default_linear.dart';
import 'package:sj_manager/domain/entities/simulation/standings/score/details/competition_score_details.dart';
import 'package:sj_manager/domain/entities/simulation/standings/score/details/jump_score_details.dart';
import 'package:sj_manager/domain/entities/simulation/standings/score/score.dart';
import 'package:sj_manager/domain/entities/simulation/standings/score/typedefs.dart';

import 'package:sj_manager/core/classes/country/country.dart';
import 'package:sj_manager/core/classes/country_team/country_team_facts_model.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/features/game_variants/data/models/game_variant_database.dart/sex.dart';
import 'package:sj_manager/domain/entities/simulation/team/competition_team.dart';
import 'package:sj_manager/core/classes/country_team/country_team.dart';

import 'competition_rules_utilities_test.mocks.dart';

@GenerateMocks([
  IndividualCompetitionScoreCreatingContext,
  TeamCompetitionScoreCreatingContext,
  Country
])
void main() {
  test(DefaultLinearIndividualCompetitionScoreCreator, () {
    final creator = DefaultLinearIndividualCompetitionScoreCreator();
    final context = MockIndividualCompetitionScoreCreatingContext();
    final jumper = MaleJumperDbRecord.empty(country: MockCountry())
        .copyWith(name: 'Kamil', surname: 'Stoch');
    final jumps = [
      Score<JumperDbRecord, SimpleJumpScoreDetails>(
        entity: jumper,
        details: const SimpleJumpScoreDetails(
          jumpRecord: JumpSimulationRecord(
            distance: 128.5,
            landingType: LandingType.telemark,
          ),
        ),
        points: 130.4,
      ),
      Score<JumperDbRecord, SimpleJumpScoreDetails>(
        entity: jumper,
        details: const SimpleJumpScoreDetails(
          jumpRecord: JumpSimulationRecord(
            distance: 124.5,
            landingType: LandingType.twoFooted,
          ),
        ),
        points: 115.2,
      ),
    ];
    when(context.entity).thenReturn(jumper);
    when(context.currentRound).thenReturn(2);
    when(context.currentScore).thenReturn(
      CompetitionJumperScore(
        entity: jumper,
        points: 130.4,
        details: CompetitionJumperScoreDetails(
          jumpScores: [
            jumps[0],
          ],
        ),
      ),
    );
    when(context.lastJumpScore).thenReturn(jumps[1]);
    final score = creator.compute(context);
    expect(
      score,
      CompetitionJumperScore(
        entity: jumper,
        points: 130.4 + 115.2,
        details: CompetitionJumperScoreDetails(
          jumpScores: jumps,
        ),
      ),
    );
  });

  test(DefaultLinearTeamCompetitionScoreCreator, () {
    final creator = DefaultLinearTeamCompetitionScoreCreator();
    final context = MockTeamCompetitionScoreCreatingContext();
    final germany = Country.monolingual(code: 'de', language: 'en', name: 'Germany');
    final team = CompetitionTeam(
      parentTeam: CountryTeam(
        facts: const CountryTeamFacts.empty(),
        sex: Sex.male,
        country: germany,
      ),
      jumpers: [
        JumperDbRecord.empty(country: germany)
            .copyWith(name: 'Markus', surname: 'Eisenbichler'),
        JumperDbRecord.empty(country: germany).copyWith(name: 'Karl', surname: 'Geiger'),
        JumperDbRecord.empty(country: germany).copyWith(name: 'Luca', surname: 'Roth'),
        JumperDbRecord.empty(country: germany)
            .copyWith(name: 'Andreas', surname: 'Wellinger'),
      ],
    );
    final jumperScores = [
      CompetitionJumperScore(
        entity: team.jumpers[0],
        points: 120.1,
        details: CompetitionJumperScoreDetails(
          jumpScores: [
            Score<JumperDbRecord, SimpleJumpScoreDetails>(
              entity: team.jumpers[0],
              details: const SimpleJumpScoreDetails(
                jumpRecord: JumpSimulationRecord(
                  distance: 134.5,
                  landingType: LandingType.telemark,
                ),
              ),
              points: 120.1,
            ),
          ],
        ),
      ),
      CompetitionJumperScore(
        entity: team.jumpers[1],
        points: 134.5,
        details: CompetitionJumperScoreDetails(
          jumpScores: [
            Score<JumperDbRecord, SimpleJumpScoreDetails>(
              entity: team.jumpers[0],
              details: const SimpleJumpScoreDetails(
                jumpRecord: JumpSimulationRecord(
                  distance: 141.0,
                  landingType: LandingType.telemark,
                ),
              ),
              points: 134.5,
            ),
          ],
        ),
      ),
    ];
    when(context.entity).thenReturn(team);
    when(context.currentRound).thenReturn(1);
    when(context.currentGroup).thenReturn(3);
    final currentScore = CompetitionTeamScore(
      entity: team,
      points: 254.6,
      details: CompetitionTeamScoreDetails(jumperScores: jumperScores),
    );
    when(context.currentScore).thenReturn(currentScore);
    final lastJumpScore = Score<JumperDbRecord, SimpleJumpScoreDetails>(
      entity: team.jumpers[2],
      details: const SimpleJumpScoreDetails(
        jumpRecord: JumpSimulationRecord(
          distance: 132.5,
          landingType: LandingType.telemark,
        ),
      ),
      points: 122.2,
    );
    when(context.lastJumpScore).thenReturn(lastJumpScore);
    final score = creator.compute(context);
    expect(
      score,
      CompetitionTeamScore(
        entity: team,
        points: 376.8,
        details: CompetitionTeamScoreDetails(
          jumperScores: [
            ...jumperScores,
            CompetitionJumperScore(
              entity: team.jumpers[2],
              points: 122.2,
              details: CompetitionJumperScoreDetails(
                jumpScores: [lastJumpScore],
              ),
            ),
          ],
        ),
      ),
    );
  });
}
