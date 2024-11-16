part of '../../../main_screen.dart';

class MainMenuSimulationsButton extends StatelessWidget {
  const MainMenuSimulationsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final simulationsRepo = context.watch<EditableItemsRepo<UserSimulationModel>>();
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
                          context.read<EditableItemsRepo<UserSimulationModel>>().last,
                      onChoose: (simulation) {
                        router.pop(context);
                        router.navigateTo(context, '/simulation/${simulation.id}');
                      },
                      onDelete: (simulation) {
                        router.pop(context);
                        context
                            .read<EditableItemsRepo<UserSimulationModel>>()
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
