import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/commands/simulation/simulation_flow/training/change_jumping_technique_change_training_command.dart';
import 'package:sj_manager/commands/simulation/common/simulation_database_cubit.dart';
import 'package:sj_manager/models/simulation/flow/dynamic_params/jumper_dynamic_params.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/models/simulation/flow/training/jumping_technique_change_training.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/ui/dialogs/simple_help_dialog.dart';
import 'package:sj_manager/ui/reusable_widgets/help_icon_button.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/jumper_training/jumper_training_configurator/jumper_training_points_grid.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/jumper_training/jumper_training_configurator/jumping_technique_change_training_dropdown.dart';
import 'package:sj_manager/utils/translating.dart';

class JumperTrainingConfigurator extends StatefulWidget {
  const JumperTrainingConfigurator({
    super.key,
    required this.jumper,
    required this.trainingConfig,
    required this.dynamicParams,
    required this.onTrainingChange,
    required this.managerPointsCount,
  });

  final Jumper jumper;
  final JumperTrainingConfig trainingConfig;
  final JumperDynamicParams dynamicParams;
  final Function(JumperTrainingConfig config) onTrainingChange;
  final int managerPointsCount;

  @override
  State<JumperTrainingConfigurator> createState() => _JumperTrainingConfiguratorState();
}

class _JumperTrainingConfiguratorState extends State<JumperTrainingConfigurator> {
  var _availablePoints = 0;
  var _trainingBalance = 0.0;
  var _jumpingTechniqueChangeTraining = JumpingTechniqueChangeTrainingType.maintain;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final usedPoints = widget.trainingConfig.points.values.reduce(
        (value, element) => value + element,
      );
      setState(() {
        _availablePoints = widget.managerPointsCount - usedPoints;
        _jumpingTechniqueChangeTraining =
            widget.trainingConfig.jumpingTechniqueChangeTraining;
        _trainingBalance = widget.trainingConfig.balance;
      });
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant JumperTrainingConfigurator oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _jumpingTechniqueChangeTraining =
            widget.trainingConfig.jumpingTechniqueChangeTraining;
      });
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    print('TRAINING CONFIG IN CONFIGURATOR: ${widget.trainingConfig}');

    final database = context.watch<SimulationDatabaseCubit>().state;
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

    final subjectiveTrainingEfficiencyLabelText =
        widget.dynamicParams.subjectiveTrainingEfficiency != null
            ? '${(widget.dynamicParams.subjectiveTrainingEfficiency! * 100).round()}%'
            : '?';

    return Column(
      children: [
        const Gap(7),
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            children: [
              Text(
                subjectiveTrainingEfficiencyLabelText,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                'Efektywność',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const Gap(20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
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
            const Gap(5),
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
    );
  }
}
