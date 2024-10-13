import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/models/simulation/database/helper/simulation_database_helper.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/simulation_jumper_image.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/jumper_in_team_card/jumper_card_name_and_surname_column.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/jumper_training/jumper_training_configurator/jumper_training_configurator.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/jumper_training/training_progress_report_display.dart';

class JumperInTeamTrainingCard extends StatelessWidget {
  const JumperInTeamTrainingCard({
    super.key,
    required this.jumper,
    required this.trainingConfig,
    required this.onTrainingChange,
    required this.jumperRatings,
    required this.managerPointsCount,
    this.hideTrainingRaport = false,
  });

  final Jumper jumper;
  final JumperTrainingConfig trainingConfig;
  final Function(JumperTrainingConfig trainingConfig) onTrainingChange;
  final JumperSimulationRatings jumperRatings;
  final int managerPointsCount;
  final bool hideTrainingRaport;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Card(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        child: Row(
          children: [
            const Gap(15),
            SizedBox(
              width: 90,
              child: SimulationJumperImage(jumper: jumper),
            ),
            const Gap(15),
            Expanded(
              child: Row(
                children: [
                  LayoutBuilder(builder: (context, constraints) {
                    return JumperCardNameAndSurnameColumn(
                      jumper: jumper,
                      jumperRatings: jumperRatings,
                    );
                  }),
                  const Gap(30),
                  if (!hideTrainingRaport) ...[
                    SizedBox(
                      width: 260,
                      child: TrainingProgressReportDisplay(
                        report: jumperRatings.trainingProgressReport,
                      ),
                    ),
                    const Gap(60),
                  ],
                  SizedBox(
                    width: 345,
                    child: JumperTrainingConfigurator(
                      jumper: jumper,
                      trainingConfig: trainingConfig,
                      onChange: onTrainingChange,
                      managerPointsCount: managerPointsCount,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
