import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:sj_manager/models/db/event_series/classification/classification_scoring_delegate/callback_classification_scoring_delegates.dart';
import 'package:sj_manager/models/db/event_series/classification/classification_scoring_delegate/classification_scoring_delegate.dart';
import 'package:sj_manager/models/db/event_series/event_series.dart';

import 'callback_classification_scoring_delegate_by_event_series_test.mocks.dart';

@GenerateMocks([EventSeries])
void main() {
  group(CallbackClassificationScoringDelegateByEventSeries, () {
    late CallbackClassificationScoringDelegateByEventSeries<double, dynamic>
        delegate; // to initialize in tests

    test('calculateScore() and compute() should return the sanme result', () {
      delegate = CallbackClassificationScoringDelegateByEventSeries(
          compute: (entity, eventSeries) {
        const entityPlaces = [
          12,
          4,
          6,
          7,
          3,
          1,
          1,
          20,
        ];
        const pointsByPlaces = {
          1: 100,
          2: 80,
          3: 70,
          4: 60,
          5: 50,
          6: 40,
          7: 35,
          8: 30,
          9: 25,
          10: 20,
        };
        final sum = entityPlaces.fold(0, (sum, place) {
          return sum + (pointsByPlaces[place] ?? 0);
        });
        return sum.toDouble();
      });
      final computed = delegate.calculateScore(entity: null, input: MockEventSeries());
      const expectedPoints = 405;
      expect(computed, expectedPoints);
    });
  });
}
