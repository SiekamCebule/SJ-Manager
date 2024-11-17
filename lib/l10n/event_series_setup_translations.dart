import 'package:flutter/widgets.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/domain/entities/simulation/event_series/event_series_setup.dart';

String translatedRelativeMoneyPrize(
    BuildContext context, EventSeriesRelativeMoneyPrize prize) {
  return switch (prize) {
    EventSeriesRelativeMoneyPrize.veryLow => translate(context).veryLowPrize,
    EventSeriesRelativeMoneyPrize.low => translate(context).lowPrize,
    EventSeriesRelativeMoneyPrize.average => translate(context).averagePrize,
    EventSeriesRelativeMoneyPrize.high => translate(context).highPrize,
    EventSeriesRelativeMoneyPrize.veryHigh => translate(context).veryHighPrize,
  };
}
