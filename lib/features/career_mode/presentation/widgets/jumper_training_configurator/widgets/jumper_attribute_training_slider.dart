import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/entities/jumper_training_category.dart';

class JumperAttributeTrainingSlider extends StatefulWidget {
  const JumperAttributeTrainingSlider({
    super.key,
    required this.trainingCategory,
    required this.balance,
    required this.onChange,
  });

  final JumperTrainingCategory trainingCategory;
  final double balance;
  final Function(double balance) onChange;

  @override
  State<JumperAttributeTrainingSlider> createState() =>
      _JumperAttributeTrainingSliderState();
}

class _JumperAttributeTrainingSliderState extends State<JumperAttributeTrainingSlider> {
  @override
  Widget build(BuildContext context) {
    String trainingBalanceText(double balance) {
      final trainingBalanceTextLabelNumeralPart = '${(balance * 100).round()}%';
      if (balance < 0) {
        return 'Utrzymanie $trainingBalanceTextLabelNumeralPart';
      } else if (balance > 0) {
        return 'Zmiana $trainingBalanceTextLabelNumeralPart';
      } else {
        return 'Balans 0%';
      }
    }

    final categoryText = switch (widget.trainingCategory) {
      JumperTrainingCategory.takeoff => 'Wybicie',
      JumperTrainingCategory.flight => 'Lot',
      JumperTrainingCategory.landing => 'Lądowanie',
      JumperTrainingCategory.form => 'Forma',
    };

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$categoryText: ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: trainingBalanceText(widget.balance),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            /*HelpIconButton(onPressed: () async {
              await showSimpleHelpDialog(
                context: context,
                title: 'Balans treningu',
                content:
                    'Możesz na bieżąco balansować pomiędzy utrzymaniem obecnego sposobu skakania, a wyjściem poza strefę komfortu i zmianą.\n\nUtrzymanie zwiększa równość skoków w dłuższej perspektywie i nie naraża na gwałtowny spadek umiejętności czy formy. Jednakże, zmniejsza też potencjalny progres.\n\nZmiana daje szansę na poszukanie lepszej dyspozycji czy znaczny wzrost umiejętności w stosunkowo krótszym czasie. Może jednak spowodować kryzys czy zdestabilizować skoki.',
              );
            }),*/
          ],
        ),
        const Gap(2),
        SliderTheme(
          data: Theme.of(context).sliderTheme.copyWith(
                showValueIndicator: ShowValueIndicator.never,
                valueIndicatorTextStyle:
                    Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                overlayShape: SliderComponentShape.noOverlay,
              ),
          child: Slider(
            value: widget.balance,
            min: -1.0,
            max: 1.0,
            divisions: 20,
            secondaryTrackValue: 0.0,
            onChanged: (value) {
              widget.onChange(value);
            },
          ),
        ),
      ],
    );
  }
}
