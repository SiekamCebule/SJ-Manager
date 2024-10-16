part of '../../../main_screen.dart';

class MainMenuNewSimulationButton extends StatelessWidget {
  const MainMenuNewSimulationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MainMenuCard(
      borderRadius: const BorderRadius.all(UiMainMenuConstants.buttonsBorderRadius),
      onTap: () async {
        final optionsRepo = await showGeneralDialog<SimulationWizardOptionsRepo?>(
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
            final fadeIn =
                CurvedAnimation(parent: animation, curve: Curves.easeInOutCirc);
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
        if (!context.mounted) return;
        if (optionsRepo != null) {
          final database = DefaultSimulationDatabaseCreator(idGenerator: context.read())
              .create(optionsRepo);
          String? subteamCountryFlagPath;
          if (database.managerData.userSubteam != null) {
            final countryCode = optionsRepo.team.last!.country.code;
            subteamCountryFlagPath = fileInDirectory(
              simulationDirectory(
                pathsCache: context.read(),
                simulationId: optionsRepo.simulationId.last!,
                directoryName: 'countries/country_flags',
              ),
              '${countryCode.toLowerCase()}.png', // TODO: not only png
            ).path;
          }
          final userSimulation = UserSimulation(
            id: optionsRepo.simulationId.last!,
            name: optionsRepo.simulationName.last!,
            saveTime: DateTime.now(),
            database: database,
            subteamCountryFlagPath: subteamCountryFlagPath,
            mode: optionsRepo.mode.last!,
          );
          final simulationsRepo = context.read<EditableItemsRepo<UserSimulation>>();
          simulationsRepo.add(userSimulation);
          // TODO: disposing baz danych zapisów
          DefaultSimulationDatabaseSaverToFile(
            simulationId: userSimulation.id,
            pathsCache: context.read(),
            pathsRegistry: context.read(),
            idsRepo: database.idsRepo,
          ).serialize(
            database: database,
          );
          await copyDirectory(
            gameVariantDirectory(
              pathsCache: context.read(),
              gameVariantId: optionsRepo.gameVariant.last!.id,
              directoryName: path.join('countries', 'country_flags'),
            ),
            simulationDirectory(
              pathsCache: context.read(),
              simulationId: optionsRepo.simulationId.last!,
              directoryName: path.join('countries', 'country_flags'),
            ),
          );
          if (!context.mounted) return;
          await copyDirectory(
            gameVariantDirectory(
              pathsCache: context.read(),
              gameVariantId: optionsRepo.gameVariant.last!.id,
              directoryName: path.join('jumper_images'),
            ),
            simulationDirectory(
              pathsCache: context.read(),
              simulationId: optionsRepo.simulationId.last!,
              directoryName: path.join('jumper_images'),
            ),
          );
          if (!context.mounted) return;
          await UserSimulationsRegistrySaverToFile(
            userSimulations: simulationsRepo.last,
            pathsCache: context.read(),
          ).serialize();
          if (!context.mounted) return;
          router.navigateTo(context, '/simulation/${userSimulation.id}');
        }
      },
      child: MainMenuTextContentButtonBody(
        titleText: translate(context).newSimulation,
        contentText: translate(context).newSimulationButtonContent,
      ),
    );
  }
}
