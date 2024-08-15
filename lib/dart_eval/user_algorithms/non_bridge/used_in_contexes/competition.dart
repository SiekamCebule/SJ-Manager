import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/competition_rules_provider.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/equatable_mixin.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/hill.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/standings.dart';
import 'package:sj_manager/models/simulation_db/competition/competition.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules_provider.dart';
import 'package:sj_manager/models/simulation_db/standings/standings.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';

class $Competition<E> implements Competition<E>, $Instance {
  $Competition.wrap(this.$value) : _superclass = $Object($value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'Competition',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType(
      $type,
      generics: {
        'E': const BridgeGenericParam(),
      },
      $with: [$EquatableMixin.$type],
    ),
    getters: {
      'props': BridgeFunctionDef(returns: $List.$declaration.type.type.annotate).asMethod,
      'stringify':
          BridgeFunctionDef(returns: $bool.$declaration.type.type.annotate).asMethod
    },
    constructors: {
      '': BridgeFunctionDef(
        returns: $type.annotate,
        namedParams: [
          'hill'.param($Hill.$declaration.type.type.annotate),
          'date'.param($DateTime.$declaration.type.type.annotate),
          'rules'.param($CompetitionRulesProvider.$declaration.type.type.annotate),
          'standings'.param($Standings.$declaration.type.type.annotate),
          'labels'.param($List.$declaration.type.type.annotate), // TODO: Maybe Set??
        ],
      ).asConstructor
    },
    fields: {
      'hill': BridgeFieldDef($Hill.$declaration.type.type.annotate),
      'date': BridgeFieldDef($DateTime.$declaration.type.type.annotate),
      'rules': BridgeFieldDef($CompetitionRulesProvider.$declaration.type.type.annotate),
      'standings': BridgeFieldDef($Standings.$declaration.type.type.annotate),
      'labels': BridgeFieldDef($List.$declaration.type.type.annotate),
    },
    wrap: true,
  );

  @override
  final Competition $value;

  @override
  Competition get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'props':
        return $List.wrap($value.props);
      case 'stringify':
        return $bool($value.stringify ?? false);
      case 'hill':
        return $Hill.wrap($value.hill);
      case 'date':
        return $DateTime.wrap($value.date);
      case 'rules':
        return $CompetitionRulesProvider.wrap($value.rules);
      case 'standings':
        return $value.standings != null
            ? $Standings.wrap($value.standings!)
            : const $null();
      case 'labels':
        return $List.wrap($value.labels);
      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $Competition.wrap(
      Competition(
        hill: args[0]!.$value,
        date: args[1]!.$value,
        rules: args[2]!.$value,
        standings: args[3]!.$value,
        labels: args[4]!.$value,
      ),
    );
  }

  @override
  List<Object?> get props => $value.props;

  @override
  bool? get stringify => $value.stringify;

  @override
  Competition<E> copyWith(
      {Hill? hill,
      DateTime? date,
      CompetitionRules<E>? rules,
      Standings<E>? standings,
      List<Object>? labels}) {
    throw UnimplementedError();
  }

  @override
  DateTime get date => $DateTime.wrap($value.date);

  @override
  Hill get hill => $Hill.wrap($value.hill);

  @override
  List<Object> get labels => $List.wrap($value.labels);

  @override
  CompetitionRulesProvider<E> get rules => $CompetitionRulesProvider.wrap($value.rules);

  @override
  Standings<E>? get standings => $value.standings != null
      ? $Standings<E>.wrap($value.standings as Standings<E>)
      : null;
}
