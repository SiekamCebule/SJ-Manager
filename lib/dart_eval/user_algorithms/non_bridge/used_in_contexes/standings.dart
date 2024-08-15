import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/score.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/value_repo.dart';
import 'package:sj_manager/models/simulation_db/standings/score/score.dart';
import 'package:sj_manager/models/simulation_db/standings/standings.dart';
import 'package:sj_manager/models/simulation_db/standings/standings_positions_map_creator/standings_positions_creator.dart';

class $Standings<E> implements Standings<E>, $Instance {
  $Standings.wrap(this.$value) : _superclass = $Object($value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'Standings',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType(
      $type,
      generics: {
        'E': const BridgeGenericParam(),
      },
      $implements: [$ValueRepo.$type],
    ),
    getters: {
      'length': BridgeFunctionDef(returns: $int.$declaration.type.type.annotate).asMethod,
      'lastPosition':
          BridgeFunctionDef(returns: $int.$declaration.type.type.annotate).asMethod,
      'items':
          BridgeFunctionDef(returns: $Object.$declaration.type.type.annotate).asMethod,
      'last': BridgeFunctionDef(returns: $Map.$declaration.type.type.annotate).asMethod,
      'scores':
          BridgeFunctionDef(returns: $List.$declaration.type.type.annotate).asMethod,
      'leaders':
          BridgeFunctionDef(returns: $List.$declaration.type.type.annotate).asMethod,
    },
    constructors: {
      '': BridgeFunctionDef(
        returns: $type.annotate,
        namedParams: [
          'positionsCreator'.param($Object
              .$declaration.type.type.annotate), // TODO: Maybe change the type there
          'initialScores'.paramOptional($Map.$declaration.type.type.annotate),
        ],
      ).asConstructor
    },
    fields: {
      // 'positionsCreator':
      //    BridgeFieldDef($StandingsPositionsCreator.$declaration.type.type.annotate),
    },
    methods: {
      'addScore': BridgeFunctionDef(returns: $voidCls.type.type.annotate).asMethod,
      'remove': BridgeFunctionDef(returns: $voidCls.type.type.annotate).asMethod,
      'update': BridgeFunctionDef(returns: $voidCls.type.type.annotate).asMethod,
      'atPosition':
          BridgeFunctionDef(returns: $List.$declaration.type.type.annotate).asMethod,
      'positionOf':
          BridgeFunctionDef(returns: $int.$declaration.type.type.annotate).asMethod,
      'scoreOf':
          BridgeFunctionDef(returns: $Score.$declaration.type.type.annotate).asMethod,
      'containsEntity':
          BridgeFunctionDef(returns: $bool.$declaration.type.type.annotate).asMethod,
      'set': BridgeFunctionDef(returns: $voidCls.type.type.annotate).asMethod,
      'dispose': BridgeFunctionDef(returns: $voidCls.type.type.annotate).asMethod,
    },
    wrap: true,
  );

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $Standings.wrap(
      Standings(
        positionsCreator: args[0]!.$value,
        initialScores: args.length > 1 ? args[1]!.$value : null,
      ),
    );
  }

  @override
  final Standings<E> $value;

  @override
  Standings<E> get $reified => $value;

  final $Instance _superclass;

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'length':
        return $int($value.length);
      case 'lastPosition':
        return $int($value.lastPosition);
      case 'last':
        return $Map.wrap($value.last);
      case 'scores':
        return $List.wrap($value.scores);
      case 'positionsCreator':
        throw UnimplementedError();
      case 'items':
        throw UnimplementedError();
      case 'leaders':
        return $List.wrap($value.leaders);
      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  void addScore({required Score<E> newScore, bool overwrite = false}) =>
      $value.addScore(newScore: newScore, overwrite: overwrite);

  @override
  void remove({required Score<E> score}) => $value.remove(score: score);

  @override
  void update() => $value.update();

  @override
  List<Score<E>> atPosition(int position) => $value.atPosition(position);

  @override
  int positionOf(E entity) => $value.positionOf(entity);

  @override
  Score<E> scoreOf(E entity) => $value.scoreOf(entity);

  @override
  bool containsEntity(E entity) => $value.containsEntity(entity);

  @override
  void set(Map<int, List<Score<E>>> value) => $value.set(value);

  @override
  void dispose() => $value.dispose();

  @override
  ValueStream<Map<int, List<Score<E>>>> get items => $value.items;

  @override
  Map<int, List<Score<E>>> get last => $value.last;

  @override
  int get lastPosition => $value.lastPosition;

  @override
  int get length => $value.length;

  @override
  StandingsPositionsCreator<Score<E>> get positionsCreator => $value.positionsCreator;

  @override
  List<Score<E>> get scores => $value.scores;

  @override
  List<Score<E>> get leaders => $value.leaders;

  @override
  set positionsCreator(StandingsPositionsCreator<Score<E>> positionsCreator) {
    throw UnimplementedError();
  }
}
