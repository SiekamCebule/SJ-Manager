import 'package:sj_manager/models/running/competition_start_list_repository.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';

abstract class CompetitionFlowController<E> {
  CompetitionFlowController({
    required this.rules,
    required this.startlist,
    required this.currentRoundIndex,
  });

  final DefaultCompetitionRules<E> rules;
  final CompetitionStartlistRepo<E> startlist;
  int currentRoundIndex;

  bool shouldEndRound();
  bool shouldEndCompetition();
}

abstract class IndividualCompetitionFlowController
    extends CompetitionFlowController<Jumper> {
  IndividualCompetitionFlowController({
    required super.rules,
    required super.startlist,
    required super.currentRoundIndex,
  });
}

abstract class TeamCompetitionFlowController extends CompetitionFlowController<Team> {
  TeamCompetitionFlowController({
    required super.rules,
    required super.startlist,
    required super.currentRoundIndex,
    required this.currentGroupIndex,
  });

  int currentGroupIndex;

  bool shouldEndGroup();
}
