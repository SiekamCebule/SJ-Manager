import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/entities/jumper_training_category.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/reports/jumper_reports.dart';
import 'package:sj_manager/core/career_mode/simple_rating.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/entities/jumper_training_config.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/general_ui/reusable_widgets/card_with_title.dart';
import 'package:sj_manager/features/career_mode/presentation/widgets/jumper_training_configurator/widgets/jumper_attribute_training_slider.dart';
import 'package:sj_manager/features/career_mode/presentation/widgets/jumper_reports/training_progress_report_display.dart';
import 'package:sj_manager/l10n/training_translations.dart';
import 'package:sj_manager/core/career_mode/career_mode_utils/training_utils.dart';

part 'widgets/__configuration_component.dart';
part 'widgets/__report_component.dart';
part 'widgets/__effect_on_consistency.dart';

class JumperTrainingConfigurator extends StatefulWidget {
  const JumperTrainingConfigurator({
    super.key,
    required this.jumper,
    required this.trainingConfig,
    required this.onTrainingChange,
    required this.weeklyTrainingReport,
    required this.monthlyTrainingReport,
  });

  final SimulationJumper jumper;
  final JumperTrainingConfig trainingConfig;
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
