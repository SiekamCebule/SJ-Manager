import 'package:sj_manager/algorithms/start_form/start_form_algorithm.dart';
import 'package:sj_manager/utils/random/random.dart';

class DefaultStartFormAlgorithm implements StartFormAlgorithm {
  const DefaultStartFormAlgorithm({
    required this.baseForm,
  });

  /// Forma po zakończeniu poprzedniego sezonu
  final double baseForm;

  @override
  double computeStartForm() {
    final random = normalDistributionRandom(
      (baseForm - 10) / 1.75,
      2,
    );
    var startForm = 6 + random;
    return startForm;
  }
}
