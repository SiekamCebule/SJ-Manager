import 'package:sj_manager/models/running/competition_flow_controller.dart';
import 'package:sj_manager/models/simulation/competition/rules/competition_round_rules/default_team_competition_round_rules.dart';

class DefaultIndividualCompetitionFlowController
    extends IndividualCompetitionFlowController {
  DefaultIndividualCompetitionFlowController({
    required super.rules,
    required super.startlist,
    required super.currentRoundIndex,
  });

  @override
  bool shouldEndCompetition() {
    return (currentRoundIndex == rules.roundsCount - 1) && shouldEndRound();
  }

  @override
  bool shouldEndRound() {
    return startlist.everyHasCompleted;
  }
}

class DefaultTeamCompetitionFlowController extends TeamCompetitionFlowController {
  DefaultTeamCompetitionFlowController({
    required super.rules,
    required super.startlist,
    required super.currentRoundIndex,
    required super.currentGroupIndex,
  });

  @override
  bool shouldEndCompetition() {
    return (currentRoundIndex == rules.roundsCount - 1) && shouldEndRound();
  }

  @override
  bool shouldEndRound() {
    final lastGroupIndex = rules.rounds
            .cast<DefaultTeamCompetitionRoundRules>()[currentRoundIndex]
            .groupsCount -
        1;
    return currentGroupIndex == lastGroupIndex && shouldEndGroup();
  }

  @override
  bool shouldEndGroup() {
    return startlist.everyHasCompleted;
  }
}
