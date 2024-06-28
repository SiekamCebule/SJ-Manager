import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/ui/screens/main_screen/main_menu_button.dart';

class MainMenuNewSimulationButton extends StatelessWidget {
  const MainMenuNewSimulationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MainMenuButton(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              translate(context).newSimulation,
              style: GoogleFonts.dosis(
                color: Theme.of(context).colorScheme.primary,
                textStyle: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const Gap(10),
            Row(
              children: [
                const Gap(20),
                Flexible(
                  child: Text(
                    translate(context).newSimulationButtonContent,
                    style: GoogleFonts.dosis(
                      color: Theme.of(context).colorScheme.onSurface,
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                const Gap(20),
              ],
            ),
          ],
        ),
      ),
      onTap: () {},
    );
  }
}
