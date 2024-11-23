part of '../../../main_screen.dart';

class MainMenuSimulationsButton extends StatelessWidget {
  const MainMenuSimulationsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final simulationsState = context.watch<AvailableSimulationsCubit>().state;
    if (simulationsState is! AvailableSimulationsInitialized) {
      return const SizedBox();
    }
    return MainMenuOnlyTitleButton(
      titleText: translate(context).mySimulations,
      iconData: Symbols.open_in_new,
      onTap: simulationsState.simulations.isNotEmpty
          ? () async {
              await showSjmDialog(
                barrierDismissible: true,
                context: context,
                child: ChooseSimulationDialog(
                  simulations: simulationsState.simulations,
                  onChoose: (simulation) async {
                    router.pop(context);
                    await context.read<SimulationCubit>().choose(simulation);
                    if (!context.mounted) return;
                    router.navigateTo(context, '/simulation/${simulation.id}');
                  },
                  onDelete: (simulation) async {
                    router.pop(context);
                    await context.read<AvailableSimulationsCubit>().delete(simulation);
                  },
                ),
              );
            }
          : null,
    );
  }
}
