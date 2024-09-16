import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_team_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/group_rules/team_competition_group_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/entities_limit.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/ko/ko_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/competition_score_creator/competition_score_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/judges_creator/judges_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/jump_score_creator/jump_score_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/wind_averager/wind_averager.dart';
import 'package:sj_manager/models/simulation_db/standings/score/details/competition_score_details.dart';
import 'package:sj_manager/models/simulation_db/standings/score/score.dart';
import 'package:sj_manager/models/simulation_db/standings/score/typedefs.dart';
import 'package:sj_manager/models/simulation_db/standings/standings_positions_map_creator/standings_positions_creator.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';

class DefaultIndividualCompetitionRoundRules
    extends DefaultCompetitionRoundRules<Jumper> {
  const DefaultIndividualCompetitionRoundRules({
    required super.limit,
    required super.bibsAreReassigned,
    required super.startlistIsSorted,
    required super.gateCanChange,
    required super.gateCompensationsEnabled,
    required super.windCompensationsEnabled,
    required super.windAverager,
    required super.inrunLightsEnabled,
    required super.dsqEnabled,
    required super.positionsCreator,
    required super.ruleOf95HsFallEnabled,
    required super.judgesCount,
    required super.judgesCreator,
    required super.significantJudgesCount,
    required super.competitionScoreCreator,
    required super.jumpScoreCreator,
    required super.koRules,
  });

  DefaultIndividualCompetitionRoundRules copyWith({
    EntitiesLimit? limit,
    bool? bibsAreReassigned,
    bool? startlistIsSorted,
    bool? gateCanChange,
    bool? gateCompensationsEnabled,
    bool? windCompensationsEnabled,
    WindAverager? windAverager,
    bool? inrunLightsEnabled,
    bool? dsqEnabled,
    StandingsPositionsCreator? positionsCreator,
    bool? ruleOf95HsFallEnabled,
    int? judgesCount,
    JudgesCreator? judgesCreator,
    int? significantJudgesCount,
    JumpScoreCreator? jumpScoreCreator,
    CompetitionScoreCreator<Score<Jumper, CompetitionScoreDetails>>?
        competitionScoreCreator,
    KoRoundRules? koRules,
  }) {
    return DefaultIndividualCompetitionRoundRules(
      limit: limit ?? this.limit,
      bibsAreReassigned: bibsAreReassigned ?? this.bibsAreReassigned,
      startlistIsSorted: startlistIsSorted ?? this.startlistIsSorted,
      gateCanChange: gateCanChange ?? this.gateCanChange,
      gateCompensationsEnabled: gateCompensationsEnabled ?? this.gateCompensationsEnabled,
      windCompensationsEnabled: windCompensationsEnabled ?? this.windCompensationsEnabled,
      windAverager: windAverager ?? this.windAverager,
      inrunLightsEnabled: inrunLightsEnabled ?? this.inrunLightsEnabled,
      dsqEnabled: dsqEnabled ?? this.dsqEnabled,
      positionsCreator: positionsCreator ?? this.positionsCreator,
      ruleOf95HsFallEnabled: ruleOf95HsFallEnabled ?? this.ruleOf95HsFallEnabled,
      judgesCount: judgesCount ?? this.judgesCount,
      judgesCreator: judgesCreator ?? this.judgesCreator,
      significantJudgesCount: significantJudgesCount ?? this.significantJudgesCount,
      jumpScoreCreator: jumpScoreCreator ?? this.jumpScoreCreator,
      competitionScoreCreator: competitionScoreCreator ?? this.competitionScoreCreator,
      koRules: koRules ?? this.koRules,
    );
  }

  DefaultTeamCompetitionRoundRules toTeam({
    required CompetitionScoreCreator<CompetitionTeamScore> competitionScoreCreator,
    required List<TeamCompetitionGroupRules> groups,
  }) {
    return DefaultTeamCompetitionRoundRules(
      limit: limit,
      bibsAreReassigned: bibsAreReassigned,
      startlistIsSorted: startlistIsSorted,
      gateCanChange: gateCanChange,
      gateCompensationsEnabled: gateCompensationsEnabled,
      windCompensationsEnabled: windCompensationsEnabled,
      windAverager: windAverager,
      inrunLightsEnabled: inrunLightsEnabled,
      dsqEnabled: dsqEnabled,
      positionsCreator: positionsCreator,
      ruleOf95HsFallEnabled: ruleOf95HsFallEnabled,
      judgesCount: judgesCount,
      judgesCreator: judgesCreator,
      significantJudgesCount: significantJudgesCount,
      competitionScoreCreator: competitionScoreCreator,
      jumpScoreCreator: jumpScoreCreator,
      koRules: koRules,
      groups: groups,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
      ];
}
