import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/bloc/simulation/commands/simulation_flow/training/change_jumping_technique_change_training_command.dart';
import 'package:sj_manager/bloc/simulation/simulation_database_cubit.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
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
    final database = context.watch<SimulationDatabaseCubit>().state;
    final translatedPoints =
        pluralForm(count: _availablePoints, one: 'Punkt', few: 'Punkty', many: 'Punktów');

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 220,
              child: JumpingTechniqueChangeTrainingDropdown(
                key: UniqueKey(),
                width: 150,
                initial: widget.trainingConfig.jumpingTechniqueChangeTraining,
                onChange: (newJumpingTechniqueChangeTraining) async {
                  if (widget.trainingConfig.jumpingTechniqueChangeTraining ==
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
                          final newConfig = widget.trainingConfig.copyWith(
                            jumpingTechniqueChangeTraining:
                                newJumpingTechniqueChangeTraining,
                          );
                          widget.onChange(newConfig);
                        } else {
                          widget.onChange(widget.trainingConfig);
                        }
                      });
                    },
                  ).execute();
                },
              ),
            ),
            const Spacer(),
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
        Row(
          children: [
            Text('Utrzymanie'),
            const Gap(5),
            SizedBox(
              height: 50,
              child: Slider(
                value: 0.0,
                min: -1.0,
                max: 1.0,
                secondaryTrackValue: 0.2,
                divisions: 20,
                label: '${(0.2 * 100).toInt()}%',
                onChanged: (value) {},
              ),
            ),
            const Gap(5),
            Text('Zmiana'),
          ],
        ),
      ],
    );
  }
}
