part of '../jumper_training_configurator.dart';

class _ConfigurationComponent extends StatefulWidget {
  const _ConfigurationComponent({
    required this.managerPointsCount,
    required this.trainingConfig,
    required this.onTrainingChange,
  });

  final int managerPointsCount;
  final JumperTrainingConfig trainingConfig;
  final Function(JumperTrainingConfig trainingConfig) onTrainingChange;

  @override
  State<_ConfigurationComponent> createState() => _ConfigurationComponentState();
}

class _ConfigurationComponentState extends State<_ConfigurationComponent> {
  var _availablePoints = 0;
  var _trainingBalance = 0.0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final usedPoints = widget.trainingConfig.points.values.reduce(
        (value, element) => value + element,
      );
      setState(() {
        _availablePoints = widget.managerPointsCount - usedPoints;
        _trainingBalance = widget.trainingConfig.balance;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final translatedPoints =
        pluralForm(count: _availablePoints, one: 'Punkt', few: 'Punkty', many: 'Punktów');

    final trainingBalanceTextLabelNumeralPart = '${(_trainingBalance * 100).round()}%';
    String trainingBalanceLabelText;
    if (_trainingBalance < 0) {
      trainingBalanceLabelText = 'Utrzymanie $trainingBalanceTextLabelNumeralPart';
    } else if (_trainingBalance > 0) {
      trainingBalanceLabelText = 'Zmiana $trainingBalanceTextLabelNumeralPart';
    } else {
      trainingBalanceLabelText = 'Balans 0%';
    }

    return CardWithTitle(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      title: Text(
        'Konfiguracja treningu',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      child: Column(
        children: [
          const Gap(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IntrinsicWidth(
                child: IntrinsicHeight(
                  child: JumperTrainingPointsGrid(
                    initialPoints: widget.trainingConfig.points,
                    maxPointsToUse: widget.managerPointsCount,
                    length: 15,
                    onChange: (points) {
                      final usedPoints =
                          points.values.reduce((first, second) => first + second);
                      setState(() {
                        _availablePoints = widget.managerPointsCount - usedPoints;
                      });
                      final newConfig = widget.trainingConfig.copyWith(
                        points: points,
                      );
                      widget.onTrainingChange(newConfig);
                    },
                  ),
                ),
              ),
              const Gap(20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _availablePoints.toString(),
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text(
                    translatedPoints,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
          const Gap(20),
          SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Balans treningu: ',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text: trainingBalanceLabelText,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                    HelpIconButton(onPressed: () async {
                      await showSimpleHelpDialog(
                        context: context,
                        title: 'Balans treningu',
                        content:
                            'Możesz na bieżąco balansować pomiędzy utrzymaniem obecnego sposobu skakania, a wyjściem poza strefę komfortu i zmianą.\n\nUtrzymanie zwiększa równość skoków w dłuższej perspektywie i nie naraża na gwałtowny spadek umiejętności czy formy. Jednakże, zmniejsza też potencjalny progres.\n\nZmiana daje szansę na poszukanie lepszej dyspozycji czy znaczny wzrost umiejętności w stosunkowo krótszym czasie. Może jednak spowodować kryzys czy zdestabilizować skoki.',
                      );
                    }),
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
                    value: _trainingBalance,
                    min: -1.0,
                    max: 1.0,
                    divisions: 20,
                    secondaryTrackValue: 0.0,
                    onChanged: (value) {
                      setState(() {
                        _trainingBalance = value;
                        final newConfig =
                            widget.trainingConfig.copyWith(balance: _trainingBalance);
                        widget.onTrainingChange(newConfig);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
