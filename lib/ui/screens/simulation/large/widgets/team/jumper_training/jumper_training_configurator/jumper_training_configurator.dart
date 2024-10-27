import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/bloc/simulation/commands/simulation_flow/training/change_jumping_technique_change_training_command.dart';
import 'package:sj_manager/bloc/simulation/simulation_database_cubit.dart';
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

    return Column(
      children: [
        const Gap(7),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 180,
            child: JumpingTechniqueChangeTrainingDropdown(
              key: UniqueKey(),
              width: 150,
              initial: _jumpingTechniqueChangeTraining,
              onChange: (newJumpingTechniqueChangeTraining) async {
                if (_jumpingTechniqueChangeTraining ==
                    newJumpingTechniqueChangeTraining) {
                  return;
                }
                await ChangeJumpingTechniqueChangeTrainingCommand(
                  context: context,
                  database: database,
                  jumper: widget.jumper,
                  oldTraining: widget.trainingConfig.jumpingTechniqueChangeTraining,
                  newTraining: newJumpingTechniqueChangeTraining,
                  onFinish: (confirmed) {
                    setState(() {
                      if (confirmed) {
                        _jumpingTechniqueChangeTraining =
                            newJumpingTechniqueChangeTraining;
                        print(
                            '_jumpingTechniqueChangeTraining: ${_jumpingTechniqueChangeTraining}');
                        final newConfig = widget.trainingConfig.copyWith(
                          jumpingTechniqueChangeTraining:
                              newJumpingTechniqueChangeTraining,
                        );
                        widget.onChange(newConfig);
                      } else {
                        print('not confirmed. emit ${widget.trainingConfig}');
                        widget.onChange(widget.trainingConfig);
                      }
                    });
                  },
                ).execute();
              },
            ),
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
                    widget.onChange(newConfig);
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
