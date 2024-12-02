import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/competition_scores.dart';
import 'package:sj_manager/features/competitions/domain/utils/competition_score_creator/context/competition_score_creating_context.dart';
import 'package:sj_manager/features/competitions/domain/utils/competition_score_creator/specific/individual/default_linear_individual_competition_score_creator.dart';
import 'package:sj_manager/features/competitions/domain/utils/competition_score_creator/specific/team/default_linear_team_competition_score_creator.dart';
import 'package:sj_manager/core/core_classes/country/country.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/core/core_classes/sex.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/subjects/competition_team.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/country_team.dart';
import 'package:sj_manager/to_embrace/competition/competition.dart';

import 'competition_rules_utilities_test.mocks.dart';

@GenerateMocks([
  IndividualCompetitionScoreCreatingContext,
  TeamCompetitionScoreCreatingContext,
  Country,
  SimulationJumper,
  Competition,
])
void main() {
  test(DefaultLinearIndividualCompetitionScoreCreator, () {
    final competition = MockCompetition();
    final creator = DefaultLinearIndividualCompetitionScoreCreator();
    final context = MockIndividualCompetitionScoreCreatingContext();
    final jumper = MockSimulationJumper();
    final jumps = [
      CompetitionJumpScore(
        subject: jumper,
        jump: const JumpSimulationRecord(
          distance: 128.5,
          landingType: LandingType.telemark,
        ),
        points: 130.4,
        competition: competition,
      ),
      CompetitionJumpScore(
        subject: jumper,
        jump: const JumpSimulationRecord(
          distance: 124.5,
          landingType: LandingType.twoFooted,
        ),
        points: 115.2,
        competition: competition,
      ),
    ];
    when(context.subject).thenReturn(jumper);
    when(context.currentRound).thenReturn(2);
    when(context.currentScore).thenReturn(
      CompetitionJumperScore(
        subject: jumper,
        competition: competition,
        jumps: [
          jumps[0],
        ],
        points: 130.4,
      ),
    );
    when(context.lastJumpScore).thenReturn(jumps[1]);
    final score = creator.create(context);
    expect(
      score,
      CompetitionJumperScore(
        subject: jumper,
        points: 130.4 + 115.2,
        jumps: jumps,
        competition: competition,
      ),
    );
  });

  test(DefaultLinearTeamCompetitionScoreCreator, () {
    final competition = MockCompetition();
    final creator = DefaultLinearTeamCompetitionScoreCreator();
    final context = MockTeamCompetitionScoreCreatingContext();
    final germany = Country.monolingual(code: 'de', language: 'en', name: 'Germany');
    final team = CompetitionTeam(
      parentTeam: CountryTeam(
        sex: Sex.male,
        country: germany,
        subteams: [],
      ),
      subjects: [
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
        competition: competition,
        subject: team.subjects[0],
        points: 120.1,
        jumps: [
          CompetitionJumpScore(
            subject: team.subjects[0],
            jump: const JumpSimulationRecord(
              distance: 134.5,
              landingType: LandingType.telemark,
            ),
            points: 120.1,
            competition: competition,
          ),
        ],
      ),
      CompetitionJumperScore(
        competition: competition,
        subject: team.subjects[1],
        points: 134.5,
        jumps: [
          CompetitionJumpScore(
            subject: team.subjects[0],
            jump: const JumpSimulationRecord(
              distance: 141.0,
              landingType: LandingType.telemark,
            ),
            points: 134.5,
            competition: competition,
          ),
        ],
      ),
    ];
    when(context.subject).thenReturn(team);
    when(context.currentRound).thenReturn(1);
    when(context.currentGroup).thenReturn(3);
    final currentScore = CompetitionTeamScore(
      subject: team,
      points: 254.6,
      subscores: jumperScores,
      competition: competition,
    );
    when(context.currentScore).thenReturn(currentScore);
    final lastJumpScore = CompetitionJumpScore(
      subject: team.subjects[2],
      jump: const JumpSimulationRecord(
        distance: 132.5,
        landingType: LandingType.telemark,
      ),
      points: 122.2,
      competition: competition,
    );
    when(context.lastJumpScore).thenReturn(lastJumpScore);
    final score = creator.create(context);
    expect(
      score,
      CompetitionTeamScore(
        subject: team,
        points: 376.8,
        subscores: [
          ...jumperScores,
          CompetitionJumperScore(
              subject: team.subjects[2],
              points: 122.2,
              jumps: [lastJumpScore],
              competition: competition),
        ],
        competition: competition,
      ),
    );
  });
}
