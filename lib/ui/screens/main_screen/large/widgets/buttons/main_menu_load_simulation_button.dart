part of '../../../main_screen.dart';

class MainMenuLoadSimulationButton extends StatelessWidget {
  const MainMenuLoadSimulationButton({super.key});

  @override
  Widget build(BuildContext context) {
    final simulationsRepo = context.watch<EditableItemsRepo<UserSimulation>>();
    return StreamBuilder(
        stream: simulationsRepo.items,
        builder: (context, snapshot) {
          final enabled = simulationsRepo.last.isNotEmpty;
          return MainMenuOnlyTitleButton(
            titleText: translate(context).loadSimulation,
            iconData: Symbols.open_in_new,
            onTap: enabled
                ? () async {
                    showSjmDialog(
                      barrierDismissible: true,
                      context: context,
                      child: ChooseSimulationDialog(
                        simulations:
                            context.read<EditableItemsRepo<UserSimulation>>().last,
                        onChoose: (simulation) {
                          router.pop(context);
                          router.navigateTo(context, '/simulation/${simulation.id}');
                        },
                      ),
                    );
                  }
                : null,
          );
        });
  }
}
