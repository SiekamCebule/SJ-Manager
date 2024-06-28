import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/ui/app.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/screens/main_screen/main_menu_button.dart';

class MainMenuSettingsButton extends StatelessWidget {
  const MainMenuSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MainMenuButton(
      child: Row(
        children: [
          const Gap(20),
          Icon(
            Symbols.settings,
            size: UiConstants.mainMenuSmallerButtonIconSize,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const Gap(20),
          Text(
            translate(context).settings,
            style: GoogleFonts.dosis(
              color: Theme.of(context).colorScheme.primary,
              textStyle: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ],
      ),
      onTap: () {
        router.navigateTo(context, '/settings');
        Future.delayed(Duration(seconds: 3), () {
          router.pop(context);
        });
      },
    );
  }
}
