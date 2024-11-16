import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/data/models/simulation/jumper/reports/jumper_reports.dart';
import 'package:sj_manager/data/models/simulation/flow/simulation_mode.dart';
import 'package:sj_manager/data/models/simulation/jumper/simulation_jumper.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/help_icon_button.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/sjm_dialog_ok_pop_button.dart';

enum SetUpTrainingsDialogResult {
  goToTrainingView,
  doNothing,
}

class SetUpTrainingsDialog extends StatelessWidget {
  const SetUpTrainingsDialog({
    super.key,
    required this.simulationMode,
    required this.jumpers,
    required this.jumpersSimulationRatings,
    required this.onSubmit,
  });

  final SimulationMode simulationMode;
  final List<SimulationJumper> jumpers;
  final Map<SimulationJumper, JumperReports> jumpersSimulationRatings;
  final Function(SetUpTrainingsDialogResult result) onSubmit;

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
        if (simulationMode == SimulationMode.classicCoach && jumpers.isEmpty) {
          throw StateError(
            'Strange... You have zero jumpers on the classic coach mode',
          );
        }

        final itIsPersonalCoachEmptyState =
            simulationMode == SimulationMode.personalCoach && jumpers.isEmpty;

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
              : Text(
                  '''Właśnie startują przygotowania do następnego sezonu! Do rozgrywek zimowych pozostało jeszcze sporo czasu, ale już teraz musimy zadbać o odpowiedni trening naszych podopiecznych. Nad jakimi elementami treningu się skupisz? Czy zamierzasz przygotować formę pod letnie zawody, a może popracować nad lądowaniem? Może celem jest impreza mistrzowska w zimę? Możesz zmieniać konfigurację treningu w dowolnym momencie.\n\nPowodzenia w nadchodzącym sezonie!
              ''',
                  style: paragraphStyle,
                ),
          actions: [
            if (!itIsPersonalCoachEmptyState)
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  onSubmit(SetUpTrainingsDialogResult.goToTrainingView);
                },
                child: const Text('Ustal trening'),
              ),
            if (itIsPersonalCoachEmptyState)
              SjmDialogOkPopButton(
                customOnPressed: () {
                  Navigator.of(context).pop();
                  onSubmit(SetUpTrainingsDialogResult.doNothing);
                },
              ),
          ],
        );
      },
    );
  }
}
