import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:sj_manager/models/simulation_db/competition/competition_type.dart'; // Adjust the import path as necessary

class $CompetitionType implements $Instance {
  $CompetitionType.wrap(this.$value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'CompetitionType',
  ).ref;

  static final $declaration = BridgeEnumDef(
    $type,
    values: [
      'competition',
      'qualifications',
      'trialRound',
      'training',
    ],
  );

  static final $values = {
    'competition': $CompetitionType.wrap(CompetitionType.competition),
    'qualifications': $CompetitionType.wrap(CompetitionType.qualifications),
    'trialRound': $CompetitionType.wrap(CompetitionType.trialRound),
    'training': $CompetitionType.wrap(CompetitionType.training),
  };

  @override
  final CompetitionType $value;

  @override
  CompetitionType get $reified => $value;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'competition':
        return $CompetitionType.wrap(CompetitionType.competition);
      case 'qualifications':
        return $CompetitionType.wrap(CompetitionType.qualifications);
      case 'trialRound':
        return $CompetitionType.wrap(CompetitionType.trialRound);
      case 'training':
        return $CompetitionType.wrap(CompetitionType.training);
      default:
        return null;
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    throw UnimplementedError();
  }
}
