part of '../../../main_screen.dart';

class MainMenuSimulationsButton extends StatelessWidget {
  const MainMenuSimulationsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final simulationsRepo = context.watch<EditableItemsRepo<SimulationModel>>();
    return StreamBuilder(
      stream: simulationsRepo.items,
      builder: (context, snapshot) {
        final enabled = simulationsRepo.last.isNotEmpty;
        return MainMenuOnlyTitleButton(
          titleText: translate(context).mySimulations,
          iconData: Symbols.open_in_new,
          onTap: enabled
              ? () async {
                  await showSjmDialog(
                    barrierDismissible: true,
                    context: context,
                    child: ChooseSimulationDialog(
                      simulations:
                          context.read<EditableItemsRepo<SimulationModel>>().last,
                      onChoose: (simulation) {
                        router.pop(context);
                        router.navigateTo(context, '/simulation/${simulation.id}');
                      },
                      onDelete: (simulation) {
                        router.pop(context);
                        context
                            .read<EditableItemsRepo<SimulationModel>>()
                            .remove(simulation);
                      },
                    ),
                  );
                }
              : null,
        );
      },
    );
  }
}
