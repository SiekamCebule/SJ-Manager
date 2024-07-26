import 'package:sj_manager/models/db/event_series/event_series.dart';

abstract interface class ClassificationScoringDelegate<T, I> {
  const ClassificationScoringDelegate();

  double calculateScore({required T entity, required I input});
}

class CallbackClassificationScoringDelegateByEventSeries<T>
    implements ClassificationScoringDelegate<T, EventSeries> {
  const CallbackClassificationScoringDelegateByEventSeries({
    required this.compute,
  });

  final double Function({required T entity, required EventSeries series}) compute;

  @override
  double calculateScore({required T entity, required EventSeries input}) {
    return compute(entity: entity, series: input);
  }
}
