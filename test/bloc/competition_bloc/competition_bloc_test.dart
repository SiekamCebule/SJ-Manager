import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sj_manager/bloc/competitions/competition_gate_cubit.dart';
import 'package:sj_manager/bloc/competitions/competition_judging_cubit.dart';
import 'package:sj_manager/bloc/competitions/competition_startlist_cubit.dart';
import 'package:sj_manager/bloc/competitions/competition_status_cubit.dart';
import 'package:sj_manager/bloc/competitions/states/competition_status_state.dart';
import 'package:sj_manager/models/running/competition_flow_controller.dart';
import 'package:sj_manager/models/running/competition_start_list_repository.dart';
import 'package:sj_manager/models/running/competition_status.dart';
import 'package:sj_manager/models/running/default_competition_flow_controllers.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/judges_creator/concrete/default.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/judges_creator/judges_creator.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';

import 'competition_bloc_test.mocks.dart';

@GenerateMocks([
  DefaultJudgesCreator,
  JudgesCreatingContext,
  DefaultIndividualCompetitionFlowController
])
void main() {
  group('CompetitionGateCubit', () {
    late CompetitionGateCubit competitionGateCubit;
    setUp(() {
      competitionGateCubit = CompetitionGateCubit(initialGate: 14);
    });

    blocTest(
      'Simple gate manipulations',
      build: () => competitionGateCubit,
      act: (cubit) {
        cubit.lowerByJury(2);
        cubit.raiseByJury(1);
        cubit.raiseByJury(1);
        cubit.lowerByJury(3);
      },
      expect: () => [
        const CompetitionGateState(gate: 12, initialGate: 14),
        const CompetitionGateState(gate: 13, initialGate: 14),
        const CompetitionGateState(gate: 14, initialGate: 14),
        const CompetitionGateState(gate: 11, initialGate: 14),
      ],
      tearDown: () => competitionGateCubit.close(),
    );

    blocTest(
      'Lowering gate by coach',
      build: () => competitionGateCubit,
      act: (cubit) {
        cubit.lowerByJury(2);
        cubit.lowerByCoach(1);
        cubit.lowerByCoach(2);
        cubit.undoLoweringByCoach();
      },
      expect: () => [
        const CompetitionGateState(gate: 12, initialGate: 14),
        const CompetitionGateLoweredByCoachState(
            gate: 11, initialGate: 14, howMuchLowered: 1),
        const CompetitionGateLoweredByCoachState(
            gate: 10, initialGate: 14, howMuchLowered: 2),
        const CompetitionGateState(gate: 12, initialGate: 14),
      ],
      tearDown: () => competitionGateCubit.close(),
    );

    blocTest(
      'Preparing for next round',
      build: () => competitionGateCubit,
      act: (cubit) {
        cubit.lowerByJury(2);
        cubit.raiseByJury(1);
        cubit.setUpBeforeRound(15);
        cubit.setUpBeforeRound(16);
        cubit.lowerByJury(1);
      },
      expect: () => [
        const CompetitionGateState(gate: 12, initialGate: 14),
        const CompetitionGateState(gate: 13, initialGate: 14),
        const CompetitionGateState(gate: 15, initialGate: 15),
        const CompetitionGateState(gate: 16, initialGate: 16),
        const CompetitionGateState(gate: 15, initialGate: 16),
      ],
      tearDown: () => competitionGateCubit.close(),
    );
  });

  group('CompetitionJudgingCubit', () {
    late CompetitionJudgingCubit competitionJudgingCubit;
    late JudgesCreatingContext context;
    const judges = [18.5, 18.0, 17.5, 18.0, 17.5];

    setUp(() {
      final judgesCreator = MockDefaultJudgesCreator();
      when(judgesCreator.compute(any)).thenReturn(judges);

      context = MockJudgesCreatingContext();

      competitionJudgingCubit = CompetitionJudgingCubit(
        judgesCreator: judgesCreator,
      );
    });

    test('Judging with a delay', () async {
      const delays = [
        Duration(milliseconds: 500),
        Duration(milliseconds: 200),
        Duration(milliseconds: 700),
        Duration(milliseconds: 500),
        Duration(milliseconds: 1000),
      ];

      competitionJudgingCubit.judgeJumpStyle(
        context: context,
        delayJudgeShowing: (judgeIndex) => delays[judgeIndex],
      );

      await Future.delayed(const Duration(milliseconds: 150));
      expect(
        competitionJudgingCubit.state,
        const CompetitionJudgingHasData(
          judges: judges,
          availableIndexes: {},
        ),
      );
      await Future.delayed(const Duration(milliseconds: 100)); // 250
      expect(
        competitionJudgingCubit.state,
        const CompetitionJudgingHasData(
          judges: judges,
          availableIndexes: {1},
        ),
      );
      await Future.delayed(const Duration(milliseconds: 270)); // 520
      expect(
        competitionJudgingCubit.state,
        const CompetitionJudgingHasData(
          judges: judges,
          availableIndexes: {0, 1, 3},
        ),
      );
      await Future.delayed(const Duration(milliseconds: 500)); // 1020
      expect(
        competitionJudgingCubit.state,
        const CompetitionJudgingHasData(
          judges: judges,
          availableIndexes: {0, 1, 2, 3, 4},
        ),
      );

      competitionJudgingCubit.close();
    });
  });
  group('CompetitionStartlistCubit', () {
    late CompetitionStartlistCubit<String> startlistCubit;
    final startlist = CompetitionStartlistRepo.fromEntitiesList(
        entities: ['Kamil Stoch', 'Dawid Kubacki', 'Jakub Wolny']);

    setUp(() {
      startlistCubit = CompetitionStartlistCubit(startlist: startlist);
    });

    blocTest(
      'Typical scenario',
      build: () => startlistCubit,
      expect: () => <CompetitionStartlistState<String>>[
        const CompetitionStartlistUnfinished(
          currentEntity: 'Dawid Kubacki',
          nextEntity: 'Jakub Wolny',
          currentEntityIndexInStartlist: 1,
          remainingEntities: ['Dawid Kubacki', 'Jakub Wolny'],
        ),
        const CompetitionStartlistUnfinished(
          currentEntity: 'Jakub Wolny',
          nextEntity: null,
          currentEntityIndexInStartlist: 2,
          remainingEntities: ['Jakub Wolny'],
        ),
        const CompetitionStartlistFinished(),
      ],
      act: (bloc) {
        startlistCubit.complete('Kamil Stoch');
        startlistCubit.complete('Dawid Kubacki');
        startlistCubit.complete('Jakub Wolny');
      },
      tearDown: () => startlistCubit.close(),
    );
  });

  group('CompetitionStatusCubit', () {
    late CompetitionStatusCubit<Jumper> competitionStatusCubit;
    late CompetitionFlowController<Jumper> flowController;

    setUp(() {
      flowController = MockDefaultIndividualCompetitionFlowController();
      when(flowController.currentRoundIndex).thenReturnInOrder([0, 0, 0, 0, 1, 1, 1]);
      when(flowController.shouldEndRound())
          .thenReturnInOrder([false, false, false, true, false, false, true]);
      when(flowController.shouldEndCompetition())
          .thenReturnInOrder([false, false, false, false, false, false, true]);
      competitionStatusCubit = CompetitionStatusCubit(flowController: flowController);
    });

    blocTest(
      'Typical scenario',
      build: () => competitionStatusCubit,
      expect: () => const [
        IndividualCompetitionStatusState(
            roundIndex: 0, status: CompetitionStatus.running),
        IndividualCompetitionStatusState(
            roundIndex: 0, status: CompetitionStatus.endingRound),
        IndividualCompetitionStatusState(
            roundIndex: 0, status: CompetitionStatus.duringBreak),
        IndividualCompetitionStatusState(
            roundIndex: 1, status: CompetitionStatus.duringBreak),
        IndividualCompetitionStatusState(
            roundIndex: 1, status: CompetitionStatus.running),
        IndividualCompetitionStatusState(
            roundIndex: 1, status: CompetitionStatus.endingEntirely),
      ],
      act: (bloc) {
        competitionStatusCubit.start();
        competitionStatusCubit.ensureEnds();
        competitionStatusCubit.ensureEnds();
        competitionStatusCubit.ensureEnds();
        competitionStatusCubit.ensureEnds();
        competitionStatusCubit.startBreak();
        competitionStatusCubit.goToNextRound();
        competitionStatusCubit.resume();
        competitionStatusCubit.ensureEnds();
        competitionStatusCubit.ensureEnds();
        competitionStatusCubit.ensureEnds();
        // Do some work after competition end (in UI)
      },
      tearDown: () => competitionStatusCubit.close(),
    );
  });
}
