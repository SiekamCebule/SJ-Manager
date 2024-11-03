import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/models/simulation/flow/dynamic_params/jumper_dynamic_params.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/ui/reusable_widgets/card_with_title.dart';
import 'package:sj_manager/ui/reusable_widgets/help_icon_button.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/jumper_training/jumper_training_configurator/widgets/jumper_attribute_training_slider.dart';

part 'widgets/__configuration_component.dart';
part 'widgets/__subjective_training_efficiency_component.dart';

class JumperTrainingConfigurator extends StatefulWidget {
  const JumperTrainingConfigurator({
    super.key,
    required this.jumper,
    required this.trainingConfig,
    required this.dynamicParams,
    required this.onTrainingChange,
    required this.managerPointsCount,
  });

  final Jumper jumper;
  final JumperTrainingConfig trainingConfig;
  final JumperDynamicParams dynamicParams;
  final Function(JumperTrainingConfig config) onTrainingChange;
  final int managerPointsCount;

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
            width: 450,
            height: 420,
            child: _ConfigurationComponent(
              managerPointsCount: widget.managerPointsCount,
              trainingConfig: widget.trainingConfig,
              onTrainingChange: widget.onTrainingChange,
            ),
          ),
          const Gap(10),
          const SizedBox(
            width: 450,
            height: 120,
            child: _SubjectiveTrainingEfficiencyComponent(
              efficiency: 0.66, //widget.dynamicParams.subjectiveTrainingEfficiency,
            ),
          ),
        ],
      ),
    );
  }
}
