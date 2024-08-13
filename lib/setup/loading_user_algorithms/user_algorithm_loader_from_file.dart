import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
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
  Future<T> load(String source) async {
    final compiler = Compiler();
    compiler.defineBridgeClasses(userAlgorithmBridgeClasses);
    final program = compiler.compile({
      'sj_manager': {
        'main.dart': source,
      }
    });
    final runtime = Runtime.ofProgram(program);
    // TODO: registerBridgeFunc

    final userAlgorithm = runtime.executeLib(
      'package:sj_manager/main.dart',
      'create',
      [],
    );

    if (userAlgorithm is T) {
      return userAlgorithm;
    } else {
      throw NonMatchingUserAlgorithmTypeException(
        current: userAlgorithm.runtimeType,
        expected: T,
      );
    }
  }
}

// TODO: dd
final userAlgorithmBridgeClasses = <BridgeClassDef>[];
