import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/jumper_training/jumper_training_configurator/jumper_training_points_grid.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/jumper_training/jumper_training_configurator/training_risk_dropdown_menu.dart';
import 'package:sj_manager/utils/translating.dart';

class JumperTrainingConfigurator extends StatefulWidget {
  const JumperTrainingConfigurator({
    super.key,
    required this.jumper,
    required this.trainingConfig,
    required this.onChange,
    required this.managerPointsCount,
  });

  final Jumper jumper;
  final JumperTrainingConfig trainingConfig;
  final Function(JumperTrainingConfig config) onChange;
  final int managerPointsCount;

  @override
  State<JumperTrainingConfigurator> createState() => _JumperTrainingConfiguratorState();
}

class _JumperTrainingConfiguratorState extends State<JumperTrainingConfigurator> {
  var _availablePoints = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final usedPoints = widget.trainingConfig.points.values.reduce(
        (value, element) => value + element,
      );
      setState(() {
        _availablePoints = widget.managerPointsCount - usedPoints;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final translatedPoints =
        pluralForm(count: _availablePoints, one: 'Punkt', few: 'Punkty', many: 'Punktów');

    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: TrainingRiskDropdownMenu(
                initial: widget.trainingConfig.trainingRisk,
                onChange: (trainingRisk) {
                  final newConfig = widget.trainingConfig.copyWith(
                    trainingRisk: trainingRisk,
                  );
                  widget.onChange(newConfig);
                },
              ),
            ),
            const Gap(20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
            const Gap(20),
          ],
        ),
        const Gap(10),
        Expanded(
          child: JumperTrainingPointsGrid(
            initialPoints: widget.trainingConfig.points,
            maxPointsToUse: widget.managerPointsCount,
            length: 15,
            onChange: (points) {
              final usedPoints = points.values.reduce((first, second) => first + second);
              setState(() {
                _availablePoints = widget.managerPointsCount - usedPoints;
              });
              final newConfig = widget.trainingConfig.copyWith(
                points: points,
              );
              widget.onChange(newConfig);
            },
          ),
        ),
      ],
    );
  }
}
