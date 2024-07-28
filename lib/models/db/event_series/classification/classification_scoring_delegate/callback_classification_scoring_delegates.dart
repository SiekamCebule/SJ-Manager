import 'package:sj_manager/models/db/event_series/classification/classification_scoring_delegate/classification_scoring_delegate.dart';
import 'package:sj_manager/models/db/event_series/event_series.dart';

class CallbackClassificationScoringDelegateByEventSeries<S, T>
    implements ClassificationScoringDelegate<S, T, EventSeries> {
  const CallbackClassificationScoringDelegateByEventSeries({
    required this.compute,
  });

  final S Function(T entity, EventSeries series) compute;

  @override
  S calculateScore({required T entity, required EventSeries input}) {
    return compute(entity, input);
  }
}
