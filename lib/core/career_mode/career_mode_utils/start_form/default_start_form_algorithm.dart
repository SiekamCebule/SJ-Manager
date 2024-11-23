import 'package:sj_manager/core/career_mode/career_mode_utils/start_form/start_form_algorithm.dart';
import 'package:sj_manager/core/general_utils/random/random.dart';

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
