import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/screens/main_screen/main_menu_button.dart';

class MainMenuLoadSimulationButton extends StatelessWidget {
  const MainMenuLoadSimulationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MainMenuButton(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Gap(20),
          Icon(
            Symbols.open_in_new,
            size: UiConstants.mainMenuSmallerButtonIconSize,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const Gap(20),
          Text(
            translate(context).loadSimulation,
            style: GoogleFonts.dosis(
              color: Theme.of(context).colorScheme.primary,
              textStyle: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ],
      ),
      onTap: () {},
    );
  }
}
