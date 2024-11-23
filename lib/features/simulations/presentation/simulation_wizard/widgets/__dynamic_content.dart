part of '../pages/simulation_wizard_dialog.dart';

class _DynamicContent extends StatefulWidget {
  const _DynamicContent();

  @override
  State<_DynamicContent> createState() => _DynamicContentState();
}

class _DynamicContentState extends State<_DynamicContent> {
  CountryFlagsRepository? _countryFlagsRepo;

  @override
  Widget build(BuildContext context) {
    final navCubit = context.watch<SimulationWizardNavigationCubit>();
    final options = context.watch<SimulationWizardOptions>();
    final gameVariantsState = context.read<GameVariantCubit>().state;
    if (gameVariantsState is! GameVariantAbleToChoose) {
      throw StateError(
        'Simulation wizard can\'t work when game variants cubit is not initialized (current state is $gameVariantsState)',
      );
    }

    return ClipRect(
      child: AnimatedSwitcher(
        duration: Durations.medium1,
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        transitionBuilder: (child, animation) {
          final slide = CurvedAnimation(parent: animation, curve: Curves.easeInOut).drive(
            Tween(begin: const Offset(-1, 0), end: Offset.zero),
          );
          return SlideTransition(
            position: slide,
            child: child,
          );
        },
        child: switch (navCubit.state.screen) {
          SimulationWizardScreenType.mode => _ModeScreen(onChange: (mode) {
              options.mode = mode;
              navCubit.mode = mode;
              if (mode != null) {
                navCubit.unblockGoingForward();
              } else {
                navCubit.blockGoingForward();
              }
            }),
          SimulationWizardScreenType.team => Provider.value(
              value: _countryFlagsRepo,
              child: _TeamScreen(
                onChange: (team) {
                  options.team = team;
                  if (team != null) {
                    navCubit.unblockGoingForward();
                  } else {
                    navCubit.blockGoingForward();
                  }
                },
              ),
            ),
          SimulationWizardScreenType.subteam => _SubteamScreen(
              subteamTypes: options.team!.facts.subteams,
              onChange: (subteamType) {
                options.subteamType = subteamType;
                if (subteamType != null) {
                  navCubit.unblockGoingForward();
                } else {
                  navCubit.blockGoingForward();
                }
              },
            ),
          SimulationWizardScreenType.startDate => _StartDateScreen(
              onChange: (startDate) {
                options.startDate = startDate;
                if (startDate != null) {
                  navCubit.unblockGoingForward();
                } else {
                  navCubit.blockGoingForward();
                }
              },
              gameVariant: context.read<SimulationWizardOptions>().gameVariant!,
            ),
          SimulationWizardScreenType.otherOptions => const _OtherOptionsScreen(),
          SimulationWizardScreenType.gameVariant => _GameVariantScreen(
              gameVariants: gameVariantsState.variants,
              onChange: (variant) {
                options.gameVariant = variant;
                if (variant != null) {
                  navCubit.unblockGoingForward();
                  _countryFlagsRepo ??= LocalStorageCountryFlagsRepo(
                    imagesDirectory: Directory(
                      path.join(
                        gameVariantDirectory(
                                pathsCache: context.read(), gameVariantId: variant.id)
                            .path,
                        'countries',
                        'country_flags',
                      ),
                    ),
                    imagesExtension: 'png',
                  );
                } else {
                  navCubit.blockGoingForward();
                }
              },
            ),
        },
      ),
    );
  }
}
