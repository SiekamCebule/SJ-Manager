part of '../jumper_training_configurator.dart';

class _ConfigurationComponent extends StatefulWidget {
  const _ConfigurationComponent({
    required this.trainingConfig,
    required this.onTrainingChange,
  });

  final JumperTrainingConfig trainingConfig;
  final Function(JumperTrainingConfig trainingConfig) onTrainingChange;

  @override
  State<_ConfigurationComponent> createState() => _ConfigurationComponentState();
}

class _ConfigurationComponentState extends State<_ConfigurationComponent> {
  late Map<JumperTrainingCategory, double> _trainingBalances;
  double _effectOnConsistency = 0;

  @override
  void initState() {
    _trainingBalances = Map.of(widget.trainingConfig.balance);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _ConfigurationComponent oldWidget) {
    setState(() {
      _trainingBalances = Map.of(widget.trainingConfig.balance);
      _effectOnConsistency = _calculateEffectOnConsistency();
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Widget buildSlider(JumperTrainingCategory trainingCategory) {
      return JumperAttributeTrainingSlider(
        trainingCategory: trainingCategory,
        balance: _trainingBalances[trainingCategory]!,
        onChange: (balance) {
          setState(() {
            _trainingBalances[trainingCategory] = balance;
            _effectOnConsistency = _calculateEffectOnConsistency();
          });
          widget.onTrainingChange(
              widget.trainingConfig.copyWith(balance: _trainingBalances));
        },
      );
    }

    return CardWithTitle(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      title: Text(
        'Konfiguracja treningu',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      child: Column(
        children: [
          const Gap(20),
          buildSlider(JumperTrainingCategory.takeoff),
          const Gap(20),
          buildSlider(JumperTrainingCategory.flight),
          const Gap(20),
          buildSlider(JumperTrainingCategory.landing),
          const Gap(20),
          buildSlider(JumperTrainingCategory.form),
          const Gap(40),
          _EffectOnConsistency(
            rating: SimpleRating.fromImpactValue(_effectOnConsistency.round()),
          ),
        ],
      ),
    );
  }

  double _calculateEffectOnConsistency() {
    var effect = sjmCalculateAvgTrainingBalance(_trainingBalances);
    effect *= 3.5;
    effect *= -1;
    return effect.clamp(-3, 3);
  }
}
