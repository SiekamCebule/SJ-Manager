import 'package:flutter/material.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/flow/training/jumping_technique_change_training.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/training_engine/components/jumping_technique_change_training_duration_calculator.dart';
import 'package:sj_manager/utils/show_dialog.dart';
import 'package:sj_manager/utils/translating.dart';

class ChangeJumpingTechniqueChangeTrainingCommandResult {
  const ChangeJumpingTechniqueChangeTrainingCommandResult({
    required this.confirmed,
    this.daysLeft,
  });

  final bool confirmed;
  final int? daysLeft;
}

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
  final Function(ChangeJumpingTechniqueChangeTrainingCommandResult result) onFinish;

  Future<void> execute() async {
    if (oldTraining == JumpingTechniqueChangeTrainingType.maintain) {
      final levelOfConsciousness =
          database.jumpersDynamicParameters[jumper]!.levelOfConsciousness;
      final daysLeft = JumpingTechniqueChangeTrainingDurationCalculator().calculateDays(
        trainingType: newTraining,
        levelOfConsciousness: levelOfConsciousness,
      );
      final bool? ok = await showSjmDialog(
        context: context,
        barrierDismissible: true,
        child: _DoYouWannaChangeDialog(
          newTraining: newTraining,
          duration: daysLeft,
        ),
      );
      onFinish(ChangeJumpingTechniqueChangeTrainingCommandResult(
        confirmed: ok ?? false,
        daysLeft: daysLeft,
      ));
    } else {
      final daysLeft = database
          .jumpersDynamicParameters[jumper]!.jumpingTechniqueChangeTrainingDaysLeft;
      if (daysLeft == null) {
        throw StateError(
          'Jumper ($jumper) have trainingConfig.jumpingTechniqueChangeTraining set, but jumpingTechniqueChangeTrainingDaysLeft is null',
        );
      }

      final bool? ok = await showSjmDialog(
        context: context,
        barrierDismissible: true,
        child: _DoYouWannaStopDialog(
          oldTraining: oldTraining,
          daysCount: daysLeft,
        ),
      );
      onFinish(ChangeJumpingTechniqueChangeTrainingCommandResult(
        confirmed: ok ?? false,
        daysLeft: daysLeft,
      ));
    }
  }
}

class _DoYouWannaChangeDialog extends StatelessWidget {
  const _DoYouWannaChangeDialog({
    required this.duration,
    required this.newTraining,
  });

  final int duration;
  final JumpingTechniqueChangeTrainingType newTraining;

  @override
  Widget build(BuildContext context) {
    final regularText = Theme.of(context).textTheme.bodyMedium;
    final boldText = Theme.of(context).textTheme.titleSmall;

    final textWidget = newTraining == JumpingTechniqueChangeTrainingType.increaseRisk
        ? Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      'Czy chcesz zacząć trening polegający na zmianie sposobu skakania? ',
                  style: regularText,
                ),
                TextSpan(
                  text: 'Zajmie to $duration dni. ',
                  style: boldText,
                ),
                TextSpan(
                  text:
                      'Po zakończeniu treningu zawodnik/zawodniczka będzie wkładał(a) więcej ryzyka w swoje skoki - mogą czasem zyskać na "błysku" choć ogólnie będą mniej powtarzalne.',
                  style: regularText,
                ),
              ],
            ),
          )
        : Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      'Czy chcesz zacząć trening polegający na zmianie sposobu skakania? ',
                  style: regularText,
                ),
                TextSpan(
                  text: 'Zajmie to $duration dni. ',
                  style: boldText,
                ),
                TextSpan(
                  text:
                      'Po zakończeniu treningu zawodnik/zawodniczka będzie wkładał(a) mniej ryzyka w swoje skoki - będą one bardziej powtarzalne, ale być może stracą na "błysku".',
                  style: regularText,
                ),
              ],
            ),
          );

    return AlertDialog(
      title: const Text('Zmiana sposobu skakania'),
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
