import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:sj_manager/dart_eval/user_algorithms/bridge/concrete_algorithms/classification_score_creator_bridge.dart';
import 'package:sj_manager/dart_eval/user_algorithms/bridge/unary_algorithm_bridge.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/contexes/classification_score_creating_context.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/contexes/entity_related_algorithm_context.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/classification_score.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/competition.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/competition_jumper_score.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/competition_rules.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/competition_rules_preset.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/competition_rules_provider.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/competition_score.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/competition_team_score.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/country.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/country_team.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/enums/competition_type.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/enums/hill_profile_type.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/enums/hill_type_by_size.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/enums/jumps_consistency.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/enums/jumps_variability.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/enums/landing_ease.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/enums/landing_style.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/enums/sex.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/enums/typical_wind_direction.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/equatable_mixin.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/has_points_mixin.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/hill.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/jumper.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/jumper_skills.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/score.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/simple_jump.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/single_jump_score.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/standings.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/team.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/team_facts.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/value_repo.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/user_algorithm.dart';
import 'package:sj_manager/models/user_algorithms/user_algorithm.dart';

class NonMatchingUserAlgorithmTypeException implements Exception {
  const NonMatchingUserAlgorithmTypeException({
    required this.current,
    required this.expected,
    this.text,
  });

  final Type current;
  final Type expected;
  final String? text;

  @override
  String toString() {
    return 'Expected user algorithm of type $expected, but got $current${text != null ? '. $text' : null}';
  }
}

class UserAlgorithmLoaderFromFile<T extends UserAlgorithm> {
  Future<dynamic> load(String source) async {
    final compiler = Compiler();
    for (var enumDef in userAlgorithmBridgeEnums) {
      compiler.defineBridgeEnum(enumDef);
    }
    compiler.defineBridgeClasses(userAlgorithmBridgeClasses);

    final program = compiler.compile({
      'sj_manager': {
        'main.dart': source,
      }
    });
    final runtime = Runtime.ofProgram(program)
      /*..registerBridgeFunc(
          'package:sj_manager/bridge.dart', 'UnaryAlgorithm', $UnaryAlgorithm$bridge.$new,
          isBridge: true)*/
      ..registerBridgeFunc(
          'package:sj_manager/bridge.dart', 'UserAlgorithm.', $UserAlgorithm.$new)
      ..registerBridgeFunc(
          'package:sj_manager/bridge.dart',
          'ClassificationScoreCreatingContext.',
          $ClassificationScoreCreatingContext.$new) // Removed 'E'
      ..registerBridgeFunc('package:sj_manager/bridge.dart', 'ClassificationScore.',
          $ClassificationScore.$new)
      ..registerBridgeFunc('package:sj_manager/bridge.dart',
          'ClassificationScoreCreator.', $ClassificationScoreCreator$bridge.$new,
          isBridge: true)
      ..registerBridgeFunc(
          'package:sj_manager/bridge.dart', 'CompetitionRules.', $CompetitionRules.$new)
      ..registerBridgeFunc('package:sj_manager/bridge.dart', 'CompetitionJumperScore.',
          $CompetitionJumperScore.$new)
      ..registerBridgeFunc('package:sj_manager/bridge.dart', 'CompetitionTeamScore.',
          $CompetitionTeamScore.$new)
      ..registerBridgeFunc(
          'package:sj_manager/bridge.dart', 'SimpleJump.', $SimpleJump.$new)
      ..registerBridgeFunc(
          'package:sj_manager/bridge.dart', 'SingleJumpScore.', $SingleJumpScore.$new)
      ..registerBridgeFunc(
          'package:sj_manager/bridge.dart', 'CountryTeam.', $CountryTeam.$new)
      ..registerBridgeFunc(
          'package:sj_manager/bridge.dart', 'Competition.', $Competition.$new)
      ..registerBridgeFunc('package:sj_manager/bridge.dart', 'Country.', $Country.$new)
      ..registerBridgeFunc('package:sj_manager/bridge.dart', 'DateTime.', $DateTime.$new)
      ..registerBridgeFunc('package:sj_manager/bridge.dart', 'Hill.', $Hill.$new)
      ..registerBridgeFunc(
          'package:sj_manager/bridge.dart', 'Standings.', $Standings.$new)
      ..registerBridgeFunc(
          'package:sj_manager/bridge.dart', 'ValueRepo.', $ValueRepo.$new)
      ..registerBridgeFunc('package:sj_manager/bridge.dart', 'CompetitionRulesPreset.',
          $CompetitionRulesPreset.$new);

    runtime.registerBridgeEnumValues(
        'package:sj_manager/bridge.dart', 'CompetitionType', $CompetitionType.$values);
    runtime.registerBridgeEnumValues(
        'package:sj_manager/bridge.dart', 'HillProfileType', $HillProfileType.$values);
    runtime.registerBridgeEnumValues(
        'package:sj_manager/bridge.dart', 'HillTypeBySize', $HillTypeBySize.$values);
    runtime.registerBridgeEnumValues(
        'package:sj_manager/bridge.dart', 'JumpsConsistency', $JumpsConsistency.$values);
    runtime.registerBridgeEnumValues(
        'package:sj_manager/bridge.dart', 'JumpsVariability', $JumpsVariability.$values);
    runtime.registerBridgeEnumValues(
        'package:sj_manager/bridge.dart', 'LandingEase', $LandingEase.$values);
    runtime.registerBridgeEnumValues(
        'package:sj_manager/bridge.dart', 'LandingStyle', $LandingStyle.$values);
    runtime.registerBridgeEnumValues(
        'package:sj_manager/bridge.dart', 'Sex', $Sex.$values);
    runtime.registerBridgeEnumValues('package:sj_manager/bridge.dart',
        'TypicalWindDirection', $TypicalWindDirection.$values);

    final userAlgorithmBridge = runtime.executeLib(
      'package:sj_manager/main.dart',
      'create',
      [],
    ) as $UserAlgorithm;

    /*
        final userAlgorithm = userAlgorithmBridge.$value;
    final jumper = MaleJumper.empty(country: const Country.emptyNone());
    final context = ClassificationScoreCreatingContext(
      entity: jumper,
      playedCompetitions: [],
      classificationScore: ClassificationScore<Jumper>(
        entity: jumper,
        points: 233.4,
        competitionScores: <CompetitionScore<Jumper>>[],
      ),
    );

    final classificationScore =
        userAlgorithm.algorithm.compute(context) as ClassificationScore;
    final casted = classificationScore.cast<Jumper>();

        if (userAlgorithm is T) {
      throw '';
      return userAlgorithm;
    } else {
      throw NonMatchingUserAlgorithmTypeException(
        current: userAlgorithm.runtimeType,
        expected: T,
      );
    }
    */

    return userAlgorithmBridge.$value;
  }
}

final userAlgorithmBridgeClasses = <BridgeClassDef>[
  $ClassificationScoreCreator$bridge.$declaration,
  $UnaryAlgorithm$bridge.$declaration,
  $ClassificationScoreCreatingContext.$declaration,
  $EntityRelatedAlgorithmContext.$declaration,
  $ClassificationScore.$declaration,
  $CompetitionScore.$declaration,
  $CompetitionJumperScore.$declaration,
  //$CompetitionRoundRules.$declaration,
  $CompetitionRulesPreset.$declaration,
  $CompetitionRulesProvider.$declaration,
  $CompetitionRules.$declaration,
  $CompetitionTeamScore.$declaration,
  $Competition.$declaration,
  $CountryTeam.$declaration,
  $Country.$declaration,
  $DateTime.$declaration,
  $EquatableMixin.$declaration,
  $HasPointsMixin.$declaration,
  $Hill.$declaration,
  $JumperSkills.$declaration,
  $Jumper.$declaration,
  $Score.$declaration,
  $SimpleJump.$declaration,
  $SingleJumpScore.$declaration,
  $Standings.$declaration,
  $TeamFacts.$declaration,
  $Team.$declaration,
  $ValueRepo.$declaration,
  $UserAlgorithm.$declaration,
];

final userAlgorithmBridgeEnums = <BridgeEnumDef>[
  $CompetitionType.$declaration,
  $HillProfileType.$declaration,
  $HillTypeBySize.$declaration,
  $JumpsConsistency.$declaration,
  $JumpsVariability.$declaration,
  $LandingEase.$declaration,
  $LandingStyle.$declaration,
  $Sex.$declaration,
  $TypicalWindDirection.$declaration,
];
