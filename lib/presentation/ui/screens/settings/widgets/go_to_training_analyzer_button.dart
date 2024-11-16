import 'package:flutter/material.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/link_text_button.dart';

class GoToTrainingAnalyzerButton extends StatelessWidget {
  const GoToTrainingAnalyzerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return LinkTextButton(
      onPressed: () {
        router.navigateTo(context, '/settings/trainingAnalyzer');
      },
      labelText: 'Training Analyzer',
      textStyle: Theme.of(context).textTheme.bodyLarge,
      iconSize: 22,
    );
  }
}
