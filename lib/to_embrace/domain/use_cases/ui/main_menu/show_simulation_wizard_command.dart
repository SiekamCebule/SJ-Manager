import 'package:flutter/material.dart';
import 'package:sj_manager/features/simulations/presentation/simulation_wizard/simulation_wizard_options_repo.dart';
import 'package:sj_manager/general_ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/features/simulations/presentation/simulation_wizard/pages/simulation_wizard_dialog.dart';

class ShowSimulationWizardCommand {
  ShowSimulationWizardCommand({
    required this.context,
    required this.onFinish,
  });

  final BuildContext context;
  final Function(SimulationWizardOptions? optionsRepo) onFinish;

  Future<void> execute() async {
    final options = await showGeneralDialog<SimulationWizardOptions?>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      barrierLabel: 'dismiss new simulation dialog',
      pageBuilder: (context, animationIn, animationOut) {
        return const Center(
          child: SizedBox(
            width: UiSpecificItemConstants.simulationWizardWidth,
            height: UiSpecificItemConstants.simulationWizardHeight,
            child: SimulationWizardDialog(),
          ),
        );
      },
      transitionDuration: Durations.medium1,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final fadeIn = CurvedAnimation(parent: animation, curve: Curves.easeInOutCirc);
        final fadeOut =
            CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeOutCirc)
                .drive(Tween(begin: 1.0, end: 0.0));
        return FadeTransition(
          opacity: fadeIn,
          child: FadeTransition(
            opacity: fadeOut,
            child: child,
          ),
        );
      },
    );
    onFinish(options);
  }
}
