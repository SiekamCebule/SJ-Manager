import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/presentation/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/presentation/ui/screens/main_screen/large/widgets/generic/main_menu_card.dart';

class MainMenuOnlyTitleButton extends StatelessWidget {
  const MainMenuOnlyTitleButton({
    super.key,
    required this.titleText,
    required this.iconData,
    this.onTap,
  });

  final String titleText;
  final IconData iconData;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return MainMenuCard(
      borderRadius: const BorderRadius.all(UiMainMenuConstants.buttonsBorderRadius),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Gap(UiMainMenuConstants.horizontalSpaceBetweenButtonItems),
          Icon(
            iconData,
            size: UiMainMenuConstants.smallerButtonIconSize,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const Gap(UiMainMenuConstants.horizontalSpaceBetweenButtonItems),
          Text(
            titleText,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
    );
  }
}
