// Mocks generated by Mockito 5.4.4 from annotations
// in sj_manager/test/classifications/classification_rules_utilities_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i22;
import 'package:sj_manager/core/core_classes/hill/hill.dart' as _i2;
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart'
    as _i14;
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series.dart'
    as _i13;
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/score/details/classification_score_details.dart'
    as _i12;
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/score/details/competition_score_details.dart'
    as _i17;
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/score/details/score_details.dart'
    as _i5;
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/score/score.dart'
    as _i7;
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/standings.dart'
    as _i4;
import 'package:sj_manager/features/competitions/domain/utils/standings_position_creators/standings_positions_creator.dart'
    as _i8;
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/simulation_team.dart'
    as _i27;
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/subjects/competition_team.dart'
    as _i26;
import 'package:sj_manager/to_embrace/classification/classification.dart' as _i11;
import 'package:sj_manager/to_embrace/classification/simple_classification_rules.dart'
    as _i9;
import 'package:sj_manager/to_embrace/competition/competition.dart' as _i6;
import 'package:sj_manager/to_embrace/competition/rules/competition_round_rules/default_competition_round_rules.dart'
    as _i29;
import 'package:sj_manager/to_embrace/competition/rules/competition_round_rules/default_individual_competition_round_rules.dart'
    as _i19;
import 'package:sj_manager/to_embrace/competition/rules/competition_round_rules/default_team_competition_round_rules.dart'
    as _i20;
import 'package:sj_manager/to_embrace/competition/rules/competition_round_rules/group_rules/team_competition_group_rules.dart'
    as _i28;
import 'package:sj_manager/to_embrace/competition/rules/competition_rules/default_competition_rules.dart'
    as _i21;
import 'package:sj_manager/to_embrace/competition/rules/competition_rules/default_competition_rules_provider.dart'
    as _i3;
import 'package:sj_manager/to_embrace/competition/rules/entities_limit.dart' as _i23;
import 'package:sj_manager/to_embrace/competition/rules/ko/ko_round_rules.dart' as _i25;
import 'package:sj_manager/to_embrace/competition/rules/utils/classification_score_creator/classification_score_creator.dart'
    as _i10;
import 'package:sj_manager/features/competitions/domain/utils/competition_score_creator/competition_score_creator.dart'
    as _i18;
import 'package:sj_manager/to_embrace/competition/rules/utils/judges_creator/judges_creator.dart'
    as _i15;
import 'package:sj_manager/features/competitions/domain/utils/jump_score_creator/jump_score_creator.dart'
    as _i16;
import 'package:sj_manager/to_embrace/competition/rules/utils/wind_averager/wind_averager.dart'
    as _i24;

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

class _FakeHill_0 extends _i1.SmartFake implements _i2.Hill {
  _FakeHill_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDateTime_1 extends _i1.SmartFake implements DateTime {
  _FakeDateTime_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDefaultCompetitionRulesProvider_2<T> extends _i1.SmartFake
    implements _i3.DefaultCompetitionRulesProvider<T> {
  _FakeDefaultCompetitionRulesProvider_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCompetition_3<E1, S1 extends _i4.Standings<dynamic, _i5.ScoreDetails>>
    extends _i1.SmartFake implements _i6.Competition<E1, S1> {
  _FakeCompetition_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeStandingsPositionsCreator_4<S extends _i7.Score<dynamic, _i5.ScoreDetails>>
    extends _i1.SmartFake implements _i8.StandingsPositionsCreator<S> {
  _FakeStandingsPositionsCreator_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDefaultClassificationRules_5<E1> extends _i1.SmartFake
    implements _i9.SimpleClassificationRules<E1> {
  _FakeDefaultClassificationRules_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeClassificationScoreCreator_6<
        E,
        C extends _i10.ClassificationScoreCreatingContext<
            E,
            _i11.Classification<E, _i4.Standings<E, _i12.ClassificationScoreDetails>,
                _i9.ClassificationRules<E>>>> extends _i1.SmartFake
    implements _i10.ClassificationScoreCreator<E, C> {
  _FakeClassificationScoreCreator_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeEventSeries_7 extends _i1.SmartFake implements _i13.EventSeries {
  _FakeEventSeries_7(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDefaultClassification_8<E, S extends _i4.Standings<E, _i5.ScoreDetails>>
    extends _i1.SmartFake implements _i11.SimpleClassification<E, S> {
  _FakeDefaultClassification_8(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeJumperDbRecord_9 extends _i1.SmartFake implements _i14.JumperDbRecord {
  _FakeJumperDbRecord_9(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeScore_10<E1, D1 extends _i5.ScoreDetails> extends _i1.SmartFake
    implements _i7.Score<E1, D1> {
  _FakeScore_10(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeJudgesCreator_11 extends _i1.SmartFake implements _i15.JudgesCreator {
  _FakeJudgesCreator_11(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeJumpScoreCreator_12<E> extends _i1.SmartFake
    implements _i16.JumpScoreCreator<E> {
  _FakeJumpScoreCreator_12(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCompetitionScoreCreator_13<
        S extends _i7.Score<dynamic, _i17.CompetitionScoreDetails<dynamic>>>
    extends _i1.SmartFake implements _i18.CompetitionScoreCreator<S> {
  _FakeCompetitionScoreCreator_13(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDefaultIndividualCompetitionRoundRules_14 extends _i1.SmartFake
    implements _i19.DefaultIndividualCompetitionRoundRules {
  _FakeDefaultIndividualCompetitionRoundRules_14(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDefaultTeamCompetitionRoundRules_15 extends _i1.SmartFake
    implements _i20.DefaultTeamCompetitionRoundRules {
  _FakeDefaultTeamCompetitionRoundRules_15(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDefaultCompetitionRules_16<T1> extends _i1.SmartFake
    implements _i21.DefaultCompetitionRules<T1> {
  _FakeDefaultCompetitionRules_16(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [Competition].
///
/// See the documentation for Mockito's code generation for more information.
class MockCompetition<E, S extends _i4.Standings<dynamic, _i5.ScoreDetails>>
    extends _i1.Mock implements _i6.Competition<E, S> {
  MockCompetition() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Hill get hill => (super.noSuchMethod(
        Invocation.getter(#hill),
        returnValue: _FakeHill_0(
          this,
          Invocation.getter(#hill),
        ),
      ) as _i2.Hill);

  @override
  DateTime get date => (super.noSuchMethod(
        Invocation.getter(#date),
        returnValue: _FakeDateTime_1(
          this,
          Invocation.getter(#date),
        ),
      ) as DateTime);

  @override
  _i3.DefaultCompetitionRulesProvider<E> get rules => (super.noSuchMethod(
        Invocation.getter(#rules),
        returnValue: _FakeDefaultCompetitionRulesProvider_2<E>(
          this,
          Invocation.getter(#rules),
        ),
      ) as _i3.DefaultCompetitionRulesProvider<E>);

  @override
  List<Object> get labels => (super.noSuchMethod(
        Invocation.getter(#labels),
        returnValue: <Object>[],
      ) as List<Object>);

  @override
  List<Object?> get props => (super.noSuchMethod(
        Invocation.getter(#props),
        returnValue: <Object?>[],
      ) as List<Object?>);

  @override
  _i6.Competition<E, S> copyWith({
    _i2.Hill? hill,
    DateTime? date,
    _i21.DefaultCompetitionRules<E>? rules,
    S? standings,
    List<Object>? labels,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #copyWith,
          [],
          {
            #hill: hill,
            #date: date,
            #rules: rules,
            #standings: standings,
            #labels: labels,
          },
        ),
        returnValue: _FakeCompetition_3<E, S>(
          this,
          Invocation.method(
            #copyWith,
            [],
            {
              #hill: hill,
              #date: date,
              #rules: rules,
              #standings: standings,
              #labels: labels,
            },
          ),
        ),
      ) as _i6.Competition<E, S>);
}

/// A class which mocks [Standings].
///
/// See the documentation for Mockito's code generation for more information.
class MockStandings<E, D extends _i5.ScoreDetails> extends _i1.Mock
    implements _i4.Standings<E, D> {
  MockStandings() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.StandingsPositionsCreator<_i7.Score<E, D>> get positionsCreator =>
      (super.noSuchMethod(
        Invocation.getter(#positionsCreator),
        returnValue: _FakeStandingsPositionsCreator_4<_i7.Score<E, D>>(
          this,
          Invocation.getter(#positionsCreator),
        ),
      ) as _i8.StandingsPositionsCreator<_i7.Score<E, D>>);

  @override
  set positionsCreator(
          _i8.StandingsPositionsCreator<_i7.Score<E, D>>? _positionsCreator) =>
      super.noSuchMethod(
        Invocation.setter(
          #positionsCreator,
          _positionsCreator,
        ),
        returnValueForMissingStub: null,
      );

  @override
  List<_i7.Score<E, D>> get leaders => (super.noSuchMethod(
        Invocation.getter(#leaders),
        returnValue: <_i7.Score<E, D>>[],
      ) as List<_i7.Score<E, D>>);

  @override
  int get length => (super.noSuchMethod(
        Invocation.getter(#length),
        returnValue: 0,
      ) as int);

  @override
  int get lastPosition => (super.noSuchMethod(
        Invocation.getter(#lastPosition),
        returnValue: 0,
      ) as int);

  @override
  List<_i7.Score<E, D>> get scores => (super.noSuchMethod(
        Invocation.getter(#scores),
        returnValue: <_i7.Score<E, D>>[],
      ) as List<_i7.Score<E, D>>);

  @override
  List<Object?> get props => (super.noSuchMethod(
        Invocation.getter(#props),
        returnValue: <Object?>[],
      ) as List<Object?>);

  @override
  void addScore({
    required _i7.Score<E, D>? newScore,
    bool? overwrite = false,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #addScore,
          [],
          {
            #newScore: newScore,
            #overwrite: overwrite,
          },
        ),
        returnValueForMissingStub: null,
      );

  @override
  void remove({required _i7.Score<E, D>? score}) => super.noSuchMethod(
        Invocation.method(
          #remove,
          [],
          {#score: score},
        ),
        returnValueForMissingStub: null,
      );

  @override
  void update() => super.noSuchMethod(
        Invocation.method(
          #update,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  List<_i7.Score<E, D>> atPosition(int? position) => (super.noSuchMethod(
        Invocation.method(
          #atPosition,
          [position],
        ),
        returnValue: <_i7.Score<E, D>>[],
      ) as List<_i7.Score<E, D>>);

  @override
  int? positionOf(E? entity) => (super.noSuchMethod(Invocation.method(
        #positionOf,
        [entity],
      )) as int?);

  @override
  _i7.Score<E, D>? scoreOf(E? entity) => (super.noSuchMethod(Invocation.method(
        #scoreOf,
        [entity],
      )) as _i7.Score<E, D>?);

  @override
  bool containsEntity(E? entity) => (super.noSuchMethod(
        Invocation.method(
          #containsEntity,
          [entity],
        ),
        returnValue: false,
      ) as bool);

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [DefaultClassification].
///
/// See the documentation for Mockito's code generation for more information.
class MockDefaultClassification<E, S extends _i4.Standings<E, _i5.ScoreDetails>>
    extends _i1.Mock implements _i11.SimpleClassification<E, S> {
  MockDefaultClassification() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get name => (super.noSuchMethod(
        Invocation.getter(#name),
        returnValue: _i22.dummyValue<String>(
          this,
          Invocation.getter(#name),
        ),
      ) as String);

  @override
  _i9.SimpleClassificationRules<E> get rules => (super.noSuchMethod(
        Invocation.getter(#rules),
        returnValue: _FakeDefaultClassificationRules_5<E>(
          this,
          Invocation.getter(#rules),
        ),
      ) as _i9.SimpleClassificationRules<E>);

  @override
  List<Object?> get props => (super.noSuchMethod(
        Invocation.getter(#props),
        returnValue: <Object?>[],
      ) as List<Object?>);

  @override
  void updateStandings() => super.noSuchMethod(
        Invocation.method(
          #updateStandings,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [DefaultIndividualClassificationRules].
///
/// See the documentation for Mockito's code generation for more information.
class MockDefaultIndividualClassificationRules extends _i1.Mock
    implements _i9.SimpleIndividualClassificationRules {
  MockDefaultIndividualClassificationRules() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get includeApperancesInTeamCompetitions => (super.noSuchMethod(
        Invocation.getter(#includeApperancesInTeamCompetitions),
        returnValue: false,
      ) as bool);

  @override
  List<Object?> get props => (super.noSuchMethod(
        Invocation.getter(#props),
        returnValue: <Object?>[],
      ) as List<Object?>);

  @override
  _i9.SimpleClassificationScoringType get scoringType => (super.noSuchMethod(
        Invocation.getter(#scoringType),
        returnValue: _i9.SimpleClassificationScoringType.pointsFromCompetitions,
      ) as _i9.SimpleClassificationScoringType);

  @override
  List<_i6.Competition<dynamic, _i4.Standings<dynamic, _i5.ScoreDetails>>>
      get competitions => (super.noSuchMethod(
            Invocation.getter(#competitions),
            returnValue: <_i6
                .Competition<dynamic, _i4.Standings<dynamic, _i5.ScoreDetails>>>[],
          ) as List<_i6.Competition<dynamic, _i4.Standings<dynamic, _i5.ScoreDetails>>>);

  @override
  Map<_i6.Competition<dynamic, _i4.Standings<dynamic, _i5.ScoreDetails>>, double>
      get pointsModifiers => (super.noSuchMethod(
            Invocation.getter(#pointsModifiers),
            returnValue: <_i6
                .Competition<dynamic, _i4.Standings<dynamic, _i5.ScoreDetails>>,
                double>{},
          ) as Map<_i6.Competition<dynamic, _i4.Standings<dynamic, _i5.ScoreDetails>>,
              double>);

  @override
  _i10.ClassificationScoreCreator<
      _i14.JumperDbRecord,
      _i10.ClassificationScoreCreatingContext<
          _i14.JumperDbRecord,
          _i11.Classification<
              _i14.JumperDbRecord,
              _i4.Standings<_i14.JumperDbRecord, _i12.ClassificationScoreDetails>,
              _i9.ClassificationRules<_i14.JumperDbRecord>>>> get classificationScoreCreator =>
      (super.noSuchMethod(
        Invocation.getter(#classificationScoreCreator),
        returnValue: _FakeClassificationScoreCreator_6<
            _i14.JumperDbRecord,
            _i10.ClassificationScoreCreatingContext<
                _i14.JumperDbRecord,
                _i11.Classification<
                    _i14.JumperDbRecord,
                    _i4.Standings<_i14.JumperDbRecord, _i12.ClassificationScoreDetails>,
                    _i9.ClassificationRules<_i14.JumperDbRecord>>>>(
          this,
          Invocation.getter(#classificationScoreCreator),
        ),
      ) as _i10.ClassificationScoreCreator<
          _i14.JumperDbRecord,
          _i10.ClassificationScoreCreatingContext<
              _i14.JumperDbRecord,
              _i11.Classification<
                  _i14.JumperDbRecord,
                  _i4.Standings<_i14.JumperDbRecord, _i12.ClassificationScoreDetails>,
                  _i9.ClassificationRules<_i14.JumperDbRecord>>>>);
}

/// A class which mocks [DefaultIndividualClassificationScoreCreatingContext].
///
/// See the documentation for Mockito's code generation for more information.
class MockDefaultIndividualClassificationScoreCreatingContext extends _i1.Mock
    implements _i10.DefaultIndividualClassificationScoreCreatingContext {
  MockDefaultIndividualClassificationScoreCreatingContext() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i13.EventSeries get eventSeries => (super.noSuchMethod(
        Invocation.getter(#eventSeries),
        returnValue: _FakeEventSeries_7(
          this,
          Invocation.getter(#eventSeries),
        ),
      ) as _i13.EventSeries);

  @override
  _i6.Competition<_i14.JumperDbRecord,
          _i4.Standings<_i14.JumperDbRecord, _i17.CompetitionScoreDetails<dynamic>>>
      get lastCompetition => (super.noSuchMethod(
            Invocation.getter(#lastCompetition),
            returnValue: _FakeCompetition_3<
                _i14.JumperDbRecord,
                _i4
                .Standings<_i14.JumperDbRecord, _i17.CompetitionScoreDetails<dynamic>>>(
              this,
              Invocation.getter(#lastCompetition),
            ),
          ) as _i6.Competition<_i14.JumperDbRecord,
              _i4.Standings<_i14.JumperDbRecord, _i17.CompetitionScoreDetails<dynamic>>>);

  @override
  _i11.SimpleClassification<_i14.JumperDbRecord,
          _i4.Standings<_i14.JumperDbRecord, _i12.ClassificationScoreDetails>>
      get classification => (super.noSuchMethod(
            Invocation.getter(#classification),
            returnValue: _FakeDefaultClassification_8<_i14.JumperDbRecord,
                _i4.Standings<_i14.JumperDbRecord, _i12.ClassificationScoreDetails>>(
              this,
              Invocation.getter(#classification),
            ),
          ) as _i11.SimpleClassification<_i14.JumperDbRecord,
              _i4.Standings<_i14.JumperDbRecord, _i12.ClassificationScoreDetails>>);

  @override
  _i14.JumperDbRecord get entity => (super.noSuchMethod(
        Invocation.getter(#entity),
        returnValue: _FakeJumperDbRecord_9(
          this,
          Invocation.getter(#entity),
        ),
      ) as _i14.JumperDbRecord);
}

/// A class which mocks [Score].
///
/// See the documentation for Mockito's code generation for more information.
class MockScore<E, D extends _i5.ScoreDetails> extends _i1.Mock
    implements _i7.Score<E, D> {
  MockScore() {
    _i1.throwOnMissingStub(this);
  }

  @override
  E get entity => (super.noSuchMethod(
        Invocation.getter(#entity),
        returnValue: _i22.dummyValue<E>(
          this,
          Invocation.getter(#entity),
        ),
      ) as E);

  @override
  double get points => (super.noSuchMethod(
        Invocation.getter(#points),
        returnValue: 0.0,
      ) as double);

  @override
  D get details => (super.noSuchMethod(
        Invocation.getter(#details),
        returnValue: _i22.dummyValue<D>(
          this,
          Invocation.getter(#details),
        ),
      ) as D);

  @override
  List<Object?> get props => (super.noSuchMethod(
        Invocation.getter(#props),
        returnValue: <Object?>[],
      ) as List<Object?>);

  @override
  _i7.Score<E, D> copyWith({
    E? entity,
    double? points,
    D? details,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #copyWith,
          [],
          {
            #entity: entity,
            #points: points,
            #details: details,
          },
        ),
        returnValue: _FakeScore_10<E, D>(
          this,
          Invocation.method(
            #copyWith,
            [],
            {
              #entity: entity,
              #points: points,
              #details: details,
            },
          ),
        ),
      ) as _i7.Score<E, D>);

  @override
  bool operator <(_i7.Score<dynamic, _i5.ScoreDetails>? other) => (super.noSuchMethod(
        Invocation.method(
          #<,
          [other],
        ),
        returnValue: false,
      ) as bool);

  @override
  bool operator >(_i7.Score<dynamic, _i5.ScoreDetails>? other) => (super.noSuchMethod(
        Invocation.method(
          #>,
          [other],
        ),
        returnValue: false,
      ) as bool);

  @override
  int compareTo(_i7.Score<E, D>? other) => (super.noSuchMethod(
        Invocation.method(
          #compareTo,
          [other],
        ),
        returnValue: 0,
      ) as int);
}

/// A class which mocks [DefaultIndividualCompetitionRoundRules].
///
/// See the documentation for Mockito's code generation for more information.
class MockDefaultIndividualCompetitionRoundRules extends _i1.Mock
    implements _i19.DefaultIndividualCompetitionRoundRules {
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
  _i8.StandingsPositionsCreator<_i7.Score<dynamic, _i5.ScoreDetails>>
      get positionsCreator => (super.noSuchMethod(
            Invocation.getter(#positionsCreator),
            returnValue:
                _FakeStandingsPositionsCreator_4<_i7.Score<dynamic, _i5.ScoreDetails>>(
              this,
              Invocation.getter(#positionsCreator),
            ),
          ) as _i8.StandingsPositionsCreator<_i7.Score<dynamic, _i5.ScoreDetails>>);

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
  _i15.JudgesCreator get judgesCreator => (super.noSuchMethod(
        Invocation.getter(#judgesCreator),
        returnValue: _FakeJudgesCreator_11(
          this,
          Invocation.getter(#judgesCreator),
        ),
      ) as _i15.JudgesCreator);

  @override
  int get significantJudgesCount => (super.noSuchMethod(
        Invocation.getter(#significantJudgesCount),
        returnValue: 0,
      ) as int);

  @override
  _i16.JumpScoreCreator<dynamic> get jumpScoreCreator => (super.noSuchMethod(
        Invocation.getter(#jumpScoreCreator),
        returnValue: _FakeJumpScoreCreator_12<dynamic>(
          this,
          Invocation.getter(#jumpScoreCreator),
        ),
      ) as _i16.JumpScoreCreator<dynamic>);

  @override
  _i18.CompetitionScoreCreator<
          _i7.Score<_i14.JumperDbRecord, _i17.CompetitionScoreDetails<dynamic>>>
      get competitionScoreCreator => (super.noSuchMethod(
            Invocation.getter(#competitionScoreCreator),
            returnValue: _FakeCompetitionScoreCreator_13<
                _i7.Score<_i14.JumperDbRecord, _i17.CompetitionScoreDetails<dynamic>>>(
              this,
              Invocation.getter(#competitionScoreCreator),
            ),
          ) as _i18.CompetitionScoreCreator<
              _i7.Score<_i14.JumperDbRecord, _i17.CompetitionScoreDetails<dynamic>>>);

  @override
  bool get judgesEnabled => (super.noSuchMethod(
        Invocation.getter(#judgesEnabled),
        returnValue: false,
      ) as bool);

  @override
  _i19.DefaultIndividualCompetitionRoundRules copyWith({
    _i23.EntitiesLimit? limit,
    bool? bibsAreReassigned,
    bool? startlistIsSorted,
    bool? gateCanChange,
    bool? gateCompensationsEnabled,
    bool? windCompensationsEnabled,
    _i24.WindAverager? windAverager,
    bool? inrunLightsEnabled,
    bool? dsqEnabled,
    _i8.StandingsPositionsCreator<_i7.Score<dynamic, _i5.ScoreDetails>>? positionsCreator,
    bool? ruleOf95HsFallEnabled,
    int? judgesCount,
    _i15.JudgesCreator? judgesCreator,
    int? significantJudgesCount,
    _i16.JumpScoreCreator<dynamic>? jumpScoreCreator,
    _i18.CompetitionScoreCreator<
            _i7.Score<_i14.JumperDbRecord, _i17.CompetitionScoreDetails<dynamic>>>?
        competitionScoreCreator,
    _i25.KoRoundRules<dynamic>? koRules,
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
        returnValue: _FakeDefaultIndividualCompetitionRoundRules_14(
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
      ) as _i19.DefaultIndividualCompetitionRoundRules);

  @override
  _i20.DefaultTeamCompetitionRoundRules toTeam({
    required _i18.CompetitionScoreCreator<
            _i7.Score<_i26.CompetitionTeam<_i27.SimulationTeam>,
                _i17.CompetitionTeamScoreDetails>>?
        competitionScoreCreator,
    required List<_i28.TeamCompetitionGroupRules>? groups,
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
        returnValue: _FakeDefaultTeamCompetitionRoundRules_15(
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
      ) as _i20.DefaultTeamCompetitionRoundRules);
}

/// A class which mocks [DefaultCompetitionRules].
///
/// See the documentation for Mockito's code generation for more information.
class MockDefaultCompetitionRules<T> extends _i1.Mock
    implements _i21.DefaultCompetitionRules<T> {
  MockDefaultCompetitionRules() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<_i29.DefaultCompetitionRoundRules<T>> get rounds => (super.noSuchMethod(
        Invocation.getter(#rounds),
        returnValue: <_i29.DefaultCompetitionRoundRules<T>>[],
      ) as List<_i29.DefaultCompetitionRoundRules<T>>);

  @override
  int get roundsCount => (super.noSuchMethod(
        Invocation.getter(#roundsCount),
        returnValue: 0,
      ) as int);

  @override
  _i21.DefaultCompetitionRules<T> get competitionRules => (super.noSuchMethod(
        Invocation.getter(#competitionRules),
        returnValue: _FakeDefaultCompetitionRules_16<T>(
          this,
          Invocation.getter(#competitionRules),
        ),
      ) as _i21.DefaultCompetitionRules<T>);

  @override
  List<Object?> get props => (super.noSuchMethod(
        Invocation.getter(#props),
        returnValue: <Object?>[],
      ) as List<Object?>);

  @override
  _i21.DefaultCompetitionRules<T> copyWith(
          {List<_i29.DefaultCompetitionRoundRules<T>>? rounds}) =>
      (super.noSuchMethod(
        Invocation.method(
          #copyWith,
          [],
          {#rounds: rounds},
        ),
        returnValue: _FakeDefaultCompetitionRules_16<T>(
          this,
          Invocation.method(
            #copyWith,
            [],
            {#rounds: rounds},
          ),
        ),
      ) as _i21.DefaultCompetitionRules<T>);
}
