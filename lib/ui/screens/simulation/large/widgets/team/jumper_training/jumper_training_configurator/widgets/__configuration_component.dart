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
  late final Map<JumperTrainingCategory, double> _trainingBalances;

  @override
  void initState() {
    _trainingBalances = Map.of(widget.trainingConfig.balance);
    super.initState();
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
          const Gap(30),
          buildSlider(JumperTrainingCategory.takeoff),
          const Gap(30),
          buildSlider(JumperTrainingCategory.flight),
          const Gap(30),
          buildSlider(JumperTrainingCategory.landing),
          const Gap(30),
          buildSlider(JumperTrainingCategory.form),
          const Gap(30),
        ],
      ),
    );
  }
}
