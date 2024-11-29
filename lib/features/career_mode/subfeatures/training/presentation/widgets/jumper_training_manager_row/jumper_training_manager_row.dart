import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/features/career_mode/subfeatures/jumpers/presentation/bloc/simulation_jumpers_cubit.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/presentation/bloc/jumper_training_cubit.dart';
import 'package:sj_manager/features/career_mode/ui/reusable/jumper/jumper_simple_list_tile.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/presentation/widgets/jumper_training_configurator/jumper_training_configurator.dart';

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
    final jumpersState = context.watch<SimulationJumpersCubit>().state;
    final jumpers = (jumpersState as SimulationJumpersDefault).jumpers;
    final trainingState = context.watch<JumperTrainingCubit>().state;
    final selectedJumper =
        trainingState is JumperTrainingInitialized ? trainingState.jumper : null;

    return jumpers.isNotEmpty
        ? Row(
            children: [
              SizedBox(
                width: 400,
                child: Card(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  child: ListView.builder(
                    itemCount: jumpers.length,
                    itemBuilder: (context, index) {
                      final jumper = jumpers.elementAt(index);
                      return JumperSimpleListTile(
                        jumper: jumper,
                        subtitle: JumperSimpleListTileSubtitle.levelDescription,
                        levelDescription: jumper.reports.levelReport?.levelDescription,
                        selected: selectedJumper == jumper,
                        leading: JumperSimpleListTileLeading.jumperImage,
                        trailing: JumperSimpleListTileTrailing.countryFlag,
                        onTap: () async {
                          await context.read<JumperTrainingCubit>().toggleJumper(jumper);
                        },
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  child: selectedJumper != null
                      ? JumperTrainingConfigurator(
                          jumper: selectedJumper,
                          trainingConfig: selectedJumper.trainingConfig!,
                          onTrainingChange: (trainingConfig) async {
                            await context
                                .read<JumperTrainingCubit>()
                                .changeTrainingConfig(trainingConfig);
                          },
                          weeklyTrainingReport:
                              selectedJumper.reports.weeklyTrainingReport,
                          monthlyTrainingReport:
                              selectedJumper.reports.monthlyTrainingReport,
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
