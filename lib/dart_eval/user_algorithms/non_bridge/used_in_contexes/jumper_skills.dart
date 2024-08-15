import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/enums/jumps_consistency.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/enums/landing_style.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/user_db/jumper/jumper_skills.dart';
import 'package:sj_manager/models/user_db/jumper/jumps_consistency.dart';
import 'package:sj_manager/models/user_db/jumper/landing_style.dart';

class $JumperSkills implements JumperSkills, $Instance {
  $JumperSkills.wrap(this.$value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'JumperSkills',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType($type),
    constructors: {
      '': BridgeFunctionDef(
        returns: $type.annotate,
        namedParams: [
          'qualityOnSmallerHills'.param($double.$declaration.type.type.annotate),
          'qualityOnLargerHills'.param($double.$declaration.type.type.annotate),
          'landingStyle'.param($LandingStyle.$declaration.type.annotate),
          'jumpsConsistency'.param($JumpsConsistency.$declaration.type.annotate),
        ],
      ).asConstructor
    },
    fields: {
      'qualityOnSmallerHills': BridgeFieldDef($double.$declaration.type.type.annotate),
      'qualityOnLargerHills': BridgeFieldDef($double.$declaration.type.type.annotate),
      'landingStyle': BridgeFieldDef($LandingStyle.$declaration.type.annotate),
      'jumpsConsistency': BridgeFieldDef($JumpsConsistency.$declaration.type.annotate),
    },
    getters: {
      'props': BridgeFunctionDef(returns: $List.$declaration.type.type.annotate).asMethod,
      'qualityOnSmallerHills':
          BridgeFunctionDef(returns: $double.$declaration.type.type.annotate).asMethod,
      'qualityOnLargerHills':
          BridgeFunctionDef(returns: $double.$declaration.type.type.annotate).asMethod,
      'landingStyle':
          BridgeFunctionDef(returns: $LandingStyle.$declaration.type.annotate).asMethod,
      'jumpsConsistency':
          BridgeFunctionDef(returns: $JumpsConsistency.$declaration.type.annotate)
              .asMethod,
    },
    wrap: true,
  );

  @override
  final JumperSkills $value;

  @override
  JumperSkills get $reified => $value;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'qualityOnSmallerHills':
        return $double($value.qualityOnSmallerHills);
      case 'qualityOnLargerHills':
        return $double($value.qualityOnLargerHills);
      case 'landingStyle':
        return $LandingStyle.wrap($value.landingStyle);
      case 'jumpsConsistency':
        return $JumpsConsistency.wrap($value.jumpsConsistency);
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

  @override
  List<Object?> get props => $value.props;

  @override
  bool? get stringify => $value.stringify;

  @override
  double get qualityOnSmallerHills => $value.qualityOnSmallerHills;

  @override
  double get qualityOnLargerHills => $value.qualityOnLargerHills;

  @override
  LandingStyle get landingStyle => $value.landingStyle;

  @override
  JumpsConsistency get jumpsConsistency => $value.jumpsConsistency;

  @override
  JumperSkills copyWith({
    double? qualityOnSmallerHills,
    double? qualityOnLargerHills,
    LandingStyle? landingStyle,
    JumpsConsistency? jumpsConsistency,
  }) {
    return $value.copyWith(
      qualityOnSmallerHills: qualityOnSmallerHills,
      qualityOnLargerHills: qualityOnLargerHills,
      landingStyle: landingStyle,
      jumpsConsistency: jumpsConsistency,
    );
  }

  @override
  Json toJson() {
    throw UnimplementedError();
  }
}
