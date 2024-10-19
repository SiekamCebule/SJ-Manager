import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/models/simulation/flow/reports/jumper_reports.dart';
import 'package:sj_manager/models/simulation/flow/simulation_mode.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/models/simulation/flow/training/training_risk.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/ui/reusable_widgets/help_icon_button.dart';
import 'package:sj_manager/ui/reusable_widgets/sjm_dialog_ok_pop_button.dart';
import 'package:sj_manager/ui/screens/simulation/large/dialogs/set_up_trainings/set_up_trainings_are_you_sure_dialog.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/jumper_in_team_card/jumper_in_team_training_card.dart';
import 'package:sj_manager/utils/show_dialog.dart';

class SetUpTrainingsDialog extends StatefulWidget {
  const SetUpTrainingsDialog({
    super.key,
    required this.simulationMode,
    required this.jumpers,
    required this.jumpersSimulationRatings,
    required this.managerPointsCount,
    required this.onSubmit,
  });

  final SimulationMode simulationMode;
  final List<Jumper> jumpers;
  final Map<Jumper, JumperReports> jumpersSimulationRatings;
  final int managerPointsCount;
  final Function(Map<Jumper, JumperTrainingConfig> trainingConfigs) onSubmit;

  @override
  State<SetUpTrainingsDialog> createState() => _SetUpTrainingsDialogState();
}

class _SetUpTrainingsDialogState extends State<SetUpTrainingsDialog> {
  late Map<Jumper, JumperTrainingConfig> _trainingConfigs;

  @override
  void initState() {
    _trainingConfigs = {
      for (var jumper in widget.jumpers)
        jumper: const JumperTrainingConfig(
          trainingRisk: TrainingRisk.balanced,
          points: initialJumperTrainingPoints,
        ),
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final paragraphStyle = Theme.of(context).textTheme.bodyMedium!;

    final title = SizedBox(
      width: 200,
      child: Row(
        children: [
          const Text('Rozpoczynają się treningi'),
          const Gap(5),
          HelpIconButton(
            onPressed: () {},
          ),
        ],
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (widget.simulationMode == SimulationMode.classicCoach &&
            widget.jumpers.isEmpty) {
          throw StateError(
            'Strange... You have zero jumpers on the classic coach mode',
          );
        }

        final itIsPersonalCoachEmptyState =
            widget.simulationMode == SimulationMode.personalCoach &&
                widget.jumpers.isEmpty;

        return AlertDialog(
          scrollable: true,
          title: title,
          content: itIsPersonalCoachEmptyState
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 350),
                      child: Text(
                        'Póki co nikogo nie trenujesz, ale kiedy zaczniesz - pamiętaj o ustaleniu odpowiedniego planu treningowego :)',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Text(
                      '''Właśnie startują przygotowania do następnego sezonu! Do rozgrywek zimowych pozostało jeszcze sporo czasu, ale już teraz musimy zadbać o odpowiedni trening naszych podopiecznych. Nad jakimi elementami treningu się skupisz? Czy zamierzasz przygotować formę pod letnie zawody, a może popracować nad lądowaniem? Może celem jest impreza mistrzowska w zimę? Możesz zmieniać konfigurację treningu w dowolnym momencie.\n\nPowodzenia w nadchodzącym sezonie!
              ''',
                      style: paragraphStyle,
                    ),
                    SizedBox(
                      height: 300,
                      width: constraints.maxWidth,
                      child: ListView(
                        children: [
                          for (var jumper in widget.jumpers)
                            JumperInTeamTrainingCard(
                              jumper: jumper,
                              trainingConfig: _trainingConfigs[jumper]!,
                              onTrainingChange: (trainingConfig) {
                                setState(() {
                                  _trainingConfigs[jumper] = trainingConfig;
                                });
                              },
                              jumperRatings: widget.jumpersSimulationRatings[jumper]!,
                              managerPointsCount: widget.managerPointsCount,
                              hideTrainingRaport: true,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
          actions: [
            if (!itIsPersonalCoachEmptyState)
              TextButton(
                onPressed: () async {
                  bool? shouldClose = await showSjmDialog<bool>(
                    barrierDismissible: true,
                    context: context,
                    child: const SetUpTrainingsAreYouSureDialog(),
                  );
                  if (shouldClose == true) {
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                    widget.onSubmit(_trainingConfigs);
                  }
                },
                child: const Text('Zatwierdź'),
              ),
            if (itIsPersonalCoachEmptyState) const SjmDialogOkPopButton(),
          ],
        );
      },
    );
  }
}
