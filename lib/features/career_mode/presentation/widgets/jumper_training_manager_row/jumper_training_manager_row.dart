import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/features/career_mode/presentation/bloc/to_consider/jumpers_cubit.dart';
import 'package:sj_manager/features/career_mode/presentation/bloc/trainee_training_cubit.dart';
import 'package:sj_manager/features/career_mode/presentation/widgets/jumper/jumper_simple_list_tile.dart';
import 'package:sj_manager/features/career_mode/presentation/widgets/jumper_training_configurator/jumper_training_configurator.dart';

class JumperTrainingManagerRow extends StatefulWidget {
  const JumperTrainingManagerRow({
    super.key,
    required this.noJumpersWidget,
  });

  final Widget noJumpersWidget;

  @override
  State<JumperTrainingManagerRow> createState() => _JumperTrainingManagerRowState();
}

class _JumperTrainingManagerRowState extends State<JumperTrainingManagerRow> {
  @override
  Widget build(BuildContext context) {
    final jumpersState = context.watch<JumpersCubit>().state as JumpersDefault;
    final traineeTrainingState = context.watch<TraineeTrainingCubit>().state;
    final selectedTrainee = traineeTrainingState is TraineeTrainingChosen
        ? traineeTrainingState.trainee
        : null;

    return jumpersState.jumpers.isNotEmpty
        ? Row(
            children: [
              SizedBox(
                width: 400,
                child: Card(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  child: ListView.builder(
                    itemCount: jumpersState.jumpers.length,
                    itemBuilder: (context, index) {
                      final jumper = jumpersState.jumpers.elementAt(index);
                      return JumperSimpleListTile(
                        jumper: jumper,
                        subtitle: JumperSimpleListTileSubtitle.levelDescription,
                        levelDescription: jumper.reports.levelReport?.levelDescription,
                        selected: selectedTrainee == jumper,
                        leading: JumperSimpleListTileLeading.jumperImage,
                        trailing: JumperSimpleListTileTrailing.countryFlag,
                        onTap: () async {
                          await context.read<TraineeTrainingCubit>().select(jumper);
                        },
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  child: selectedTrainee != null
                      ? JumperTrainingConfigurator(
                          jumper: selectedTrainee,
                          trainingConfig: selectedTrainee.trainingConfig!,
                          onTrainingChange: (trainingConfig) async {
                            await context
                                .read<TraineeTrainingCubit>()
                                .setTrainingConfig(trainingConfig: trainingConfig);
                          },
                          weeklyTrainingReport:
                              selectedTrainee.reports.weeklyTrainingReport,
                          monthlyTrainingReport:
                              selectedTrainee.reports.monthlyTrainingReport,
                        )
                      : Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Aby zarządzać treningiem, zaznacz zawodnika/zawodniczkę po lewej stronie',
                                style: Theme.of(context).textTheme.bodyMedium,
                              )
                            ],
                          ),
                        ),
                ),
              ),
            ],
          )
        : widget.noJumpersWidget;
  }
}
