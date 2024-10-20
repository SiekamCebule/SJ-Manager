// Mocks generated by Mockito 5.4.4 from annotations
// in sj_manager/test/competitions/jump_score_creator_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i16;
import 'package:osje_sim/osje_sim.dart' as _i7;
import 'package:sj_manager/models/simulation/competition/competition.dart'
    as _i5;
import 'package:sj_manager/models/simulation/competition/rules/competition_round_rules/default_individual_competition_round_rules.dart'
    as _i14;
import 'package:sj_manager/models/simulation/competition/rules/competition_round_rules/default_team_competition_round_rules.dart'
    as _i15;
import 'package:sj_manager/models/simulation/competition/rules/competition_round_rules/group_rules/team_competition_group_rules.dart'
    as _i23;
import 'package:sj_manager/models/simulation/competition/rules/entities_limit.dart'
    as _i18;
import 'package:sj_manager/models/simulation/competition/rules/ko/ko_round_rules.dart'
    as _i20;
import 'package:sj_manager/models/simulation/competition/rules/utils/competition_score_creator/competition_score_creator.dart'
    as _i13;
import 'package:sj_manager/models/simulation/competition/rules/utils/judges_creator/judges_creator.dart'
    as _i10;
import 'package:sj_manager/models/simulation/competition/rules/utils/jump_score_creator/jump_score_creator.dart'
    as _i11;
import 'package:sj_manager/models/simulation/competition/rules/utils/wind_averager/wind_averager.dart'
    as _i19;
import 'package:sj_manager/models/simulation/event_series/event_series.dart'
    as _i2;
import 'package:sj_manager/models/simulation/standings/score/details/competition_score_details.dart'
    as _i12;
import 'package:sj_manager/models/simulation/standings/score/details/score_details.dart'
    as _i4;
import 'package:sj_manager/models/simulation/standings/score/score.dart' as _i8;
import 'package:sj_manager/models/simulation/standings/standings.dart' as _i3;
import 'package:sj_manager/models/simulation/standings/standings_positions_map_creator/standings_positions_creator.dart'
    as _i9;
import 'package:sj_manager/models/user_db/hill/hill.dart' as _i6;
import 'package:sj_manager/models/user_db/jumper/jumper.dart' as _i17;
import 'package:sj_manager/models/user_db/team/competition_team.dart' as _i21;
import 'package:sj_manager/models/user_db/team/team.dart' as _i22;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEventSeries_0 extends _i1.SmartFake implements _i2.EventSeries {
  _FakeEventSeries_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCompetition_1<E1, S extends _i3.Standings<dynamic, _i4.ScoreDetails>>
    extends _i1.SmartFake implements _i5.Competition<E1, S> {
  _FakeCompetition_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeHill_2 extends _i1.SmartFake implements _i6.Hill {
  _FakeHill_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeWindMeasurement_3 extends _i1.SmartFake
    implements _i7.WindMeasurement {
  _FakeWindMeasurement_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeJumpSimulationRecord_4 extends _i1.SmartFake
    implements _i7.JumpSimulationRecord {
  _FakeJumpSimulationRecord_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeStandingsPositionsCreator_5<
        S extends _i8.Score<dynamic, _i4.ScoreDetails>> extends _i1.SmartFake
    implements _i9.StandingsPositionsCreator<S> {
  _FakeStandingsPositionsCreator_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeJudgesCreator_6 extends _i1.SmartFake implements _i10.JudgesCreator {
  _FakeJudgesCreator_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeJumpScoreCreator_7<E> extends _i1.SmartFake
    implements _i11.JumpScoreCreator<E> {
  _FakeJumpScoreCreator_7(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCompetitionScoreCreator_8<
        S extends _i8.Score<dynamic, _i12.CompetitionScoreDetails<dynamic>>>
    extends _i1.SmartFake implements _i13.CompetitionScoreCreator<S> {
  _FakeCompetitionScoreCreator_8(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDefaultIndividualCompetitionRoundRules_9 extends _i1.SmartFake
    implements _i14.DefaultIndividualCompetitionRoundRules {
  _FakeDefaultIndividualCompetitionRoundRules_9(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDefaultTeamCompetitionRoundRules_10 extends _i1.SmartFake
    implements _i15.DefaultTeamCompetitionRoundRules {
  _FakeDefaultTeamCompetitionRoundRules_10(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [JumpScoreCreatingContext].
///
/// See the documentation for Mockito's code generation for more information.
class MockJumpScoreCreatingContext<E> extends _i1.Mock
    implements _i11.JumpScoreCreatingContext<E> {
  MockJumpScoreCreatingContext() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.EventSeries get eventSeries => (super.noSuchMethod(
        Invocation.getter(#eventSeries),
        returnValue: _FakeEventSeries_0(
          this,
          Invocation.getter(#eventSeries),
        ),
      ) as _i2.EventSeries);

  @override
  _i5.Competition<dynamic, _i3.Standings<dynamic, _i4.ScoreDetails>>
      get competition => (super.noSuchMethod(
            Invocation.getter(#competition),
            returnValue: _FakeCompetition_1<dynamic,
                _i3.Standings<dynamic, _i4.ScoreDetails>>(
              this,
              Invocation.getter(#competition),
            ),
          ) as _i5
              .Competition<dynamic, _i3.Standings<dynamic, _i4.ScoreDetails>>);

  @override
  int get currentRound => (super.noSuchMethod(
        Invocation.getter(#currentRound),
        returnValue: 0,
      ) as int);

  @override
  _i6.Hill get hill => (super.noSuchMethod(
        Invocation.getter(#hill),
        returnValue: _FakeHill_2(
          this,
          Invocation.getter(#hill),
        ),
      ) as _i6.Hill);

  @override
  int get initialGate => (super.noSuchMethod(
        Invocation.getter(#initialGate),
        returnValue: 0,
      ) as int);

  @override
  int get gate => (super.noSuchMethod(
        Invocation.getter(#gate),
        returnValue: 0,
      ) as int);

  @override
  _i7.WindMeasurement get windDuringJump => (super.noSuchMethod(
        Invocation.getter(#windDuringJump),
        returnValue: _FakeWindMeasurement_3(
          this,
          Invocation.getter(#windDuringJump),
        ),
      ) as _i7.WindMeasurement);

  @override
  double get averagedWind => (super.noSuchMethod(
        Invocation.getter(#averagedWind),
        returnValue: 0.0,
      ) as double);

  @override
  _i7.JumpSimulationRecord get jumpRecord => (super.noSuchMethod(
        Invocation.getter(#jumpRecord),
        returnValue: _FakeJumpSimulationRecord_4(
          this,
          Invocation.getter(#jumpRecord),
        ),
      ) as _i7.JumpSimulationRecord);

  @override
  List<double> get judges => (super.noSuchMethod(
        Invocation.getter(#judges),
        returnValue: <double>[],
      ) as List<double>);

  @override
  E get entity => (super.noSuchMethod(
        Invocation.getter(#entity),
        returnValue: _i16.dummyValue<E>(
          this,
          Invocation.getter(#entity),
        ),
      ) as E);
}

/// A class which mocks [DefaultIndividualCompetitionRoundRules].
///
/// See the documentation for Mockito's code generation for more information.
class MockDefaultIndividualCompetitionRoundRules extends _i1.Mock
    implements _i14.DefaultIndividualCompetitionRoundRules {
  MockDefaultIndividualCompetitionRoundRules() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<Object?> get props => (super.noSuchMethod(
        Invocation.getter(#props),
        returnValue: <Object?>[],
      ) as List<Object?>);

  @override
  bool get bibsAreReassigned => (super.noSuchMethod(
        Invocation.getter(#bibsAreReassigned),
        returnValue: false,
      ) as bool);

  @override
  bool get startlistIsSorted => (super.noSuchMethod(
        Invocation.getter(#startlistIsSorted),
        returnValue: false,
      ) as bool);

  @override
  bool get gateCanChange => (super.noSuchMethod(
        Invocation.getter(#gateCanChange),
        returnValue: false,
      ) as bool);

  @override
  bool get gateCompensationsEnabled => (super.noSuchMethod(
        Invocation.getter(#gateCompensationsEnabled),
        returnValue: false,
      ) as bool);

  @override
  bool get windCompensationsEnabled => (super.noSuchMethod(
        Invocation.getter(#windCompensationsEnabled),
        returnValue: false,
      ) as bool);

  @override
  bool get inrunLightsEnabled => (super.noSuchMethod(
        Invocation.getter(#inrunLightsEnabled),
        returnValue: false,
      ) as bool);

  @override
  bool get dsqEnabled => (super.noSuchMethod(
        Invocation.getter(#dsqEnabled),
        returnValue: false,
      ) as bool);

  @override
  _i9.StandingsPositionsCreator<_i8.Score<dynamic, _i4.ScoreDetails>>
      get positionsCreator => (super.noSuchMethod(
            Invocation.getter(#positionsCreator),
            returnValue: _FakeStandingsPositionsCreator_5<
                _i8.Score<dynamic, _i4.ScoreDetails>>(
              this,
              Invocation.getter(#positionsCreator),
            ),
          ) as _i9
              .StandingsPositionsCreator<_i8.Score<dynamic, _i4.ScoreDetails>>);

  @override
  bool get ruleOf95HsFallEnabled => (super.noSuchMethod(
        Invocation.getter(#ruleOf95HsFallEnabled),
        returnValue: false,
      ) as bool);

  @override
  int get judgesCount => (super.noSuchMethod(
        Invocation.getter(#judgesCount),
        returnValue: 0,
      ) as int);

  @override
  _i10.JudgesCreator get judgesCreator => (super.noSuchMethod(
        Invocation.getter(#judgesCreator),
        returnValue: _FakeJudgesCreator_6(
          this,
          Invocation.getter(#judgesCreator),
        ),
      ) as _i10.JudgesCreator);

  @override
  int get significantJudgesCount => (super.noSuchMethod(
        Invocation.getter(#significantJudgesCount),
        returnValue: 0,
      ) as int);

  @override
  _i11.JumpScoreCreator<dynamic> get jumpScoreCreator => (super.noSuchMethod(
        Invocation.getter(#jumpScoreCreator),
        returnValue: _FakeJumpScoreCreator_7<dynamic>(
          this,
          Invocation.getter(#jumpScoreCreator),
        ),
      ) as _i11.JumpScoreCreator<dynamic>);

  @override
  _i13.CompetitionScoreCreator<
          _i8.Score<_i17.Jumper, _i12.CompetitionScoreDetails<dynamic>>>
      get competitionScoreCreator => (super.noSuchMethod(
            Invocation.getter(#competitionScoreCreator),
            returnValue: _FakeCompetitionScoreCreator_8<
                _i8.Score<_i17.Jumper, _i12.CompetitionScoreDetails<dynamic>>>(
              this,
              Invocation.getter(#competitionScoreCreator),
            ),
          ) as _i13.CompetitionScoreCreator<
              _i8.Score<_i17.Jumper, _i12.CompetitionScoreDetails<dynamic>>>);

  @override
  bool get judgesEnabled => (super.noSuchMethod(
        Invocation.getter(#judgesEnabled),
        returnValue: false,
      ) as bool);

  @override
  _i14.DefaultIndividualCompetitionRoundRules copyWith({
    _i18.EntitiesLimit? limit,
    bool? bibsAreReassigned,
    bool? startlistIsSorted,
    bool? gateCanChange,
    bool? gateCompensationsEnabled,
    bool? windCompensationsEnabled,
    _i19.WindAverager? windAverager,
    bool? inrunLightsEnabled,
    bool? dsqEnabled,
    _i9.StandingsPositionsCreator<_i8.Score<dynamic, _i4.ScoreDetails>>?
        positionsCreator,
    bool? ruleOf95HsFallEnabled,
    int? judgesCount,
    _i10.JudgesCreator? judgesCreator,
    int? significantJudgesCount,
    _i11.JumpScoreCreator<dynamic>? jumpScoreCreator,
    _i13.CompetitionScoreCreator<
            _i8.Score<_i17.Jumper, _i12.CompetitionScoreDetails<dynamic>>>?
        competitionScoreCreator,
    _i20.KoRoundRules<dynamic>? koRules,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #copyWith,
          [],
          {
            #limit: limit,
            #bibsAreReassigned: bibsAreReassigned,
            #startlistIsSorted: startlistIsSorted,
            #gateCanChange: gateCanChange,
            #gateCompensationsEnabled: gateCompensationsEnabled,
            #windCompensationsEnabled: windCompensationsEnabled,
            #windAverager: windAverager,
            #inrunLightsEnabled: inrunLightsEnabled,
            #dsqEnabled: dsqEnabled,
            #positionsCreator: positionsCreator,
            #ruleOf95HsFallEnabled: ruleOf95HsFallEnabled,
            #judgesCount: judgesCount,
            #judgesCreator: judgesCreator,
            #significantJudgesCount: significantJudgesCount,
            #jumpScoreCreator: jumpScoreCreator,
            #competitionScoreCreator: competitionScoreCreator,
            #koRules: koRules,
          },
        ),
        returnValue: _FakeDefaultIndividualCompetitionRoundRules_9(
          this,
          Invocation.method(
            #copyWith,
            [],
            {
              #limit: limit,
              #bibsAreReassigned: bibsAreReassigned,
              #startlistIsSorted: startlistIsSorted,
              #gateCanChange: gateCanChange,
              #gateCompensationsEnabled: gateCompensationsEnabled,
              #windCompensationsEnabled: windCompensationsEnabled,
              #windAverager: windAverager,
              #inrunLightsEnabled: inrunLightsEnabled,
              #dsqEnabled: dsqEnabled,
              #positionsCreator: positionsCreator,
              #ruleOf95HsFallEnabled: ruleOf95HsFallEnabled,
              #judgesCount: judgesCount,
              #judgesCreator: judgesCreator,
              #significantJudgesCount: significantJudgesCount,
              #jumpScoreCreator: jumpScoreCreator,
              #competitionScoreCreator: competitionScoreCreator,
              #koRules: koRules,
            },
          ),
        ),
      ) as _i14.DefaultIndividualCompetitionRoundRules);

  @override
  _i15.DefaultTeamCompetitionRoundRules toTeam({
    required _i13.CompetitionScoreCreator<
            _i8.Score<_i21.CompetitionTeam<_i22.Team>,
                _i12.CompetitionTeamScoreDetails>>?
        competitionScoreCreator,
    required List<_i23.TeamCompetitionGroupRules>? groups,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #toTeam,
          [],
          {
            #competitionScoreCreator: competitionScoreCreator,
            #groups: groups,
          },
        ),
        returnValue: _FakeDefaultTeamCompetitionRoundRules_10(
          this,
          Invocation.method(
            #toTeam,
            [],
            {
              #competitionScoreCreator: competitionScoreCreator,
              #groups: groups,
            },
          ),
        ),
      ) as _i15.DefaultTeamCompetitionRoundRules);
}
