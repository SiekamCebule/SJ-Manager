part of '../simulation_wizard_dialog.dart';

class _DynamicContent extends StatefulWidget {
  const _DynamicContent();

  @override
  State<_DynamicContent> createState() => _DynamicContentState();
}

class _DynamicContentState extends State<_DynamicContent> {
  CountryFlagsRepo? _countryFlagsRepo;

  @override
  Widget build(BuildContext context) {
    final navCubit = context.watch<SimulationWizardNavigationCubit>();

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
              context.read<SimulationWizardOptionsRepo>().mode.set(mode);
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
                  context.read<SimulationWizardOptionsRepo>().team.set(team);
                  if (team != null) {
                    navCubit.unblockGoingForward();
                  } else {
                    navCubit.blockGoingForward();
                  }
                },
              ),
            ),
          SimulationWizardScreenType.subteam => _SubteamScreen(
              subteamTypes:
                  context.read<SimulationWizardOptionsRepo>().team.last!.facts.subteams,
              onChange: (subteamType) {
                context.read<SimulationWizardOptionsRepo>().subteamType.set(subteamType);
                if (subteamType != null) {
                  navCubit.unblockGoingForward();
                } else {
                  navCubit.blockGoingForward();
                }
              },
            ),
          SimulationWizardScreenType.startDate => _StartDateScreen(
              onChange: (startDate) {
                context.read<SimulationWizardOptionsRepo>().startDate.set(startDate);
                if (startDate != null) {
                  navCubit.unblockGoingForward();
                } else {
                  navCubit.blockGoingForward();
                }
              },
              gameVariant: context.read<SimulationWizardOptionsRepo>().gameVariant.last!,
            ),
          SimulationWizardScreenType.otherOptions => const _OtherOptionsScreen(),
          SimulationWizardScreenType.gameVariant => _GameVariantScreen(
              gameVariants: context.read<ItemsRepo<GameVariant>>().last,
              onChange: (variant) {
                context.read<SimulationWizardOptionsRepo>().gameVariant.set(variant);
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
