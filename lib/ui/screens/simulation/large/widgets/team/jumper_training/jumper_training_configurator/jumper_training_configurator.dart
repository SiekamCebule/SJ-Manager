import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/models/simulation/flow/jumper_dynamic_params.dart';
import 'package:sj_manager/models/simulation/flow/reports/jumper_reports.dart';
import 'package:sj_manager/models/simulation/flow/simple_rating.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/ui/reusable_widgets/card_with_title.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/jumper_training/jumper_training_configurator/widgets/jumper_attribute_training_slider.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/jumper_training/training_progress_report_display.dart';
import 'package:sj_manager/ui/screens/simulation/utils/training_translations.dart';
import 'package:sj_manager/utils/training.dart';

part 'widgets/__configuration_component.dart';
part 'widgets/__report_component.dart';
part 'widgets/__effect_on_consistency.dart';

class JumperTrainingConfigurator extends StatefulWidget {
  const JumperTrainingConfigurator({
    super.key,
    required this.jumper,
    required this.trainingConfig,
    required this.dynamicParams,
    required this.onTrainingChange,
    required this.weeklyTrainingReport,
    required this.monthlyTrainingReport,
  });

  final Jumper jumper;
  final JumperTrainingConfig trainingConfig;
  final JumperDynamicParams dynamicParams;
  final Function(JumperTrainingConfig config) onTrainingChange;
  final TrainingReport? weeklyTrainingReport;
  final TrainingReport? monthlyTrainingReport;

  @override
  State<JumperTrainingConfigurator> createState() => _JumperTrainingConfiguratorState();
}

class _JumperTrainingConfiguratorState extends State<JumperTrainingConfigurator> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(10),
          SizedBox(
            height: 380,
            child: Row(
              children: [
                SizedBox(
                  width: 450,
                  height: 380,
                  child: _ConfigurationComponent(
                    trainingConfig: widget.trainingConfig,
                    onTrainingChange: widget.onTrainingChange,
                  ),
                ),
                const Gap(10),
                SizedBox(
                  width: 450,
                  height: 380,
                  child: _ReportComponent(
                    weeklyReport: widget.weeklyTrainingReport,
                    monthlyReport: widget.monthlyTrainingReport,
                  ),
                ),
              ],
            ),
          ),
          const Gap(10),
        ],
      ),
    );
  }
}
