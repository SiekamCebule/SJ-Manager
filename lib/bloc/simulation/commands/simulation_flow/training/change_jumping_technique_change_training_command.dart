import 'package:flutter/material.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/flow/training/jumping_technique_change_training.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/utils/show_dialog.dart';
import 'package:sj_manager/utils/translating.dart';

class ChangeJumpingTechniqueChangeTrainingCommand {
  ChangeJumpingTechniqueChangeTrainingCommand({
    required this.context,
    required this.database,
    required this.jumper,
    required this.oldTraining,
    required this.newTraining,
    required this.onFinish,
  });

  final BuildContext context;
  final SimulationDatabase database;
  final Jumper jumper;
  final JumpingTechniqueChangeTrainingType oldTraining;
  final JumpingTechniqueChangeTrainingType newTraining;
  final Function(bool confirmed) onFinish;

  Future<void> execute() async {
    print('Change jumping technique training. Old: $oldTraining. New: $newTraining');
    if (oldTraining == JumpingTechniqueChangeTrainingType.maintain) {
      final bool? ok = await showSjmDialog(
        context: context,
        barrierDismissible: true,
        child: _DoYouWannaChangeDialog(
          newTraining: newTraining,
        ),
      );
      onFinish(ok ?? false);
    } else {
      final daysLeft = database
          .jumpersDynamicParameters[jumper]!.jumpingTechniqueChangeTrainingDaysLeft;

      final bool? ok = await showSjmDialog(
        context: context,
        barrierDismissible: true,
        child: _DoYouWannaStopDialog(
          oldTraining: oldTraining,
          daysCount: daysLeft ?? 5, // TODO days left
        ),
      );
      onFinish(ok ?? false);
    }
  }
}

class _DoYouWannaChangeDialog extends StatelessWidget {
  const _DoYouWannaChangeDialog({
    required this.newTraining,
  });

  final JumpingTechniqueChangeTrainingType newTraining;

  @override
  Widget build(BuildContext context) {
    final contentText = newTraining == JumpingTechniqueChangeTrainingType.increaseRisk
        ? 'Czy chcesz zacząć trening polegający na zmianie sposobu skakania? Zajmie to trochę czasu. Po zakończeniu treningu zawodnik/zawodniczka będzie wkładał(a) więcej ryzyka w swoje skoki - mogą czasem zyskać na "błysku" choć ogólnie będą mniej powtarzalne'
        : 'Czy chcesz zacząć trening polegający na zmianie sposobu skakania? Zajmie to trochę czasu. Po zakończeniu treningu zawodnik/zawodniczka będzie wkładał(a) mniej ryzyka w swoje skoki - będą one bardziej powtarzalne, ale być może stracą na "błysku"';

    return AlertDialog(
      title: const Text('Zmiana sposobu skakania'),
      content: Text(contentText),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Nie'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('Tak'),
        ),
      ],
    );
  }
}

class _DoYouWannaStopDialog extends StatelessWidget {
  const _DoYouWannaStopDialog({
    required this.oldTraining,
    required this.daysCount,
  });

  final JumpingTechniqueChangeTrainingType oldTraining;
  final int daysCount;

  @override
  Widget build(BuildContext context) {
    final regularText = Theme.of(context).textTheme.bodyMedium;
    final boldText = Theme.of(context).textTheme.titleSmall;
    final textWidget = oldTraining == JumpingTechniqueChangeTrainingType.increaseRisk
        ? Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      'Czy chcesz zaprzestać zmiany sposobu skakania? Zawodnik/zawodniczka pracował(a) nad bardziej ryzykowną (mniej powtarzalną) techniką skoku\nTrening kończy się ',
                  style: regularText,
                ),
                TextSpan(
                  text: sjmFutureDaysDescription(context: context, days: daysCount)
                      .toLowerCase(),
                  style: boldText,
                ),
              ],
            ),
          )
        : Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      'Czy chcesz zaprzestać zmiany sposobu skakania? Zawodnik/zawodniczka pracował(a) nad mniej ryzykowną (bardziej powtarzalną) techniką skoku\nTrening kończy się ',
                  style: regularText,
                ),
                TextSpan(
                  text: sjmFutureDaysDescription(context: context, days: daysCount)
                      .toLowerCase(),
                  style: boldText,
                ),
              ],
            ),
          );

    return AlertDialog(
      title: const Text('Zakończenie zmiany sposobu skakania'),
      content: textWidget,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Nie'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('Tak'),
        ),
      ],
    );
  }
}
